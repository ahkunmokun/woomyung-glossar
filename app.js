/* 우명 용어집 / Woomyung-Glossar — 앱
   자료는 Supabase에 있고, 승인된 사람만 읽고 고칠 수 있다.
   이 파일에는 자료가 없다 — 그래서 저장소가 공개여도 용어집은 새지 않는다. */
'use strict';

var sb = window.supabase.createClient(window.CFG.url, window.CFG.anonKey);

var CATS = ['핵심 용어', '존재 · 우주', '마음 구조', '삶 · 세상',
            '방법 · 동사', '시어·표현', '시 제목', '표기 규칙'];
var CAT_DE = {
  '핵심 용어': 'Kernbegriffe', '존재 · 우주': 'Sein und Kosmos',
  '마음 구조': 'Struktur des Geistes', '삶 · 세상': 'Leben und Welt',
  '방법 · 동사': 'Methode und Verben', '시어·표현': 'Dichterische Wendungen',
  '시 제목': 'Gedichttitel', '표기 규칙': 'Schreibregeln'
};
var STATUS = ['확정', '맥락 선택', '검토 필요', '신규 제안'];
var ST_DE = {'확정': 'festgelegt', '맥락 선택': 'kontextabhängig',
             '검토 필요': 'zu prüfen', '신규 제안': 'neuer Vorschlag'};
var ST_CLASS = {'확정': 'fix', '맥락 선택': 'ctx', '검토 필요': 'rev', '신규 제안': 'new'};
var FIELDS = ['hj', 'de', 'st', 'en_sunri', 'en_wants', 'memo'];
var LABEL = {hj: '한자', de: '독일어', st: '상태',
             en_sunri: '순리 영문', en_wants: '가짐 영문', memo: '메모'};

var me = null;        // glossary_profiles 한 줄
var entries = [];
var histBy = {};      // entry_id -> [자취]
var openEditor = null;
var openHist = {};
var state = {q: '', cat: '전체', st: '전체', flagOnly: false};

var $ = function (id) { return document.getElementById(id); };
function esc(s) {
  return String(s == null ? '' : s).replace(/[&<>"]/g, function (c) {
    return {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;'}[c];
  });
}
function show(id, on) { $(id).hidden = !on; }
function notice(html) {
  $('notice').innerHTML = html ? '<div class="notice">' + html + '</div>' : '';
  if (html) setTimeout(function () { $('notice').innerHTML = ''; }, 9000);
}

/* ══ 로그인 · 가입 ══════════════════════════════════════════════ */
var mode = 'in';
function setMode(m) {
  mode = m;
  $('tab-in').setAttribute('aria-selected', String(m === 'in'));
  $('tab-up').setAttribute('aria-selected', String(m === 'up'));
  $('lb-name').hidden = (m !== 'up');
  $('f-name').required = (m === 'up');
  $('f-go').textContent = (m === 'in') ? '로그인 / Anmelden' : '가입 신청 / Registrieren';
  $('f-pw').setAttribute('autocomplete', m === 'in' ? 'current-password' : 'new-password');
  $('gate-hint').innerHTML = (m === 'in')
    ? '등록된 분만 볼 수 있습니다.<span class="de" style="display:block">Nur für freigegebene Mitarbeitende.</span>'
    : '가입한 뒤 <b>관리자 승인</b>을 받아야 용어집이 보입니다.'
      + '<span class="de" style="display:block">Nach der Registrierung ist eine '
      + '<b>Freigabe durch die Administratorin</b> erforderlich.</span>';
  $('gate-say').textContent = '';
  $('gate-say').className = 'say';
}
$('tab-in').addEventListener('click', function () { setMode('in'); });
$('tab-up').addEventListener('click', function () { setMode('up'); });

$('authform').addEventListener('submit', function (e) {
  e.preventDefault();
  var say = $('gate-say'), btn = $('f-go');
  var email = $('f-email').value.trim();
  var pw = $('f-pw').value;
  var name = $('f-name').value.trim();
  btn.disabled = true;
  say.className = 'say';
  say.textContent = mode === 'in' ? '들어가는 중…' : '보내는 중…';

  var p = (mode === 'in')
    ? sb.auth.signInWithPassword({email: email, password: pw})
    : sb.auth.signUp({email: email, password: pw, options: {data: {name: name}}});

  p.then(function (res) {
    if (res.error) throw res.error;
    if (mode === 'up' && !res.data.session) {
      say.className = 'say good';
      say.innerHTML = '메일로 보낸 확인 링크를 눌러 주세요.'
        + '<br><span style="font-style:italic">Bitte bestätigen Sie den Link in Ihrer E-Mail.</span>';
      btn.disabled = false;
      return;
    }
    boot();
  }).catch(function (err) {
    say.className = 'say bad';
    var m = String(err && err.message || '');
    if (/Invalid login/i.test(m)) {
      say.innerHTML = '메일이나 비밀번호가 맞지 않습니다.'
        + '<br><span style="font-style:italic">E-Mail oder Passwort ist falsch.</span>';
    } else if (/already registered/i.test(m)) {
      say.innerHTML = '이미 가입된 메일입니다 — 「로그인」으로 들어가세요.'
        + '<br><span style="font-style:italic">Bereits registriert — bitte anmelden.</span>';
    } else if (/Password/i.test(m)) {
      say.innerHTML = '비밀번호는 8자 이상이어야 합니다.'
        + '<br><span style="font-style:italic">Das Passwort muss mindestens 8 Zeichen haben.</span>';
    } else {
      say.textContent = m || '되지 않았습니다 / Fehlgeschlagen';
    }
    btn.disabled = false;
  });
});

function signOut() {
  sb.auth.signOut().then(function () { location.reload(); });
}
$('logout').addEventListener('click', signOut);
$('logout2').addEventListener('click', signOut);
$('recheck').addEventListener('click', function () {
  $('wait-say').textContent = '확인 중…';
  boot();
});

/* ══ 들어온 뒤 ══════════════════════════════════════════════════ */
function boot() {
  sb.auth.getUser().then(function (r) {
    var user = r.data && r.data.user;
    if (!user) {
      show('gate', true); show('waiting', false); show('bar', false);
      show('legend', false); show('userbar', false); show('adminpane', false);
      $('list').innerHTML = '';
      return;
    }
    return sb.from('glossary_profiles').select('*').eq('id', user.id).maybeSingle()
      .then(function (pr) {
        me = pr.data || {id: user.id, email: user.email, name: '', approved: false, role: 'member'};
        show('gate', false);
        show('userbar', true);
        $('whoami').textContent = (me.name || me.email || '');
        $('rolebadge').textContent = me.role === 'admin' ? '관리자 / Admin'
          : me.approved ? '승인됨 / freigegeben' : '대기 / wartet';
        $('rolebadge').className = 'badge' + (me.role === 'admin' ? ' admin' : '');

        if (!me.approved) {
          show('waiting', true); show('bar', false); show('legend', false);
          show('adminpane', false);
          $('wait-say').textContent = '';
          return;
        }
        show('waiting', false);
        show('bar', true); show('legend', true);
        if (me.role === 'admin') { show('adminpane', true); loadPeople(); }
        loadEntries();
      });
  }).catch(function (e) {
    notice('불러오지 못했습니다 / Laden fehlgeschlagen: ' + esc(String(e && e.message || e)));
  });
}

/* ══ 관리자 — 승인 ══════════════════════════════════════════════ */
function loadPeople() {
  sb.from('glossary_profiles').select('*').order('created_at', {ascending: false})
    .then(function (r) {
      if (r.error) { $('people').innerHTML = '<p class="say bad">' + esc(r.error.message) + '</p>'; return; }
      var list = r.data || [];
      var waitN = list.filter(function (p) { return !p.approved; }).length;
      $('people').innerHTML = (waitN
        ? '<p class="say" style="margin-bottom:8px">승인을 기다리는 사람 <b>' + waitN
          + '</b>명 / <span style="font-style:italic">' + waitN + ' warten auf Freigabe</span></p>'
        : '<p class="say" style="margin-bottom:8px">기다리는 사람이 없습니다 / '
          + '<span style="font-style:italic">Keine offenen Anfragen</span></p>')
        + list.map(function (p) {
            var isMe = (p.id === me.id);
            return '<div class="person">'
              + '<span class="nm">' + esc(p.name || '(이름 없음)') + '</span>'
              + '<span class="em">' + esc(p.email || '') + '</span>'
              + '<span class="badge' + (p.role === 'admin' ? ' admin' : '') + '">'
              + (p.role === 'admin' ? '관리자 / Admin'
                 : p.approved ? '승인됨 / freigegeben' : '대기 / wartet') + '</span>'
              + '<span class="sp">'
              + (isMe ? ''
                 : (p.approved
                    ? '<button class="no" data-act="revoke" data-id="' + p.id + '">승인 취소 / Entziehen</button>'
                    : '<button class="ok" data-act="approve" data-id="' + p.id + '">승인 / Freigeben</button>'))
              + '</span></div>';
          }).join('');
    });
}

$('people').addEventListener('click', function (e) {
  var b = e.target.closest('[data-act]');
  if (!b) return;
  var approve = b.getAttribute('data-act') === 'approve';
  b.disabled = true;
  sb.from('glossary_profiles').update({approved: approve}).eq('id', b.getAttribute('data-id'))
    .then(function (r) {
      if (r.error) { notice(esc(r.error.message)); b.disabled = false; return; }
      notice(approve ? '승인했습니다 / Freigegeben' : '승인을 거두었습니다 / Freigabe entzogen');
      loadPeople();
    });
});

/* ══ 용어집 ═════════════════════════════════════════════════════ */
function loadEntries() {
  sb.from('glossary_entries').select('*').order('sort_no', {ascending: true})
    .then(function (r) {
      if (r.error) {
        $('list').innerHTML = '<div class="empty"><p>불러오지 못했습니다 / Laden fehlgeschlagen</p>'
          + '<p>' + esc(r.error.message) + '</p></div>';
        return;
      }
      entries = r.data || [];
      buildChips();
      render();
      return sb.from('glossary_history').select('*').order('at', {ascending: true});
    }).then(function (r) {
      if (!r || r.error) return;
      histBy = {};
      (r.data || []).forEach(function (h) {
        (histBy[h.entry_id] = histBy[h.entry_id] || []).push(h);
      });
      render();
    });
}

function hay(d) {
  return [d.ko, d.hj, d.de, d.en_sunri, d.en_wants, d.memo, d.poem, d.cat]
    .join(' ').toLowerCase();
}
function matches(d) {
  if (state.cat !== '전체' && d.cat !== state.cat) return false;
  if (state.st !== '전체' && d.st !== state.st) return false;
  if (state.flagOnly && !d.flag) return false;
  if (state.q && hay(d).indexOf(state.q.toLowerCase()) < 0) return false;
  return true;
}
function mark(text, q) {
  var t = esc(text);
  if (!q) return t;
  var i = t.toLowerCase().indexOf(q.toLowerCase());
  if (i < 0) return t;
  return t.slice(0, i) + '<mark>' + t.slice(i, i + q.length) + '</mark>' + t.slice(i + q.length);
}
function when(t) {
  if (!t) return '';
  try { return new Date(t).toLocaleDateString('ko-KR'); } catch (e) { return ''; }
}
function engLine(label, val, q) {
  if (!val) return '';
  var un = String(val).indexOf('⟨미확인⟩') >= 0;
  var clean = String(val).replace(' ⟨미확인⟩', '');
  return '<dt>' + label + '</dt><dd>' + mark(clean, q)
    + (un ? ' <span class="unconf">미확인 / unbest.</span>' : '') + '</dd>';
}

function entryHTML(d, q) {
  if (openEditor === d.id) return editorHTML(d);
  var hist = histBy[d.id] || [];
  var en = engLine('순리', d.en_sunri, q) + engLine('가짐', d.en_wants, q);
  var where = [d.book, d.poem].filter(Boolean).join(' · ');
  var histHTML = '';
  if (openHist[d.id] && hist.length) {
    histHTML = '<div class="hist">' + hist.slice().reverse().map(function (h) {
      return '<div>' + esc(h.by_name || '?') + ' · ' + when(h.at) + ' — '
        + esc(LABEL[h.field] || h.field) + ': '
        + esc(h.old_value || '(없음)') + ' → ' + esc(h.new_value || '(없음)') + '</div>';
    }).join('') + '</div>';
  }
  return '<article class="entry' + (d.updated_by ? ' touched' : '') + '">'
    + '<div class="head"><span class="ko">' + mark(d.ko, q) + '</span>'
    + (d.hj ? '<span class="hj">' + mark(d.hj, q) + '</span>' : '') + '</div>'
    + '<div class="body-col">'
    + '<div class="de-line"><span class="de">' + mark(d.de, q) + '</span>'
    + '<span class="pill ' + (ST_CLASS[d.st] || 'fix') + '">' + esc(d.st)
    + (ST_DE[d.st] ? ' / ' + ST_DE[d.st] : '') + '</span>'
    + (d.flag ? '<span class="flagmark" title="결정 대기 / offen">&#9888;</span>' : '')
    + '</div>'
    + (en ? '<dl class="en">' + en + '</dl>' : '')
    + (d.memo ? '<p class="memo">' + mark(d.memo, q) + '</p>' : '')
    + (d.why ? '<p class="why">' + esc(d.why) + '</p>' : '')
    + (where ? '<p class="where">' + esc(where) + '</p>' : '')
    + (d.updated_by ? '<p class="byline">' + esc(d.updated_by) + ' · '
        + when(d.updated_at) + '에 고침 / geändert</p>' : '')
    + histHTML
    + '</div>'
    + '<div class="tools">'
    + '<button class="tool" data-act="edit" data-id="' + d.id + '">고치기 / ändern</button>'
    + (hist.length ? '<button class="tool" data-act="hist" data-id="' + d.id + '">이력 '
        + hist.length + '</button>' : '')
    + '</div></article>';
}

function stOptions(cur) {
  return STATUS.map(function (s) {
    var lock = (s === '확정' && me.role !== 'admin' && cur !== '확정');
    return '<option value="' + esc(s) + '"' + (s === cur ? ' selected' : '')
      + (lock ? ' disabled' : '') + '>' + esc(s) + ' / ' + esc(ST_DE[s])
      + (lock ? ' (Admin)' : '') + '</option>';
  }).join('');
}

function editorHTML(d) {
  return '<article class="entry">'
    + '<div class="head"><span class="ko">' + esc(d.ko) + '</span></div>'
    + '<div class="body-col" style="grid-column:2/-1">'
    + '<form class="editor" data-id="' + d.id + '">'
    + '<label>독일어 / Deutsch<input class="de-in" name="de" value="' + esc(d.de) + '" maxlength="200"></label>'
    + '<label>상태 / Status<select name="st">' + stOptions(d.st) + '</select></label>'
    + '<label>한자 / Chinesisch<input name="hj" value="' + esc(d.hj) + '" maxlength="40"></label>'
    + '<label>순리 영문 / Engl. (Sunri)<input name="en_sunri" value="' + esc(d.en_sunri) + '" maxlength="200"></label>'
    + '<label>가짐 영문 / Engl. (Wants)<input name="en_wants" value="' + esc(d.en_wants) + '" maxlength="200"></label>'
    + '<label class="ed-wide">메모 / Anmerkung &mdash; 왜 이렇게 옮기나 · Begründung'
    + '<textarea name="memo" maxlength="900">' + esc(d.memo) + '</textarea></label>'
    + '<div class="ed-foot"><button class="go" type="submit" style="padding:8px 18px">저장 / Speichern</button>'
    + '<button class="plain" type="button" data-act="close">그만 / Abbrechen</button>'
    + '<span class="say" data-say></span></div>'
    + '</form></div></article>';
}

function addFormHTML() {
  return '<form class="editor" id="addform" style="margin:20px 0 0">'
    + '<label>한국어 / Koreanisch *<input name="ko" required maxlength="80"></label>'
    + '<label>독일어 / Deutsch<input class="de-in" name="de" maxlength="200"></label>'
    + '<label>한자 / Chinesisch<input name="hj" maxlength="40"></label>'
    + '<label>분류 / Kategorie<select name="cat">'
    + CATS.map(function (c) {
        return '<option value="' + esc(c) + '">' + esc(c) + ' / ' + esc(CAT_DE[c]) + '</option>';
      }).join('') + '</select></label>'
    + '<label>영어 / Englisch<input name="en_sunri" maxlength="200"></label>'
    + '<label>어디에 나오나 / Buch · Gedicht<input name="poem" maxlength="120"></label>'
    + '<label class="ed-wide">메모 / Anmerkung<textarea name="memo" maxlength="900"></textarea></label>'
    + '<div class="ed-foot"><button class="go" type="submit" style="padding:8px 18px">넣기 / Hinzufügen</button>'
    + '<button class="plain" type="button" data-act="closeadd">그만 / Abbrechen</button>'
    + '<span class="say" data-say></span></div></form>';
}

function render() {
  var hits = entries.filter(matches);
  var list = $('list');
  if (!hits.length) {
    list.innerHTML = '<div class="empty"><p>찾은 낱말이 없습니다 / Kein Eintrag gefunden</p>'
      + '<p>찾는 말을 줄여 보세요 / Bitte Suchbegriff kürzen</p></div>';
  } else {
    var html = '';
    CATS.forEach(function (c) {
      var inCat = hits.filter(function (d) { return d.cat === c; });
      if (!inCat.length) return;
      html += '<section class="cat"><div class="cat-head"><h2>' + esc(c) + '</h2>'
        + '<span class="cat-de">/ ' + esc(CAT_DE[c] || '') + '</span>'
        + '<span class="n">' + inCat.length + '</span></div>'
        + inCat.map(function (d) { return entryHTML(d, state.q); }).join('')
        + '</section>';
    });
    list.innerHTML = html;
  }
  var nMod = entries.filter(function (d) { return d.updated_by; }).length;
  $('count').innerHTML = '<b>' + hits.length + '</b>개 보임 · 전체 ' + entries.length
    + (nMod ? ' · 고쳐진 것 <b>' + nMod + '</b>' : '');
  syncChips();
}

function countBy(fn) {
  var a = {};
  entries.forEach(function (d) { var k = fn(d); a[k] = (a[k] || 0) + 1; });
  return a;
}
function syncChips() {
  ['f-cat', 'f-st'].forEach(function (id) {
    var row = $(id), key = row.getAttribute('data-key');
    Array.prototype.forEach.call(row.querySelectorAll('.chip'), function (b) {
      b.setAttribute('aria-pressed', b.classList.contains('warn')
        ? String(state.flagOnly) : String(state[key] === b.getAttribute('data-val')));
    });
  });
}
function buildChips() {
  var cc = countBy(function (d) { return d.cat; });
  var sc = countBy(function (d) { return d.st; });
  function fill(id, key, values, counts, labeler, extra) {
    var row = $(id);
    row.setAttribute('data-key', key);
    row.innerHTML = '<span class="flabel">' + (key === 'cat' ? '분류' : '상태') + '</span>';
    function add(label, val, n, cls) {
      var b = document.createElement('button');
      b.type = 'button';
      b.className = 'chip' + (cls ? ' ' + cls : '');
      b.innerHTML = esc(label) + (n == null ? '' : '<span class="n">' + n + '</span>');
      b.setAttribute('data-val', val);
      b.addEventListener('click', function () {
        if (cls === 'warn') state.flagOnly = !state.flagOnly; else state[key] = val;
        render();
      });
      row.appendChild(b);
    }
    add('전체 / alle', '전체', null);
    values.forEach(function (v) { if (counts[v]) add(labeler(v), v, counts[v]); });
    if (extra) extra(add);
  }
  fill('f-cat', 'cat', CATS, cc, function (c) { return c; });
  fill('f-st', 'st', STATUS, sc, function (s) { return s + ' / ' + ST_DE[s]; },
    function (add) {
      var n = entries.filter(function (d) { return d.flag; }).length;
      if (n) add('⚠ 결정 대기 / offen', '__flag__', n, 'warn');
    });
}

$('q').addEventListener('input', function () { state.q = this.value.trim(); render(); });
document.addEventListener('keydown', function (e) {
  if (e.key === 'Escape' && openEditor) { openEditor = null; render(); }
});

/* ── 고치기 ─────────────────────────────────────────────────── */
document.addEventListener('click', function (e) {
  var b = e.target.closest ? e.target.closest('[data-act]') : null;
  if (!b || b.parentElement === $('people') || $('people').contains(b)) return;
  var act = b.getAttribute('data-act'), id = b.getAttribute('data-id');
  if (act === 'edit') {
    openEditor = id; render();
    var f = document.querySelector('.editor[data-id="' + id + '"] [name="de"]');
    if (f) f.focus();
  } else if (act === 'close') {
    openEditor = null; render();
  } else if (act === 'hist') {
    openHist[id] = !openHist[id]; render();
  } else if (act === 'closeadd') {
    $('addarea').innerHTML = '';
  }
});

$('addbtn').addEventListener('click', function () {
  $('addarea').innerHTML = addFormHTML();
  $('addarea').querySelector('[name="ko"]').focus();
});

function formVals(form) {
  var v = {};
  Array.prototype.forEach.call(form.querySelectorAll('[name]'), function (el) {
    v[el.name] = el.value.trim();
  });
  return v;
}

document.addEventListener('submit', function (e) {
  var form = e.target;
  if (!form.classList.contains('editor')) return;
  e.preventDefault();
  var say = form.querySelector('[data-say]');
  var btn = form.querySelector('button[type="submit"]');
  if (form.id === 'addform') saveNew(form, say, btn); else saveEdit(form, say, btn);
});

function failText(err) {
  var m = String(err && err.message || err || '');
  if (/확정|festgelegt/.test(m)) {
    return '「확정」은 관리자만 정할 수 있습니다 / Nur Admin darf „festgelegt" setzen';
  }
  if (/row-level security|violates/i.test(m)) {
    return '고칠 권한이 없습니다 / Keine Berechtigung';
  }
  return m || '저장하지 못했습니다 / Speichern fehlgeschlagen';
}

function saveEdit(form, say, btn) {
  var id = form.getAttribute('data-id');
  var cur = entries.filter(function (d) { return d.id === id; })[0];
  if (!cur) return;
  var v = formVals(form);
  var diffs = [];
  FIELDS.forEach(function (f) {
    if (v[f] !== undefined && v[f] !== (cur[f] || '')) {
      diffs.push({field: f, old_value: cur[f] || '', new_value: v[f]});
    }
  });
  if (!diffs.length) { openEditor = null; render(); return; }

  var patch = {updated_by: (me.name || me.email || ''), updated_at: new Date().toISOString()};
  diffs.forEach(function (d) { patch[d.field] = d.new_value; });

  btn.disabled = true; say.className = 'say'; say.textContent = '저장 중… / speichert…';
  sb.from('glossary_entries').update(patch).eq('id', id).select().then(function (r) {
    if (r.error) throw r.error;
    return sb.from('glossary_history').insert(diffs.map(function (d) {
      return {entry_id: id, entry_ko: cur.ko, field: d.field,
              old_value: d.old_value, new_value: d.new_value,
              by_name: (me.name || me.email || ''), by_user: me.id};
    }));
  }).then(function () {
    openEditor = null;
    notice('<b>' + esc(cur.ko) + '</b> 저장했습니다 / gespeichert');
    loadEntries();
  }).catch(function (err) {
    say.className = 'say bad'; say.textContent = failText(err);
    btn.disabled = false;
  });
}

function saveNew(form, say, btn) {
  var v = formVals(form);
  if (!v.ko) { say.className = 'say bad'; say.textContent = '한국어는 넣어 주세요 / Koreanisch fehlt'; return; }
  var row = {
    id: 'n' + Date.now().toString(36) + Math.random().toString(36).slice(2, 6),
    sort_no: 9000, cat: v.cat || CATS[0], ko: v.ko, hj: v.hj || '', de: v.de || '',
    st: '신규 제안', flag: false, why: '', en_sunri: v.en_sunri || '', en_wants: '',
    book: '앱에서 넣음', poem: v.poem || '', memo: v.memo || '',
    updated_by: (me.name || me.email || ''), updated_at: new Date().toISOString()
  };
  btn.disabled = true; say.className = 'say'; say.textContent = '넣는 중… / fügt hinzu…';
  sb.from('glossary_entries').insert(row).then(function (r) {
    if (r.error) throw r.error;
    $('addarea').innerHTML = '';
    notice('<b>' + esc(v.ko) + '</b> 넣었습니다 / hinzugefügt');
    loadEntries();
  }).catch(function (err) {
    say.className = 'say bad'; say.textContent = failText(err);
    btn.disabled = false;
  });
}

/* ══ 시작 ═══════════════════════════════════════════════════════ */
setMode('in');
boot();
sb.auth.onAuthStateChange(function (ev) {
  if (ev === 'SIGNED_IN' || ev === 'SIGNED_OUT') boot();
});
