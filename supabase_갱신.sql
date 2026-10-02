-- ════════════════════════════════════════════════════════════════════
--  우명 용어집 — 사이트 갱신  (2026-10-02)
--  마스터 208개에 맞춰 사이트의 용어집을 고칩니다.
--
--  ★동료가 사이트에서 고친 줄은 건드리지 않습니다.
--    덮어쓰는 것은 「아무도 손대지 않은 줄」뿐입니다.
--    무엇을 건너뛰었는지는 맨 끝에 나옵니다.
-- ════════════════════════════════════════════════════════════════════

-- ── 0. 칸 채비 ──────────────────────────────────────────────────
-- 「만나는 방법」 영문 칸을 더합니다 (이미 있으면 그냥 넘어갑니다)
alter table glossary_entries
  add column if not exists en_meeting text not null default '',
  add column if not exists en_heaven  text not null default '',
  add column if not exists ex_ko      text not null default '',
  add column if not exists ex_en      text not null default '',
  add column if not exists ex_de      text not null default '';


-- ── 1. 지금 사이트 형편 ─────────────────────────────────────────
select
  count(*)                                   as "지금_모두",
  count(*) filter (where updated_by <> '')   as "동료가_고친_것"
from glossary_entries;


-- ── 2. 동료가 고친 것 — 지워지지 않습니다. 눈으로 보세요 ────────
select ko as "한국어", de as "지금 독일어", st as "상태",
       updated_by as "고친 이", to_char(updated_at, 'MM-DD HH24:MI') as "언제"
from glossary_entries
where updated_by <> ''
order by updated_at desc;


-- ── 3. 갱신 (손대지 않은 줄만) ──────────────────────────────────
insert into glossary_entries
  (id, sort_no, cat, ko, hj, de, st, flag, why,
   en_sunri, en_wants, en_meeting, en_heaven, ex_ko, ex_en, ex_de, book, poem, memo)
values
  ('e420ba6560730', 1, '핵심 용어', '가진 마음', '', 'ein besitzender Geist', '확정', false, '', 'one''s mind (as attachment)', 'the mind he has', '', '', '가진 마음을 완전히 버리도록', 'how to completely discard the mind he has', '', '순리 · 가짐', '깨달음', '영문본: 가진 마음을 완전히 버리도록 → how to completely discard the mind he has'),
  ('e7bb31572f798', 2, '핵심 용어', '가짐 / 가짐 없음', '', 'Besitz / ohne Besitz', '검토 필요', true, '⚠메모에 결정 필요 사항 / ⚠상태 상이: 순리 「확정」 / 철학용어집 「검토 필요」', 'possession / non-possession ⟨미확인⟩', 'wants / absence of wants', '', '', '', '', '', '순리 · 가짐', '', '시 제목 Wants. 영문본은 소유(Besitz)가 아니라 욕구(wants)로 번역. ⚠ 다른 기록엔 가짐 → das Haben — Besitz / Haben / Begehren 중 결정 필요'),
  ('ee97474792108', 3, '핵심 용어', '거짓', '', 'das Falsche (nichts Falsches)', '확정', false, '', '', '', 'falseness', '', '', '', '', '만나는 방법 · 하늘사람', '', '★Falschheit 쓰지 않는다 — 위선·음흉함으로 읽힌다 (저자 확정 2026-09-27). ⚠「허」도 das Falsche 라서 겹친다 — 「허」 줄을 보라'),
  ('ebc4a981568ab', 4, '핵심 용어', '거짓 나 · 거짓말 나', '', 'falsches Selbst / falsches Ich', '맥락 선택', false, '', 'false self ⟨미확인⟩', 'false self ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '도(道)', '★둘 다 쓴다 — 번역자가 자리에 맞게 고른다 (저자 확정 2026-09-26). 참나(wahres Selbst)와 짝을 이룰 때는 falsches Selbst 가 어울린다'),
  ('e1eba93348531', 5, '핵심 용어', '깨친 자', '', 'der Erleuchtete', '확정', false, '', 'an enlightened person', 'the enlightened one ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '깨달음', ''),
  ('ee984c8dfacea', 6, '핵심 용어', '깨침 · 깨치다', '', 'Erleuchtung / erleuchtet werden', '신규 제안', false, '', '', '', 'enlightenment / become enlightened', 'enlightened', '깨친 자는 아무도 없다', '', 'Doch zum Erleuchteten ist keiner geworden.', '만나는 방법 · 하늘사람', '', '깨달음과 같은 독일어. 깨친 자 → der Erleuchtete(확정)와 이어진다. 보기: 「깨친 자는 아무도 없다」 → Doch zum Erleuchteten ist keiner geworden.'),
  ('ef758529589af', 7, '핵심 용어', '너나', '', 'Ich und Du', '확정', false, '', 'you and I ⟨미확인⟩', 'you and me', '', '', '참의 삶이란 너나가 없고', 'there is no distinction between you and me', 'Vollkommen ist, was keinen Tod kennt: Ein Land, das ewig lebt, ist das vollkommene Land. Diese Welt wird erst dann vollkommen eins, wenn die Menschen mit dem Geist der großen Natur wiedergeboren werden. Mit anderen Worten: Nur wenn man mit dem Geist des Universums, der Gott ist, neu geboren wird, gibt es kein Du und Ich mehr; alle werden eins und leben als das Wahre ohne Tod – erst das ist vollkommen.', '순리 · 가짐', '도(道)', '영문본: 참의 삶이란 너나가 없고 → there is no distinction between you and me'),
  ('e9c30b3b92876', 8, '핵심 용어', '대각', '大覺', 'große Erleuchtung', '확정', false, '', 'great enlightenment ⟨미확인⟩', 'great enlightenment ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '열반송', '대각의 경지 → Zustand der großen Erleuchtung'),
  ('ede8b6c7871ea', 9, '핵심 용어', '도', '道', 'Dō', '확정', false, '', 'the Way / Tao ⟨미확인⟩', 'dō (Truth)', '', '', '', '', '', '순리 · 가짐', '도(道), 자아 발견', '마크론 유지. 첫 등장 시 Dō (Wahrheit). 도를 하다 → Dō praktizieren. 영문본도 첫 표기 ''dō (Truth)''로 같은 구조'),
  ('e3f45761dbe05', 10, '핵심 용어', '마음', '', 'Geist / Herz / Bewusstsein', '맥락 선택', false, '', 'mind', 'mind', '', 'mind', '현재 자기가 살아가고 있는 것이 인간의 마음이다.', '', 'Der Geist des Menschen ist die Art, wie man gegenwärtig lebt.', '순리 · 가짐 · 하늘사람', '', '★셋 다 쓰고 번역자가 고른다 (저자 확정 2026-09-26). 기본은 Geist(철학적·인식) · 정서의 자리는 Herz · 의식의 자리는 Bewusstsein'),
  ('e6687c0a6a05d', 11, '핵심 용어', '만상', '萬象', 'alle Wesen', '맥락 선택', false, '', 'all things / all beings ⟨미확인⟩', 'all things ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '', '초기엔 alle Dinge. 나그네 시부터 alle Wesen. 순리 번역규칙도 둘을 함께 적음. (영문본은 「천지만상」 단위로만 확인됨)'),
  ('e4fe9cf4d2e62', 12, '핵심 용어', '무상', '無常', 'Vergänglichkeit', '확정', false, '', 'impermanence ⟨미확인⟩', '', '', '', '', '', '', '순리', '서시', ''),
  ('ee9a517fc86fb', 13, '핵심 용어', '미완성', '未完成', 'unvollendet', '신규 제안', false, '', '', '', 'incomplete', '', '그것은 가짜라 인간이 미완성인 것이다.', 'Since those pictures are not real, humans are incomplete.', '', '만나는 방법 · 하늘사람', '', '★unvollkommen 아님. 인간 완성(die Vollendung des Menschen)과 짝. 「완전 / 완성」 줄도 보라'),
  ('ea1405eb13538', 14, '핵심 용어', '본래 없음', '', 'ursprüngliche Nichtexistenz', '확정', false, '', 'original non-existence ⟨미확인⟩', '', '', '', '', '', '', '순리', '열반송', ''),
  ('e6297e393a80b', 15, '핵심 용어', '본시 · 원래', '本是', 'von Anfang an / ursprünglich', '확정', false, '', 'originally / from the beginning ⟨미확인⟩', '', '', '', '', '', '', '순리', '열반송', ''),
  ('e2f826f3ee651', 16, '핵심 용어', '사진', '寫眞', 'Aufnahme / Bild', '맥락 선택', false, '', '', '', 'pictures', '', '인간의 마음은 살아오면서 세상의 것을 사진 찍은 것이라', 'The human mind is the pictures that one has taken of the things in the world', 'Der Mensch lebt in diesem Film. Er hat noch kein einziges Mal in der vollkommenen Welt gelebt. Erst wenn wir diese Bilderwelt ganz loslassen und aus ihr heraustreten, können wir eins mit der vollendeten Welt leben. Diese Welt ist bereits vollendet, und sie ist bereits erleuchtet.', '만나는 방법', '마음이란', '★둘 다 쓰고 번역자가 자리에 맞게 고른다 (저자 확정 2026-09-27). 사진기의 비유를 살릴 때는 Aufnahme. ⚠상(相)도 Bild 이므로 한 대목에 둘이 함께 나오면 갈라 쓴다 (보기: 「마음속에 있는 것은 허이고 사진이다」 → das Falsche und Aufnahmen) ★「사진세계」는 Bilderwelt / Aufnahmewelt — 따로 세운 줄을 보라'),
  ('e3299d0c5f4f3', 17, '핵심 용어', '상', '相', 'Bild', '확정', false, '', 'images', 'image ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '자연의 흐름 속의 삶', '대안 Vorstellung, Abbild. 반복을 살리기 위해 Bild. ⚠사진(寫眞)도 Bild 를 쓴다 — 한 대목에 둘이 함께 나오면 갈라 쓴다 (사진 → Aufnahme)'),
  ('e2bd3a4071175', 18, '핵심 용어', '상념체', '想念體', 'Gedankenmasse', '확정', false, '', 'thought-mass', 'mass of thoughts ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '깨달음', ''),
  ('e55637d14ea2c', 19, '핵심 용어', '세상 마음', '', 'der Geist der Welt', '신규 제안', false, '', '', '', 'the mind of the world', '', '', '', '', '만나는 방법', '', ''),
  ('e6dd1a9f13d3f', 20, '핵심 용어', '순리', '順理', 'natürlicher Fluss / der Lauf der Natur', '맥락 선택', false, '', 'nature''s flow', 'Nature''s flow / the flow of Nature', '', '', '', '', '', '순리 · 가짐', '', '★★시집 제목은 natürlicher Fluss 로 고정한다. 본문에서는 둘 다 쓰고 번역자가 자리에 맞게 고른다 (저자 확정 2026-09-26). 본문에 나온 다른 꼴: im Lauf der Natur · natürlicher Lauf der Dinge'),
  ('e19c4fb84001e', 21, '핵심 용어', '스님 · 승', '僧', 'Mönch', '확정', false, '', 'monk ⟨미확인⟩', '', '', '', '', '', '', '순리', '자아 발견', 'buddhistisch 수식어 없이'),
  ('e5f74adfb9eb8', 22, '핵심 용어', '습', '習', 'Gewohnheit / Gewohnheiten', '맥락 선택', false, '', 'habit ⟨미확인⟩', 'habit(s) ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '', '★홑수·겹수 둘 다 쓰고 번역자가 자리에 맞게 고른다 (저자 확정 2026-09-26). 업과 습 → Karma und Gewohnheit'),
  ('e16e8e4fd0620', 23, '핵심 용어', '얽매임 · 집착', '執着', 'Anhaftung', '확정', false, '', 'attachment', 'attachment ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '깨달음', ''),
  ('e35388af76950', 24, '핵심 용어', '업', '業', 'Karma', '확정', false, '', 'karma ⟨미확인⟩', 'karma ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '', ''),
  ('e98acb69f31cc', 25, '핵심 용어', '없는 마음 · 마음이 없다', '', '(미결)', '검토 필요', true, '⚠독일어가 아직 비어 있다 (미결) — 정해야 함', 'absent of mind', '', '', '', '', '', '', '순리', '깨달음, 서시', 'zu rein 은 스스로 깨끗하다 말하는 느낌이라 제외. 거론된 안: wenn der Geist nicht unterscheidet / frei von Unreinheit. 「이렇다 저렇다 하는 것이 없어 있고 없음이 같은 상태」를 담을 최종안 미정'),
  ('e47f13f8bdc87', 26, '핵심 용어', '열반', '涅槃', 'Nirwana', '확정', false, '', 'nirvana ⟨미확인⟩', 'nirvana ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '열반송', '중성명사 das Nirwana. 직역 대안 Erlöschen'),
  ('ec9c118f6483a', 27, '핵심 용어', '완전 · 완성', '完成', 'vollkommen / vollendet', '확정', false, '', '', '', '', 'complete', '', '', '', '하늘사람', '', '★미완성 → unvollendet 와 짝. vollkommen(완전) · vollendet(완성)'),
  ('e4316fb9baf97', 28, '핵심 용어', '우주의 마음', '宇宙', 'der Geist des Universums', '신규 제안', false, '', '', '', 'the universe mind', '', '', '', '', '만나는 방법', '', '우주의 허공 → Leere des Universums 와 짝'),
  ('e8b42ef9c531b', 29, '핵심 용어', '우주의 허공', '虛空', 'Leere des Universums', '확정', false, '', 'the emptiness of the universe', '', '', '', '', '', '', '순리', '깨달음', ''),
  ('e4e0790b7fe6a', 30, '핵심 용어', '인간 완성', '人間完成', 'die Vollendung des Menschen', '확정', false, '', '', '', 'human completion', 'human completion', '살아 있을 때 참이 되고 살아 있을 때 천국 나 있지 않은 자가 천국 간다는 것은 이치에 맞지 않은 소리가 아닌가. 살아서 인간 완성인 참이 되려면 허인 자기가 다 없어져야 참이 될 것이다.', '', 'Wer nicht schon zu Lebzeiten wahr geworden und nicht schon zu Lebzeiten im Himmel geboren ist – dass so jemand in den Himmel kommen soll, widerspricht das nicht jeder Vernunft? Um schon zu Lebzeiten wahr zu werden, also die Vollendung des Menschen zu erreichen, muss das falsche Selbst vollständig verschwinden; erst dann wird man wahr.', '만나는 방법 · 하늘사람', '', '동사 꼴: zur Vollendung des Menschen gelangen. 미완성(unvollendet)과 짝을 이룬다'),
  ('e6a150c47c21a', 31, '핵심 용어', '일체', '一切', 'das Ganze', '확정', false, '', 'the whole / all ⟨미확인⟩', 'all things', '', '', '진리란 일체가 없어야', 'Truth is the absence of all things', 'In dem einen Film, der „Geist“ heißt, hat der Mensch im Laufe seines Lebens seine Heimat aufgenommen, seine Zeit in der Grundschule, Mittelschule, Oberschule und Universität, seinen Militärdienst, seine Heirat, sein gesamtes gesellschaftliches Leben und sein religiöses Leben – alles, was er erlebt hat, hat er in seinem Geist festgehalten. Und auch künftig wird er alles, was er sieht, hört, sagt, riecht und empfindet, weiter aufnehmen.', '순리 · 가짐', '', '전체와 같은 독일어를 쓴다 — 겹침이 아니라 뜻한 것이다 (저자 확정 2026-09-26). 다만 부정문 부사로는 keinerlei / nichts. 영문본: 진리란 일체가 없어야 → Truth is the absence of all things'),
  ('eed6577c7efdf', 32, '핵심 용어', '자기의 자기', '自己', 'das Selbst des Selbst', '확정', false, '', 'the self of the self ⟨미확인⟩', 'the self of the self ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '자아 발견', ''),
  ('e402574f67d3c', 33, '핵심 용어', '정', '情', 'Verbundenheit / Herzenswärme', '맥락 선택', false, '', 'affection / bond ⟨미확인⟩', '', '', '', '', '', '', '순리', '', '관계적 맥락 → Verbundenheit, 정서적 맥락 → Herzenswärme'),
  ('ee1c7c31a826f', 34, '핵심 용어', '정과 신', '精神', 'Jung und Shin', '확정', false, '', '', '', '', 'Jung and Shin', '', '', '', '하늘사람', '', '음역을 그대로 쓴다. 「정신 차리다 → zu sich kommen」과는 다른 자리'),
  ('e90c3a21f7bfa', 35, '핵심 용어', '정신 차리다', '精神', 'zu sich kommen', '맥락 선택', false, '', '(Jung and Shin – the true Body and Mind)', '', '', '', '', '', '', '순리', '자연의 흐름 속의 삶', '영어의 개념 설명은 생략. 살릴 경우 wahren Körper und Geist wiedererlangen'),
  ('ee519941e85ac', 36, '핵심 용어', '진리', '眞理', 'die Wahrheit', '확정', false, '', 'truth', 'Truth', '', 'Truth', '살아서 참인 진리가 된 자만이 영원히 사는 것은 상식이다.', '', 'Dass nur ewig lebt, wer zu Lebzeiten das Wahre, die Wahrheit, geworden ist, ist gesunder Menschenverstand.', '순리 · 가짐 · 하늘사람', '', '★참(das Wahre)과 가른다 (저자 확정 2026-09-27). 영문본은 언제나 대문자 Truth'),
  ('ec337b1d13331', 37, '핵심 용어', '참', '眞', 'das Wahre / wahr', '확정', false, '', 'truth ⟨미확인⟩', 'true / Truth', '', 'Truth / true', '', '', '', '순리 · 가짐 · 하늘사람', '', '★이름씨는 das Wahre, 그림씨는 wahr (저자 확정 2026-09-27). ★종전 용어집은 「참과 진리를 같은 낱말로 수렴」했으나 이제 가른다: 참 → das Wahre · 진리 → die Wahrheit. 보기: Das Wahre ist diese Welt / Die Wahrheit ist das Wahre'),
  ('e44f3c1bb3797', 38, '핵심 용어', '참 길', '', 'der wahre Weg', '확정', false, '', 'the true path ⟨미확인⟩', 'the true way ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '자아 발견', ''),
  ('e072bb9e68eeb', 39, '핵심 용어', '참 명상법', '', 'die wahre Meditationsmethode / die wahre Art zu meditieren / die wahre Methode der Meditation', '검토 필요', true, '⚠편집 때 고를 것 — 셋 가운데 하나로', '', '', 'the true meditation method', '', '', '', '', '만나는 방법', '', 'die wahre Meditationsmethode 는 영문본과 맞는다. die wahre Art zu meditieren 은 제목(Wie man meditiert)과 메아리친다'),
  ('e0fe389e89501', 40, '핵심 용어', '참 열반 · 진정한', '', 'wahres … / wahrhaft', '확정', false, '', '', '', '', '', '', '', '', '순리', '', '명사 앞에서는 wahres …, 부사로는 wahrhaft'),
  ('e90e191d362e6', 41, '핵심 용어', '참과 허', '眞虛', 'Wahrheit und Illusion', '확정', false, '', 'truth and illusion ⟨미확인⟩', 'truth and falsehood ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '도(道)', ''),
  ('e93d5cf37c1e3', 42, '핵심 용어', '참나', '眞我', 'wahres Selbst', '확정', false, '', 'true self ⟨미확인⟩', 'true self ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '', ''),
  ('eb3ed8b11891e', 43, '핵심 용어', '천지 만상만물', '天地萬象萬物', 'alle Wesen im Himmel und auf Erden', '확정', false, '', 'all beings in heaven and earth ⟨미확인⟩', 'all things in the universe / the whole of creation', '', '', '천지만상이 있음도', 'the existence of all things in the universe', '', '순리 · 가짐', '번뇌', '영문본: 천지만상이 있음도 → the existence of all things in the universe / 천지만상을 낼 때 → when giving birth to the whole of creation'),
  ('e53d34f004e2e', 44, '핵심 용어', '하늘 일', '', 'Werk des Himmels', '확정', false, '', 'the work of heaven ⟨미확인⟩', '', '', '', '', '', '', '순리', '열반송', ''),
  ('e04c8a43663b5', 45, '핵심 용어', '한량없이 큰 나', '限量', 'das unendlich weite Ich', '확정', false, '', 'the boundless self ⟨미확인⟩', 'the infinitely vast self ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '열반송', ''),
  ('e4da963f30957', 46, '핵심 용어', '허', '虛', 'das Falsche / Illusion', '검토 필요', true, '⚠기록 둘이 어긋난다: 「만나는 방법」은 Illusion, 「하늘사람」 대응표는 das Falsche. ★또 「거짓」도 das Falsche 라서 두 한국어가 한 독일어로 겹친다', '', '', 'false', 'false / falseness', '', '', '', '만나는 방법 · 하늘사람', '', '하늘사람 대응표: 허 → das Falsche · 허상 → Illusion 으로 가름. 「만나는 방법」에서는 허 → Illusion 으로 적었다. 본문에는 둘 다 나온다 (was das Wahre und was das Falsche ist / Wer als Illusion stirbt)'),
  ('e3fc55800a09e', 47, '핵심 용어', '허상', '虛想', 'Illusion', '확정', false, '', '', '', '', 'illusion', '', '', '', '하늘사람', '', '허(das Falsche)와 가른다 — 하늘사람 대응표'),
  ('e64a96b5fbee4', 48, '존재 · 우주', '대우주 · 우주심', '大宇宙', 'großes Universum / Geist des Universums', '확정', false, '', '', '', '', 'great Universe, mind of the Universe', '', '', '', '하늘사람', '', '우주의 마음 → der Geist des Universums 와 같은 갈래'),
  ('e5ae3a785609c', 49, '존재 · 우주', '때', '', 'Zeit', '검토 필요', true, '⚠「때 → Zeit」를 확정할지 정해야 함 (삶의 이유에서 그대로 썼음)', '', 'season', '', '', '하늘도 때가 있어', 'Heaven has its season', '', '가짐 · 만나는 방법', '가짐', '하늘도 때가 있어 → Heaven has its season'),
  ('e1d6a88ad6833', 50, '존재 · 우주', '무정', '', 'Animitta', '신규 제안', false, '', '', 'animitta', '', '', '무정 속에 유정', 'nimitta within animitta', '', '가짐', '가짐', '영문본이 산스크리트 유지 → 독어도 Kleshas처럼 유지 제안'),
  ('e9f521ff9da3a', 51, '존재 · 우주', '바른 진리', '', 'die rechte Wahrheit', '신규 제안', false, '', '', 'the real Truth', '', '', '', '', '', '가짐', '가짐', '영문본은 ''바른''을 real로 옮김. 독어 대안 die wirkliche Wahrheit'),
  ('edca01e517afe', 52, '존재 · 우주', '세상의 이치', '', 'die Ordnung der Welt', '확정', false, '', '', '', 'the ways of the world', '', '개체의 정신이 신의 정신으로 거듭나야 참 지혜가 있을 것이다. 신으로 거듭난 자만 세상의 이치를 알고 바름을 아닌 지혜가 있을 것이다.', '', 'Erst wenn das individuelle Bewusstsein zum Bewusstsein Gottes wiedergeboren wird, gibt es wahre Weisheit. Nur wer als Gott wiedergeboren ist, kennt die Prinzipien der Welt und hat die Weisheit, das Rechte zu erkennen.', '만나는 방법', '', '★앞의 die Gesetzmäßigkeiten der Welt 를 고쳤다 — 학술 말투를 피한다 (저자 확정 2026-09-27). 「당연한 이치 → Gesetzmäßigkeit」(논리의 자리)와는 따로 본다'),
  ('e26cc862db51b', 53, '존재 · 우주', '신 · 하나님', '神', 'Gott', '확정', false, '', '', '', '', 'God', '', '', '', '하늘사람', '', '★종교 어휘를 일부러 가져온 낱말 (규칙 27). 신계 → das göttliche Reich 와는 다른 자리'),
  ('effa64d3d5103', 54, '존재 · 우주', '연(緣)', '', 'Verbundenheit', '신규 제안', false, '', '', 'being connected to the world as it is', '', '', '세상의 연 그대로 사는 삶', 'a life in which man lives connected to the world as it is', '', '가짐', '가짐', '세상의 연 그대로 사는 삶 → a life in which man lives connected to the world as it is. 독어판 한자 제거'),
  ('e3efbdd581642', 55, '존재 · 우주', '완전한 대도', '', 'das vollkommene und unendliche Dō', '신규 제안', false, '', '', 'the perfect and infinite dō (Truth)', '', '', '', '', '', '가짐', '가짐', ''),
  ('ef221d8a877bc', 56, '존재 · 우주', '유정', '', 'Nimitta', '신규 제안', false, '', '', 'nimitta', '', '', '', '', '', '가짐', '가짐', '무정 속에 유정 → nimitta within animitta'),
  ('ea33e8f708f12', 57, '존재 · 우주', '이치', '', 'Prinzipien / Gesetzmäßigkeit', '맥락 선택', false, '', '', 'logic', '', 'principles, ways', '개체의 정신이 신의 정신으로 거듭나야 참 지혜가 있을 것이다. 신으로 거듭난 자만 세상의 이치를 알고 바름을 아닌 지혜가 있을 것이다.', '', 'Erst wenn das individuelle Bewusstsein zum Bewusstsein Gottes wiedergeboren wird, gibt es wahre Weisheit. Nur wer als Gott wiedergeboren ist, kennt die Prinzipien der Welt und hat die Weisheit, das Rechte zu erkennen.', '가짐 · 만나는 방법 · 하늘사람', '가짐', '★둘 다 쓰고 번역자가 고른다. 하늘사람 대응표: Prinzipien (원리·길). 「당연한 이치」처럼 논리를 뜻할 때는 Gesetzmäßigkeit. ★「세상의 이치」는 die Ordnung der Welt — 따로 세운 줄을 보라'),
  ('e934dd25ec5f7', 58, '존재 · 우주', '전체', '', 'das Ganze', '확정', false, '', '', 'the Whole', '', '', '우리가 자기의 입장에서 보면 그것은 지혜가 아닌 허일 뿐이고 신이신 우주 전체의 입장에서 보면 그것은 참이 될 것이다. 사람의 정신의 개체의 정신에서 대우주의 정신으로 보면 세상의 이치를 다 알 것이다.', '', 'Vom eigenen Standpunkt aus betrachtet, ist es keine Weisheit, sondern nur Falsches; vom Standpunkt des ganzen Universums, das Gott ist, betrachtet, wird es wahr. Wenn das Bewusstsein des Menschen vom individuellen Bewusstsein zum Bewusstsein des großen Universums wird, wird er alle Prinzipien der Welt kennen.', '가짐', '가짐', '일체와 같은 독일어를 쓴다 — 겹침이 아니라 뜻한 것이다 (저자 확정 2026-09-26). 영문본 대문자 the Whole'),
  ('e1f563c873559', 59, '존재 · 우주', '조화', '', 'Harmonie', '신규 제안', false, '', '', 'harmony', '', '', '', '', '', '가짐', '가짐', ''),
  ('ed36c4dcdb11c', 60, '존재 · 우주', '참마음', '', 'wahrer Geist', '확정', false, '', '', 'the true Mind', '', '', '가짐 없는 마음이 참마음이다', 'A mind absent of wants is the true Mind', '', '가짐', '가짐', 'A mind absent of wants is the true Mind'),
  ('ef84234af1124', 61, '존재 · 우주', '천국', '天國', 'Himmel(reich) / Land der Wahrheit', '확정', false, '', '', '', '', 'heaven, land of Truth', '', '', '', '하늘사람', '', '★종교 어휘를 일부러 가져온 낱말 (규칙 27). 보기: Er wird ewig im Himmelreich leben, im Land der Wahrheit'),
  ('ea93803c5da03', 62, '존재 · 우주', '천리', '天理', 'Gesetz des Himmels', '확정', false, '', '', '', '', '', '', '', '', '순리', '', ''),
  ('e6d6dc9a3419f', 63, '존재 · 우주', '천인지 (하늘 · 땅 · 사람)', '', 'Himmel, Erde und Mensch', '신규 제안', false, '', '', 'Heaven, earth, and man', '', '', '', '', '', '가짐', '가짐', '원문 표기는 ''천인지''. 독어에선 한자 대신 Cheon-in-ji 음역 병기 여부 결정 필요'),
  ('e93ab371bcaa1', 64, '존재 · 우주', '하나의 진리', '', 'die eine Wahrheit', '신규 제안', false, '', '', 'the one Truth', '', '', '', '', '', '가짐', '가짐', ''),
  ('ec3d78839f92b', 65, '존재 · 우주', '하늘', '', 'Himmel', '신규 제안', true, '⚠상태 상이: 순리 「확정」 / 철학용어집 「신규 제안」', 'Universe', 'Heaven', '', '', '참이란 영원히 살아 있는 진리의 존재다. 이 존재가 창조주의 존재다. 우주를 다 없애어도 하늘에 하늘은 있지 않은가. 일체가 빈 하늘이지만 이 속에 일신이 존재한다. 빈 존재가 천지만상을 낸 우주의 몸이고, 신은 천지 만물만상의 마음이다. 이 몸마음이 진리이시고, 참이신 이 존재와 하나가 되지 않고는 사는 방법이 없다.', '', 'Das Wahre ist das ewig lebendige Dasein der Wahrheit. Dieses Dasein ist das Dasein des Schöpfers. Selbst wenn man das ganze Universum loslässt – bliebe dann nicht der Himmel jenseits des Himmels? Alles ist leerer Himmel, und doch existiert in ihm der eine Gott. Dieses leere Dasein ist der Körper des Universums, der Himmel und Erde und alle Erscheinungen hervorgebracht hat, und Gott ist der Geist von Himmel und Erde und allen Dingen und Erscheinungen. Dieser Körper und Geist ist die Wahrheit, und es gibt keinen Weg zu leben, ohne mit diesem Dasein, das das Wahre ist, eins zu werden.', '순리 · 가짐', '자연의 흐름 속의 삶, 가짐', 'Universum은 과학적 어감이라 불채택'),
  ('ea3955bff910f', 66, '존재 · 우주', '하늘의 뜻', '', 'der Wille des Himmels', '신규 제안', false, '', '', 'Heaven''s will', '', '', '', '', '', '가짐', '가짐', ''),
  ('e5a4348e7468d', 67, '존재 · 우주', '한마음', '', 'ein Herz und ein Geist / der eine Geist', '맥락 선택', false, '', '', 'the one Mind', '', '', '가짐이 없으면 한마음이 되고', 'he would be of the one Mind', '', '가짐', '가짐', '★둘 다 남겨 둔다 — 옮기면서 의논해 정한다 (저자 확정 2026-09-26). 순리(시): ein Herz und ein Geist (ein Herz만으로는 부족) · 가짐 영문본: the one Mind → der eine Geist'),
  ('e1a7ace0b40d4', 68, '마음 구조', '가지려는 마음', '', 'das Haben-Wollen', '신규 제안', false, '', '', 'wants (man''s wants)', '', '', '사람의 가지려는 마음이', 'Man''s wants', '', '가짐', '가짐', '사람의 가지려는 마음이 → Man''s wants'),
  ('e567527bb1a18', 69, '마음 구조', '개체', '', 'das individuelle Selbst', '신규 제안', false, '', '', 'individual self', '', '', '자기의 개체가 있어 서로가 있으니', 'Because one''s individual self exists, others exist', 'Erst wenn das individuelle Bewusstsein zum Bewusstsein Gottes wiedergeboren wird, gibt es wahre Weisheit. Nur wer als Gott wiedergeboren ist, kennt die Prinzipien der Welt und hat die Weisheit, das Rechte zu erkennen.', '가짐', '가짐', '자기의 개체가 있어 서로가 있으니 → Because one''s individual self exists, others exist'),
  ('e1642542019a3', 70, '마음 구조', '거짓의 마음', '', 'der falsche Geist', '신규 제안', false, '', '', '', 'the false mind', '', '', '', '', '만나는 방법', '', '거짓 나 → falsches Selbst 와 짝'),
  ('e54f02a425042', 71, '마음 구조', '고집', '', 'Eigensinn / eigensinnig', '신규 제안', false, '', '', 'stubborn', '', '', '', '', '', '가짐', '가짐', ''),
  ('ed6dcbbfa11d1', 72, '마음 구조', '관념 관습', '觀念慣習', 'Vorstellungen und Bräuche', '검토 필요', true, '⚠대응표에 `Bräuchen`(여격)으로 적혀 있어 `Bräuche`로 바로잡았다. ★다만 본문은 `Vorstellungen und Gewohnheiten`을 썼고, 「습 → Gewohnheit」와도 맞으므로 Gewohnheiten 이 나을 수 있다 — 정해야 함', '', '', '', 'conceptions and habits', '', '', '', '하늘사람', '', '본문(50. 참지혜란): in der falschen Geisteswelt seiner Vorstellungen und Gewohnheiten'),
  ('eea509247ac7a', 73, '마음 구조', '괴로움', '', 'Leid', '신규 제안', false, '', '', 'pain', '', '', '', '', '', '가짐', '가짐', ''),
  ('ed936378a5049', 74, '마음 구조', '나 없이 / 나가 없는 우리', '', 'ohne Ich / kein „Ich“, nur „Wir“', '신규 제안', false, '', '', 'absent of self / no ''me'', only ''us''', '', '', '', '', '', '가짐', '가짐', '★따옴표는 독일식 „…“ 를 쓴다 (번역규칙 15번). 앞은 닫는 쪽이 영문 직선따옴표였다'),
  ('eb153ca72572b', 75, '마음 구조', '나쁜 마음', '', 'ein böswilliger Geist', '신규 제안', false, '', '', 'a malevolent mind', '', '', '', '', '', '가짐', '가짐', ''),
  ('ea658847c065e', 76, '마음 구조', '둘 (둘이 아닌 삶)', '', 'ein zweigeteiltes Leben', '신규 제안', false, '', '', 'dual life', '', '', '참의 삶이란 둘이 아니고', 'there is no "dual life"', '', '가짐', '가짐', '참의 삶이란 둘이 아니고 → there is no "dual life"'),
  ('e2c43a47604d7', 77, '마음 구조', '마음 없이', '', 'ohne Geist', '신규 제안', false, '', '', 'absent of his mind / absent of the thoughts', '', '', '마음 없이 살아가고', 'live absent of his mind', '', '가짐', '가짐', '마음 없이 살아가고 → live absent of his mind / 마음 없이 행함 → do deeds absent of the thoughts that they have done them'),
  ('e0ec44fc67318', 78, '마음 구조', '마음가짐 · 마음 가짐', '', 'eigene Haltung', '확정', false, '', '', '', '', '', '', '', '', '순리', '', '★가짐(Besitz)과 다르다 — 태도를 뜻한다. 반드시 구분한다'),
  ('e2744f5df977f', 79, '마음 구조', '마음세계', '', 'Geisteswelt', '확정', false, '', '', '', '', 'mind world', '', '', '', '하늘사람', '', '인간마음 세상 → die menschliche Geisteswelt 와 같은 갈래. 사진세계 → Bilderwelt 와 같은 꼴'),
  ('e9b15c47e82e7', 80, '마음 구조', '몸 마음', '', 'Körper und Geist', '신규 제안', false, '', '', '', 'body and mind', '', '', '', '', '만나는 방법', '', ''),
  ('e0614e6b00ec5', 81, '마음 구조', '번뇌망상', '', 'Wahnvorstellungen', '신규 제안', false, '', '', 'delusions', '', '', '', '', '', '가짐', '가짐', '영문본은 번뇌(kleshas)와 분리. 독어 대안 Verblendung'),
  ('ecaeb0753687a', 82, '마음 구조', '사진세계', '寫眞世界', 'Bilderwelt / Aufnahmewelt', '맥락 선택', false, '', '', '', '', 'picture world', '우리는 이 사진세계를 다 부수고 나와야 완성된 세상과 하나가 되어 살 수가 있는 것이라.', 'We can live as one with the complete world when we destroy this picture world and come out from within it.', 'Erst wenn wir diese Bilderwelt ganz loslassen und aus ihr heraustreten, können wir eins mit der vollendeten Welt leben.', '하늘사람', '사람의 마음', '★둘 다 쓴다 — ★영문본이 그 자리에서 무엇을 썼는지에 따라 고른다 (저자 확정 2026-09-27). picture world → Bilderwelt. 사진 낱개는 Aufnahme / Bild. 마음세계 → Geisteswelt 와 같은 꼴'),
  ('effd041247330', 83, '마음 구조', '생각', '', 'Gedanken', '신규 제안', false, '', '', 'thoughts', '', '', '생각 속에 살지 않고', 'would not live in his thoughts', '', '가짐', '가짐', '생각 속에 살지 않고 → would not live in his thoughts. 규칙: 마음 ≠ 생각'),
  ('eaefb7150a6eb', 84, '마음 구조', '아만 · 아상', '', 'Hochmut und Ich-Vorstellung', '신규 제안', false, '', '', 'pride or sense of self', '', '', '', '', '', '가짐', '가짐', '영문본은 자존심과 아만 둘 다 pride 사용 — 독어는 Stolz / Hochmut로 구분 제안'),
  ('e2018a4d80a7e', 85, '마음 구조', '욕심', '', 'Gier', '신규 제안', false, '', '', 'greed', '', '', '', '', '', '가짐', '가짐', ''),
  ('e1c82ad6c86c9', 86, '마음 구조', '이기적', '', 'egoistisch', '신규 제안', false, '', '', 'selfish', '', '', '', '', '', '가짐', '가짐', ''),
  ('e62ff2ed617c7', 87, '마음 구조', '인간마음 · 인간의 마음', '', 'der menschliche Geist', '신규 제안', false, '', '', '', 'the human mind', '', '인간마음은 부모에게 물려받은 습에 자기의 산 삶이 더해진 것이다.', 'The human mind is the accumulation of one''s life lived based on the habits.', 'Der Geist des Menschen ist die Art, wie man gegenwärtig lebt.', '만나는 방법', '', ''),
  ('e2874ce3a605c', 88, '마음 구조', '인간마음 세상', '', 'die menschliche Geisteswelt', '확정', false, '', '', '', 'the human mind world', '', '', '', 'in einem solchen Geist (뒤에서 받을 때)', '만나는 방법', '', '★앞의 die Welt des menschlichen Geistes 를 고쳤다 (저자 확정 2026-09-27). 뒤에서 받을 때는 in einem solchen Geist'),
  ('ee60a6212ac09', 89, '마음 구조', '자기 잘났다', '', 'eingebildet', '신규 제안', false, '', '', 'conceited', '', '', '', '', '', '가짐', '가짐', ''),
  ('efc20115b4278', 90, '마음 구조', '자존심', '', 'Stolz', '신규 제안', false, '', '', 'pride', '', '', '', '', '', '가짐', '가짐', ''),
  ('ed17c95e195ea', 91, '마음 구조', '정신 · 의식', '精神', 'Bewusstsein', '확정', false, '', '', '', '', 'consciousness', '', '', '', '하늘사람', '', '★마음(Geist)과 가른다. 보기: 개체의 정신 → das individuelle Bewusstsein'),
  ('e8c8458c6a6df', 92, '마음 구조', '주체', '', 'Kern', '신규 제안', false, '', '', 'core', '', '', '주체가 나가 아니고', 'his core would not be his self', '', '가짐', '가짐', '주체가 나가 아니고 → his core would not be his self'),
  ('e059bc977bd3e', 93, '마음 구조', '편중 없음', '', 'unvoreingenommen', '신규 제안', false, '', '', 'unbiased', '', '', '마음 씀에 편중이 없고', 'his mind would be unbiased', '', '가짐', '가짐', '마음 씀에 편중이 없고 → his mind would be unbiased'),
  ('ee85afbae7497', 94, '삶 · 세상', '가정 · 사회 · 나라', '', 'Familien, Gesellschaften und Staaten', '신규 제안', true, '⚠메모에 결정 필요 사항', '', 'homes, societies, and nations', '', '', '', '', '', '가짐', '가짐', '⚠ Nation은 독어에서 민족주의 울림 가능 → Staaten 제안'),
  ('e176124afd6d5', 95, '삶 · 세상', '공존', '', 'Koexistenz / koexistieren', '신규 제안', false, '', '', 'coexist', '', '', '', '', '', '가짐', '가짐', ''),
  ('e23108f40e57c', 96, '삶 · 세상', '귀하고 천함', '', 'vornehm oder gering', '신규 제안', false, '', '', 'high class or low class', '', '', '', '', '', '가짐', '가짐', ''),
  ('ebe1afd962eae', 97, '삶 · 세상', '그냥 살아가다', '', 'einfach so leben, wie es ist', '신규 제안', false, '', '', 'simply live as it is', '', '', '', '', '', '가짐', '가짐', ''),
  ('e0b853ed50154', 98, '삶 · 세상', '바른 삶 / 바름', '', 'rechtschaffenes Leben / Rechtschaffenheit', '확정', false, '', '', 'a righteous life / righteousness', '', '', '개체의 정신이 신의 정신으로 거듭나야 참 지혜가 있을 것이다. 신으로 거듭난 자만 세상의 이치를 알고 바름을 아닌 지혜가 있을 것이다.', '', 'Erst wenn das individuelle Bewusstsein zum Bewusstsein Gottes wiedergeboren wird, gibt es wahre Weisheit. Nur wer als Gott wiedergeboren ist, kennt die Prinzipien der Welt und hat die Weisheit, das Rechte zu erkennen.', '가짐', '가짐', ''),
  ('e0cf2492c438f', 99, '삶 · 세상', '바른 세상', '', 'eine rechte Welt', '신규 제안', true, '⚠메모에 결정 필요 사항', '', 'for the world to be right', '', '', '사람은 자기의 관념 관습의 자기가 만든 허의 마음세계 속에 살고 있기에 사람은 참 지혜라는 것이 아예 없는 것이다. 참지혜란 바른 세상의 이치를 아는 것이 지혜다.', '', 'Weil der Mensch in der falschen Geisteswelt seiner Vorstellungen und Gewohnheiten lebt, die er selbst geschaffen hat, besitzt er überhaupt keine wahre Weisheit. Wahre Weisheit bedeutet, die Prinzipien der rechten Welt zu kennen.', '가짐', '가짐', '⚠ 바름 = rechtschaffen 규칙과 맞출지 확인 (rechtschaffene Welt는 어색)'),
  ('ed0834e9983c8', 100, '삶 · 세상', '봉사', '', 'anderen dienen', '신규 제안', false, '', '', 'serving others', '', '', '', '', '', '가짐', '가짐', ''),
  ('e3a41342cb6d4', 101, '삶 · 세상', '불행과 암흑', '', 'Unglück und Dunkelheit', '신규 제안', false, '', '', 'unhappiness and darkness', '', '', '', '', '', '가짐', '가짐', ''),
  ('e284e0f11088d', 102, '삶 · 세상', '사람의 값어치', '', 'der Wert des Menschen', '신규 제안', false, '', '', 'the value of man', '', '', '', '', '', '가짐', '가짐', ''),
  ('e874d8f5616f1', 103, '삶 · 세상', '삶의 의욕', '', 'Lebenswille', '신규 제안', false, '', '', 'the will to live', '', '', '', '', '', '가짐', '가짐', ''),
  ('e5a6e13bb4379', 104, '삶 · 세상', '성인', '聖人', 'Heiliger / die Heiligen', '맥락 선택', false, '', 'saint / sage ⟨미확인⟩', 'the saints', '', '', '', '', '', '순리 · 가짐', '가짐', '종교 어휘를 일부러 가져온 낱말이다 — die Weisen으로 피하지 않는다 (저자 확정 2026-09-26). 수는 맥락에 따른다: 순리는 낱개(Heiliger), 가짐은 여럿(die Heiligen)'),
  ('e9261bf9840fc', 105, '삶 · 세상', '스스로', '', 'aus eigenem Antrieb', '신규 제안', false, '', '', 'of his own accord', '', '', '', '', '', '가짐', '가짐', ''),
  ('e3235b07cbda8', 106, '삶 · 세상', '싸움', '', 'Streit / Konflikte', '신규 제안', false, '', '', 'conflicts', '', '', '', '', '', '가짐', '가짐', ''),
  ('ebd0b9f725e4b', 107, '삶 · 세상', '안심 · 편안', '', 'unbeschwert / in Ruhe', '신규 제안', false, '', '', 'at ease / in comfort', '', '', '', '', '', '가짐', '가짐', ''),
  ('e47def5b15528', 108, '삶 · 세상', '없는 가운데 사는 삶', '', 'ein Leben im Nicht-Sein', '신규 제안', false, '', '', 'life in non-existence', '', '', '', '', '', '가짐', '가짐', ''),
  ('eed7034dc8f47', 109, '삶 · 세상', '영생 / 영생의 길', '', 'ewiges Leben', '확정', false, '', '', 'eternal life / the only road to his eternal life', '', '', '', '', '', '가짐', '가짐', '종교 어휘를 일부러 가져온 낱말이다 — 독일어의 종교적 울림은 뜻한 것이므로 피하지 않는다 (저자 확정 2026-09-26)'),
  ('eb067fe9b0dab', 110, '삶 · 세상', '영생복락', '', 'ewiges Leben, Segen und Glück', '확정', false, '', '', 'eternal life, blessings, and happiness', '', '', '', '', '', '가짐', '가짐', '종교 어휘를 일부러 가져온 낱말이다 (저자 확정 2026-09-26)'),
  ('e61e2ce95fede', 111, '삶 · 세상', '완전한 삶', '', 'ein vollkommenes Leben', '신규 제안', false, '', '', 'a complete life', '', '', '', '', '', '가짐', '가짐', ''),
  ('ecedffbae3cda', 112, '삶 · 세상', '잘나고 못난 이', '', 'Höhergestellte und Niedrigere', '신규 제안', false, '', '', 'superior persons or inferior persons', '', '', '', '', '', '가짐', '가짐', ''),
  ('e0643ebed7b48', 113, '삶 · 세상', '존재함의 고귀함', '', 'die Kostbarkeit des eigenen Daseins', '신규 제안', false, '', '', 'the preciousness of self-existence', '', '', '', '', '', '가짐', '가짐', ''),
  ('e025c7787cd5f', 114, '삶 · 세상', '종교 · 사상 · 철학', '', 'Religionen, Ideologien und Philosophien', '신규 제안', false, '', '', 'religions, ideologies, and philosophies', '', '', '', '', '', '가짐', '가짐', ''),
  ('eace675521201', 115, '삶 · 세상', '지위 고하', '', 'Rang', '신규 제안', false, '', '', 'rank(s)', '', '', '', '', '', '가짐', '가짐', ''),
  ('ea00589d89872', 116, '삶 · 세상', '진짜 사람', '', 'ein echter Mensch', '신규 제안', false, '', '', '', 'a true person', '', '', '', '', '만나는 방법', '', '「진짜/가짜 = echt/unecht」 규칙을 보라'),
  ('e152ba2af06d7', 117, '삶 · 세상', '참삶', '', 'ein wahres Leben (führen)', '신규 제안', false, '', '', '', 'a true life', '', '', '', '', '만나는 방법', '', '「참의 삶」과 같다. Leben führen 과 쓸 때는 부정관사'),
  ('eeb02571524b8', 118, '삶 · 세상', '참세상', '', 'die wahre Welt', '신규 제안', false, '', '', '', 'the Land of Truth', '', '인간의 마음을 신인 대 우주과 하나가 되게 하며 참세상에 거듭나게 되니 이것이 완전한 세상이다.', '', 'Wenn der Geist des Menschen mit dem großen Universum, das Gott ist, eins wird und der Mensch in der wahren Welt wiedergeboren wird, dann ist das die vollkommene Welt.', '만나는 방법', '', '「참의 세상」과 같다. 영문본은 Land 로 옮김'),
  ('e0232d64427d6', 119, '삶 · 세상', '참의 삶', '', 'das wahre Leben / ein wahres Leben (führen)', '맥락 선택', false, '', '', 'a true life / a life of Truth', 'a true life', '', '', '', '', '가짐 · 만나는 방법', '가짐', '★Leben führen 과 함께 쓸 때는 부정관사: ein wahres Leben führen (저자 확정 2026-09-27). 그 밖에는 das wahre Leben'),
  ('e678ae6c0a39d', 120, '삶 · 세상', '참의 세상', '', 'die wahre Welt', '신규 제안', false, '', '', 'the true world', 'the Land of Truth', '', '', '', '', '가짐 · 만나는 방법', '가짐', '「참세상」도 같다. 이 책 영문본은 Land of Truth 로 옮겼으나 독일어는 die wahre Welt 로 둔다'),
  ('e9b21b7e7d341', 121, '삶 · 세상', '청춘 · 젊음 · 늙음', '靑春', 'Jugend / Jungsein / Altsein', '확정', false, '', '', '', '', '', '', '', '', '순리', '청춘', ''),
  ('ee1cdc753c3a7', 122, '삶 · 세상', '하나 / 하나가 되는 삶', '', 'eins / ein Leben im Einssein', '신규 제안', false, '', '', 'one / a life of oneness', '', '', '모두가 하나임을 알고', 'understand that they are all one', 'Wenn der Geist des Menschen mit dem großen Universum, das Gott ist, eins wird und der Mensch in der wahren Welt wiedergeboren wird, dann ist das die vollkommene Welt.', '가짐', '가짐', '모두가 하나임을 알고 → understand that they are all one'),
  ('ebed275fcedd4', 123, '삶 · 세상', '하늘나라 영생', '', 'nach dem Tod ewig im Himmel leben', '확정', false, '', '', 'live forever in Heaven after death', '', '', '', '', '', '가짐', '가짐', '종교 어휘를 일부러 가져온 낱말이다 (저자 확정 2026-09-26)'),
  ('e28891b8843bb', 124, '삶 · 세상', '화기애애', '', 'glücklich und friedlich', '신규 제안', false, '', '', 'happy and peaceful', '', '', '', '', '', '가짐', '가짐', ''),
  ('e86e748a92e1a', 125, '삶 · 세상', '희생', '', 'Opfer bringen', '신규 제안', false, '', '', 'make sacrifices', '', '', '', '', '', '가짐', '가짐', ''),
  ('edd318b88161e', 126, '방법 · 동사', '권능자', '', 'das allmächtige Wesen', '확정', false, '', '', 'the almighty ⟨미확인⟩', '', '', '', '', '', '가짐', '', ''),
  ('eb6e33644ea79', 127, '방법 · 동사', '깨닫다', '', 'erkennen', '신규 제안', false, '', '', 'realize', '', '', '당연한 이치를 깨달아야', 'must realize the obvious logic', '', '가짐', '가짐', '당연한 이치를 깨달아야 → must realize the obvious logic'),
  ('e5fa8022353eb', 128, '방법 · 동사', '깨치지를 못하다', '', 'kann nicht erleuchtet werden', '신규 제안', false, '', '', '', '', '', '', '', '', '만나는 방법', '명상하는 방법', '「못하다」(할 수 없음)를 살린다 — kann … nicht'),
  ('e97d5254eaad3', 129, '방법 · 동사', '다시 나다', '', 'neu geboren werden / wiedergeboren werden', '맥락 선택', false, '', '', '', 'born again / reborn', 'be resurrected / reborn', '', '', '', '만나는 방법 · 하늘사람', '', '★둘 다 쓰고 번역자가 고른다 (하늘사람 대응표 2026-09-27). 종전에 「wiedergeboren 쓰지 않음」이라 적었으나 풀린다 — 다만 윤회로 읽힐 자리에서는 neu geboren 을 고른다 (규칙 2)'),
  ('e0f13689cc62a', 130, '방법 · 동사', '떠나다 (모든 것을)', '', 'verlassen', '확정', false, '', '', '', '', '', '', '', '', '순리', '', '「버리다」의 여러 동사 가운데 이 자리에 어울리는 것. 번역자가 고른다'),
  ('ec54adfe0a8c8', 131, '방법 · 동사', '버리다', '', 'loslassen / freilegen / auflösen / wegwerfen', '맥락 선택', false, '', '', 'discard', 'discard / eliminate / throw away', '', '이것을 버리고 / 몸 마음을 없애어 / 자기 없애는', '', 'wegwerfen / auflösen / sein Selbst wegwerfen', '가짐 · 만나는 방법', '가짐', '★넷 다 쓴다 — 무조건 통일하지 않고 내용에 따라 번역자가 자리마다 고른다 (저자 확정 2026-09-27. 종전의 「혼용 금지」는 풀림). 보기: 마음이란 「이것을 버리고」 → wegwerfen · 삶의 이유 「몸 마음을 없애어」 → auflösen · 명상하는 방법 「자기 없애는」 → sein Selbst wegwerfen · 상념체를 벗어던지다 → abwerfen · 모든 것을 떠나다 → verlassen'),
  ('e6dd14e773fa1', 132, '방법 · 동사', '산 자', '', 'wer lebt', '확정', false, '', '', 'one who lives ⟨미확인⟩', '', '', '', '', '', '가짐', '', ''),
  ('e2fb0f3ef8466', 133, '방법 · 동사', '수용', '', 'die Akzeptanz / annehmen', '확정', false, '', '', 'acceptance / accept ⟨미확인⟩', '', '', '', '', '', '가짐', '', 'die Akzeptanz 는 개념(이름씨), annehmen 은 행위(움직씨)'),
  ('ee70cb18dbe4c', 134, '방법 · 동사', '신계', '', 'das göttliche Reich', '확정', false, '', '', 'the divine realm ⟨미확인⟩', '', '', '', '', '', '가짐', '', 'das Reich Gottes 아님 — 기독교 함의가 너무 좁다. das göttliche Reich로 그대로 둔다 (저자 확정 2026-09-26)'),
  ('e4b6826f4f6a2', 135, '방법 · 동사', '없어지다', '', 'verschwinden', '확정', false, '', '', 'disappear', 'has been eliminated', '', '싸움이 자연히 없어지고', 'all conflicts would disappear', 'wenn der falsche Geist verschwunden ist', '가짐 · 만나는 방법', '가짐', '★완료로 받을 때는 verschwunden sein (보기: 거짓의 마음이 없어지면 → wenn der falsche Geist verschwunden ist). 영문본은 eliminated(능동)로 옮겼으나 독일어는 저절로 사라지는 꼴을 따른다'),
  ('e615405046e5c', 136, '방법 · 동사', '영원히 살다', '', 'ewig leben', '신규 제안', false, '', '', '', 'live eternally', '', '', '', '', '만나는 방법', '', '영생 → ewiges Leben(확정)의 움직씨 꼴'),
  ('e1cf7d6e64452', 137, '방법 · 동사', '자기를 없애다', '', 'sein Selbst wegwerfen', '확정', false, '', '', '', 'eliminating the self', '', '', '', '', '순리 · 만나는 방법', '', '2026-09-27 재확인. 「버리다」의 여러 움직씨 가운데 이 자리의 것'),
  ('e00355ed7bf29', 138, '방법 · 동사', '잘못했습니다', '', '„Ich bitte um Verzeihung“', '확정', false, '', '', 'I beg your forgiveness ⟨미확인⟩', '', '', '', '', '', '가짐', '', '★닫는 따옴표를 독일식 “ 로 고쳤다 (앞은 영문 직선따옴표)'),
  ('e0100cbe07829', 139, '방법 · 동사', '참마음이 되다', '', 'zum wahren Geist werden', '신규 제안', false, '', '', '', 'the true mind is revealed', '', '', '', '', '만나는 방법', '명상하는 방법', '★「되다」를 따른다. 영문본은 revealed(드러나다)로 옮겼으나 원문은 「되다」이다'),
  ('eb037fcbe1ac2', 140, '방법 · 동사', '할 수 있다 (역량)', '', 'vermögen / vermag', '확정', false, '', '', 'be able to ⟨미확인⟩', '', '', '', '', '', '가짐', '', ''),
  ('e37167893ca01', 141, '방법 · 동사', '회개', '悔改', 'Buße', '확정', false, '', '', '', '', 'repentance', '', '', '', '하늘사람', '', '★루터 성경의 말 (규칙 29). 종교 어휘를 피하지 않는다'),
  ('ebfef880fc0c6', 142, '시어·표현', '가장 어리석은', '', 'das Törichtste', '확정', false, '', 'the most foolish ⟨미확인⟩', '', '', '', '', '', '', '순리', '자연의 흐름 속의 삶', ''),
  ('e9efb3f80641f', 143, '시어·표현', '고민 중의 고민', '', 'die Sorge unter all meinen Sorgen', '확정', false, '', 'my worry of all worries ⟨미확인⟩', '', '', '', '', '', '', '순리', '자아 발견', ''),
  ('e94f85a8066d2', 144, '시어·표현', '고행', '苦行', 'Askese (üben)', '신규 제안', false, '', '', '', 'put the body through discomfort', '', '', '', '', '만나는 방법', '', ''),
  ('e1eeea7e800b0', 145, '시어·표현', '곤경에 빠지다', '', 'in Bedrängnis geraten', '확정', false, '', 'fall into utter distress', '', '', '', '', '', '', '순리', '자연의 흐름 속의 삶', ''),
  ('e9cb03bcc1d1e', 146, '시어·표현', '괜히', '', 'grundlos', '확정', false, '', 'for no reason ⟨미확인⟩', '', '', '', '', '', '', '순리', '번뇌', ''),
  ('e13333674019e', 147, '시어·표현', '그 속에 들어 있지 않다', '', 'hält sich nicht darin auf', '확정', false, '', 'does not dwell in (life)', '', '', '', '', '', '', '순리', '깨달음', 'gefangen은 뉘앙스 다름'),
  ('e37d7ccdcaad0', 148, '시어·표현', '그리움', '', 'Sehnsucht', '확정', false, '', 'longing ⟨미확인⟩', '', '', '', '', '', '', '순리', '번뇌, 서시', ''),
  ('e89e314d1a432', 149, '시어·표현', '그지없이 아름다운', '', 'unermessliche Schönheit', '확정', false, '', '', '', '', '', '', '', '', '순리', '', ''),
  ('eb6ba6cbc4163', 150, '시어·표현', '기억된 것', '', 'das Erinnerte', '확정', false, '', 'what he has come to store within', '', '', '', '', '', '', '순리', '깨달음', ''),
  ('e59ec38ef7c7c', 151, '시어·표현', '깨침이란 … 깨쳐지는 것이다', '', 'Erleuchtung – erleuchtet wird der Mensch, … / Erleuchtet wird er, …, und zwar in dem Maß, …', '검토 필요', true, '⚠편집 때 고를 것 — 반복·정의 꼴을 살릴지, 독일어 호흡을 따를지', '', '', '', '', '', '', '', '만나는 방법', '명상하는 방법', '앞: 반복과 정의 꼴을 살린다. 뒤: 호흡을 따른다. ★정의할 때 추상명사에는 관사를 쓰지 않는다 (die Erleuchtung 은 붓다의 깨달음으로 읽힌다)'),
  ('e9bd9a7e39d44', 152, '시어·표현', '나그네', '', 'Wanderer', '확정', false, '', 'wanderer ⟨미확인⟩', '', '', '', '', '', '', '순리', '', ''),
  ('eac15072cbbe5', 153, '시어·표현', '내재된', '內在', 'im Inneren gespeichert', '확정', false, '', 'immanent', '', '', '', '', '', '', '순리', '깨달음', ''),
  ('e7f9c800c6d24', 154, '시어·표현', '눈앞이 캄캄하다', '', 'mir wird schwarz vor Augen', '확정', false, '', 'everything goes dark ⟨미확인⟩', '', '', '', '', '', '', '순리', '서시', ''),
  ('eba2d457be850', 155, '시어·표현', '되는 명상', '', 'Ist eine Meditation eine, die wirkt / Wirkt eine Meditation wirklich', '검토 필요', true, '⚠편집 때 고를 것 — 원문 반복을 살릴지, 독일어 호흡을 따를지', '', '', 'a meditation method (that) truly works', '', '', '', '', '만나는 방법', '', '앞: 원문의 반복을 살린다. 뒤: 호흡을 따른다 (다만 wirklich 는 원문에 없다)'),
  ('e15e028e83f13', 156, '시어·표현', '둘도 없는', '', 'ohnegleichen', '확정', false, '', 'unparalleled ⟨미확인⟩', '', '', '', '', '', '', '순리', '열반송', ''),
  ('e3b040eab1375', 157, '시어·표현', '떠도는 나그네', '', 'ein umhertreibender Wanderer', '확정', false, '', 'a drifting wanderer', '', '', '', '', '', '', '순리', '', ''),
  ('e11e1eb287fa2', 158, '시어·표현', '마음이 믿어 입으로 시인한다 (성경)', '', 'Wer mit dem Herzen glaubt, bekennt mit dem Munde.', '확정', false, '', '', '', 'believe in one''s heart and confess with one''s mouth', '', '마음이 믿어 입으로 시인한다', 'believe in one''s heart and confess with one''s mouth', 'Wer mit dem Herzen glaubt, bekennt mit dem Munde.', '만나는 방법', '', '루터 성경 2017, 로마서 10,10. ★이 자리의 「마음」은 Herz (성경 글귀를 따른다). ★저자가 가져온 부분만 옮기고 「의에 이르고 / 구원에 이르느니라」(gerecht / selig)는 넣지 않는다. ⚠Munde / Mund 는 편집 때 정한다 — 「입으로」 줄을 보라'),
  ('e7bd251cdf76f', 159, '시어·표현', '말없이 한가하고', '', 'wortlos, ohne Sorge', '확정', false, '', 'quiet and at ease ⟨미확인⟩', '', '', '', '', '', '', '순리', '자아 발견', ''),
  ('e6d48127f5c4f', 160, '시어·표현', '먹고사는 것의 방편', '', 'ein Mittel zum Broterwerb', '신규 제안', false, '', '', '', 'a means to make a living', '', '', '', '', '만나는 방법', '', ''),
  ('e16d9e24dcb5f', 161, '시어·표현', '물거품 (한낱의)', '', 'der vergängliche Schaum eines einzigen Tages', '확정', false, '', '', '', '', '', '', '', '', '순리', '', ''),
  ('ea6fb74a85131', 162, '시어·표현', '민들레', '', 'Löwenzahn', '확정', false, '', 'dandelion ⟨미확인⟩', '', '', '', '', '', '', '순리', '열반송', ''),
  ('ed4937c619d1c', 163, '시어·표현', '벗어던지다', '', 'abwerfen', '확정', false, '', 'abandon / discard', '', '', '', '이것을 벗어던지고 우주의 마음이 되면 그것이 참마음이다.', 'When you throw this away and become the universe mind, this is the true mind.', '', '순리', '깨달음', ''),
  ('ecbed5d5ee0d1', 164, '시어·표현', '부질없는', '', 'sinnlos', '확정', false, '', 'futile ⟨미확인⟩', '', '', '', '', '', '', '순리', '', ''),
  ('e561f3802ca68', 165, '시어·표현', '사람은 원래 사람이어야 사람이지만', '', 'Der Mensch ist eigentlich nur Mensch, wenn er Mensch ist', '맥락 선택', false, '', '', '', '', '', '사람은 원래 사람이어야 사람이지만', '', 'Der Mensch ist eigentlich nur Mensch, wenn er Mensch ist', '순리', '자연의 흐름 속의 삶', '3중 반복 의도적 유지. 대안: Der Mensch muss menschlich leben, um Mensch zu sein'),
  ('eeae53a867b5a', 166, '시어·표현', '사회적 지위', '', 'gesellschaftliche Stellung', '신규 제안', false, '', '', '', 'fame', '', '', '', '', '만나는 방법', '', '지위 고하 → Rang 과 다르다. 영문본은 fame 으로 옮김'),
  ('e1a1cf034e6eb', 167, '시어·표현', '상처를 어루만지다', '', 'die Wunden streicheln', '확정', false, '', '', '', '', '', '', '', '', '순리', '', 'berühren 보다 따뜻하다'),
  ('eda0c0d71df42', 168, '시어·표현', '슬픈 사연', '', 'traurige Geschichte', '확정', false, '', 'a sad story ⟨미확인⟩', '', '', '', '', '', '', '순리', '번뇌', ''),
  ('e8f58b1f536db', 169, '시어·표현', '시인하다', '', 'bekennen', '신규 제안', false, '', '', '', 'confess', '', '', '', '', '만나는 방법', '', '루터 성경의 말'),
  ('e695ab5295c7d', 170, '시어·표현', '쓸데없이', '', 'unnötig', '확정', false, '', 'needlessly ⟨미확인⟩', '', '', '', '', '', '', '순리', '번뇌', ''),
  ('ebed5731de6ba', 171, '시어·표현', '아련히', '', 'vage', '맥락 선택', false, '', 'faintly ⟨미확인⟩', '', '', '', '', '', '', '순리', '', '기본은 vage. 「아련한 경지」처럼 넓은 자리에서는 sanft und fern (jene sanfte ferne Ebene) — 순리 번역규칙'),
  ('e1a243fada55e', 172, '시어·표현', '온 곳도 갈 곳도 없는', '', 'weder kommt noch geht', '확정', false, '', '', '', '', '', '', '', '', '순리', '', '장소가 아니라 동사로 옮긴다'),
  ('efcc3df570adf', 173, '시어·표현', '웃음 (역설 구문의)', '', 'Gelächter', '확정', false, '', '', '', '', '', '', '', '', '순리', '', '역설 구문에서 명사로 쓸 때'),
  ('e1a76d9d75410', 174, '시어·표현', '이것이구나', '', '„Das ist es also!“', '신규 제안', false, '', '', '', 'Ah, this is it!', '', '', '', '', '만나는 방법', '', '「-구나」의 깨닫는 느낌 → also'),
  ('e1c377a905dbc', 175, '시어·표현', '인생은 꿈을 꾸게 되어 있지', '', 'und so ist das Leben zum Träumen da', '확정', false, '', 'life is meant to dream ⟨미확인⟩', '', '', '', '인생은 꿈을 꾸게 되어 있지', '', 'und so ist das Leben zum Träumen da', '순리', '서시', 'daher보다 so가 부드러움'),
  ('e58f3f370c88b', 176, '시어·표현', '일장춘몽', '一場春夢', 'ein flüchtiger (Frühlings-)Traum', '확정', false, '', 'a fleeting spring dream ⟨미확인⟩', '', '', '', '', '', '', '순리', '서시', '★이름씨는 큰 글자로 쓴다: (Frühlings-)Traum. 앞의 (Frühlings)traum 은 표기 오류였다'),
  ('e698cc92a67c0', 177, '시어·표현', '입으로 (성경 인용과 되받는 자리)', '', 'mit dem Munde / mit dem Mund', '검토 필요', true, '⚠편집 때 고를 것 — 옛 여격(Munde)은 인용 신호, 현대형(Mund)은 말투를 낮춘다. ★두 자리를 반드시 같은 꼴로 맞춘다', '', '', '', '', '', '', '', '만나는 방법', '명상하는 방법', '성경 인용과 저자가 되받는 자리, 두 곳에 나온다'),
  ('e6e1de4133eab', 178, '시어·표현', '정을 주다', '', 'sein Herz verschenken', '확정', false, '', 'to give one''s heart ⟨미확인⟩', '', '', '', '', '', '', '순리', '', 'Zuneigung entwickeln은 산문적'),
  ('e6bf88bfe8ebe', 179, '시어·표현', '짐을 벗다', '', 'die Last ablegen', '확정', false, '', 'be free of the burden', '', '', '', '', '', '', '순리', '깨달음', ''),
  ('eef7c6487fdcc', 180, '시어·표현', '철없는', '', 'kindisch', '맥락 선택', false, '', 'childish / immature ⟨미확인⟩', '', '', '', '', '', '', '순리', '도(道)', '도(道)에서는 unreif 사용 — 통일 필요'),
  ('e9488263d7ae1', 181, '시어·표현', '초동', '樵童', 'Hirte', '확정', false, '', 'herd boy ⟨미확인⟩', '', '', '', '', '', '', '순리', '열반송', ''),
  ('e9f4201469049', 182, '시어·표현', '튀는 이', '', 'derjenige, der herausragt', '확정', false, '', 'one who stands out ⟨미확인⟩', '', '', '', '', '', '', '순리', '서시', ''),
  ('eb96b7c12b54a', 183, '시어·표현', '평인', '平人', 'ein gewöhnlicher Mensch', '확정', false, '', 'an ordinary person ⟨미확인⟩', '', '', '', '', '', '', '순리', '서시', ''),
  ('eb254b082ab6c', 184, '시어·표현', '하늘 터전 닦다', '', 'den Boden des Himmels bereiten', '확정', false, '', 'to prepare the ground of heaven ⟨미확인⟩', '', '', '', '', '', '', '순리', '열반송', ''),
  ('ea321e7987ce4', 185, '시어·표현', '하늘의 소식', '', 'Nachrichten des Himmels', '확정', false, '', '', '', '', '', '', '', '', '순리', '', ''),
  ('ee35144bff423', 186, '시어·표현', '한 맺힘', '恨', 'aufgestaute Bitterkeit', '확정', false, '', 'pent-up grief (han) ⟨미확인⟩', '', '', '', '', '', '', '순리', '', ''),
  ('e7b74ed492b63', 187, '시 제목', '깨달음', '', 'Erleuchtung', '확정', false, '', 'Enlightenment ⟨미확인⟩', 'enlightenment ⟨미확인⟩', '', '', '', '', '', '순리 · 가짐', '', ''),
  ('e6cd46062e357', 188, '시 제목', '깨달음 I', '', 'Erleuchtung I', '확정', false, '', 'Enlightenment I ⟨미확인⟩', '', '', '', '', '', '', '순리', '', ''),
  ('e106f3f57ebf3', 189, '시 제목', '도(道)', '道', 'Dō', '확정', false, '', 'The Way ⟨미확인⟩', '', '', '', '', '', '', '순리', '', '초안 제목 Der Weg (道)'),
  ('e3125186fb80e', 190, '시 제목', '마음자리 게송', '偈頌', 'Gesang vom Ort des Herzens', '확정', false, '', 'Gatha of the Mind''s Ground ⟨미확인⟩', '', '', '', '', '', '', '순리', '', '게송 → Gesang'),
  ('e7ed095e30f4c', 191, '시 제목', '번뇌', '煩惱', 'Kleshas (Leiden und Verwirrung)', '확정', false, '', 'Kleshas ⟨미확인⟩', 'kleshas', '', '', '', '', '', '순리 · 가짐', '번뇌', '괄호 설명은 제목에서 한 번, 본문은 Kleshas 단독. 영문본도 kleshas 유지'),
  ('eed44197965e5', 192, '시 제목', '벌거숭이', '', 'Der Nackte', '확정', false, '', 'Naked ⟨미확인⟩', '', '', '', '', 'Naked', 'Mein Leben ist nackt (본문의 형용사 자리)', '순리', '', '★「벌거숭이」는 이름씨(사람)이므로 Der Nackte 가 맞다 (저자 확정 2026-09-26). 「Der Nackt」는 독일어 문법에 맞지 않는다. 영문본 제목은 Naked(형용사)이나 한국어를 따른다. 본문의 「Mein Leben ist nackt」는 형용사라 그대로 둔다'),
  ('e76862e6a485a', 193, '시 제목', '부정에서 긍정으로 (산문)', '', 'Von der Negativität zur Positivität', '신규 제안', false, '', 'From Negativity to Positivity', '', '', '', '', '', '', '순리', '', '산문. 한·독·영 편집본. 독일어 제목이 비어 있어 영문본 (From Negativity to Positivity)을 따라 새로 지었다 — 확인 필요'),
  ('e3ccefad498de', 194, '시 제목', '서시', '序詩', 'Prolog des natürlichen Flusses', '확정', false, '', 'Prolog of nature''s flow', '', '', '', '', '', '', '순리', '', '가장 많이 다듬은 시'),
  ('e95471f6b0a1f', 195, '시 제목', '소', '', 'Rind', '검토 필요', false, '', 'The Ox ⟨미확인⟩', '', '', '', '', '', '', '순리', '', 'Rind/Ochse 문제는 ''재검토 사항'' 참조'),
  ('e3eff9fb23296', 196, '시 제목', '아다다', '', 'Adada', '확정', false, '', 'Adada ⟨미확인⟩', '', '', '', '', '', '', '순리', '', '고유명 그대로'),
  ('ea97dd041fdfd', 197, '시 제목', '열반송', '涅槃頌', 'Lied der vollkommenen Befreiung', '확정', false, '', 'Song of Nirvana ⟨미확인⟩', '', '', '', '', '', '', '순리', '', '송 → Lied. 의미 번역, 본문은 Nirwana'),
  ('ee830f9d788f6', 198, '시 제목', '인생', '人生', 'Das menschliche Leben', '확정', false, '', 'Life ⟨미확인⟩', '', '', '', '', '', '', '순리', '', ''),
  ('ea38ac0910207', 199, '시 제목', '자아 발견', '自我發見', 'Selbsterkenntnis', '확정', false, '', 'Self-Discovery ⟨미확인⟩', '', '', '', '', '', '', '순리', '', '본문에서는 die Entdeckung des Selbst도 사용'),
  ('e693df9d0ba7c', 200, '시 제목', '자연의 흐름 속의 삶', '', 'Leben im natürlichen Fluss', '확정', false, '', 'Life of nature''s flow', '', '', '', '', '', '', '순리', '', 'p.87'),
  ('e5c72474a3a75', 201, '시 제목', '지혜', '', 'Weisheit', '확정', false, '', 'Wisdom ⟨미확인⟩', '', '', '', '우리는 흔히들 사람이 세상 살면서 지혜가 없다고도 하고 지혜가 있다고도 한다.', '', 'Wir sagen oft von Menschen, sie hätten keine Weisheit, oder auch, sie hätten Weisheit.', '순리', '', ''),
  ('efff6d9e22e14', 202, '산문 제목', '마음이란', '', 'Was der Geist ist', '신규 제안', false, '', '', '', 'What is the mind?', '', '마음이란 자기가 살아온 산 삶의 경험이 바탕이 되어 자기의 마음이 형성되는 것이다.', '', 'Der Geist bildet sich auf der Grundlage der Erfahrungen des Lebens, das man gelebt hat.', '만나는 방법', '', '산문. 물음꼴 대신 간접의문'),
  ('e1dc9a8a73dca', 203, '산문 제목', '명상하는 방법', '', 'Wie man meditiert', '신규 제안', false, '', '', '', 'How to meditate properly: True meditation method', '', '', '', '', '만나는 방법', '', '산문. 영문본 제목의 뒷부분(True meditation method)은 한국어 제목에 없다'),
  ('e0c9c4ae86838', 204, '산문 제목', '삶의 이유', '', 'Warum wir leben', '확정', false, '', '', '', 'What is the purpose of life?', '', '', '', '', '만나는 방법', '', '산문'),
  ('eca26c18698da', 205, '표기 규칙', '마음빼기', '', 'Meditation', '확정', false, '', '', 'meditation', '', '', '', '', '', '가짐', '', '센터에서 사용 안 함 → 명상 / 메디테이션라이프 명상'),
  ('ef8b73e16b5ed', 206, '표기 규칙', '마음수련', '', 'Maum-Meditation / Meditationslife', '검토 필요', true, '⚠표기 규칙과 어긋난다 — 용어집의 표기 규칙은 「마음수련은 쓰지 않는다 → 메디테이션라이프 / 라이프명상」인데, 기출간 영문본은 Maum Meditation 을 쓴다. 센터와 확인 필요', '', 'Meditationslife', '', 'Maum Meditation', '', '', '', '가짐 · 하늘사람', '', '영문본: Maum Meditation. 대응표: Maum-Meditation. 용어집의 표기 규칙: 용어 사용 안 함 → 메디테이션라이프 / 라이프명상'),
  ('e0c98de216dfb', 207, '표기 규칙', '우명 선생님', '', 'der Begründer der Meditationsmethode', '확정', false, '', '', 'the founder of the meditation method', '', '', '', '', '', '가짐', '', '이름은 공식 사용 안 함'),
  ('e91acf7e5304f', 208, '표기 규칙', '진짜 · 가짜', '', 'echt / unecht', '확정', false, '', '', '', 'real / not real', 'real / false', '살아서 지금 진짜가 아니면 가짜가 아닌가. 가짜는 죽으면 가짜라 죽고 말 것이다. 진짜가 되려면 가짜인 자기가 다 죽으면 진짜로 거듭날 수가 있을 것이다.', '', 'Wer jetzt, zu Lebzeiten, nicht echt ist – ist der nicht unecht? Das Unechte wird, wenn es stirbt, als Unechtes sterben und vergehen. Um echt zu werden, muss das unechte Selbst ganz sterben; dann kann man als das Echte wiedergeboren werden.', '만나는 방법 · 하늘사람', '', '★참·거짓(das Wahre / das Falsche)과 갈라 쓴다 (저자 확정 2026-09-27, 하늘사람 대응표). 보기: Wer jetzt nicht echt ist – ist der nicht unecht?')
on conflict (id) do update set
  sort_no  = excluded.sort_no,
  cat      = excluded.cat,
  ko       = excluded.ko,
  hj       = excluded.hj,
  de       = excluded.de,
  st       = excluded.st,
  flag     = excluded.flag,
  why      = excluded.why,
  en_sunri = excluded.en_sunri,
  en_wants = excluded.en_wants,
  en_meeting = excluded.en_meeting,
  en_heaven = excluded.en_heaven,
  ex_ko    = excluded.ex_ko,
  ex_en    = excluded.ex_en,
  ex_de    = excluded.ex_de,
  book     = excluded.book,
  poem     = excluded.poem,
  memo     = excluded.memo
where glossary_entries.updated_by = '';   -- ★손대지 않은 줄만 덮어쓴다


-- ── 4. 결과 ─────────────────────────────────────────────────────
select
  count(*)                                   as "이제_모두",
  count(*) filter (where flag)               as "결정_대기",
  count(*) filter (where updated_by <> '')   as "동료_것_그대로_둠"
from glossary_entries;


-- ── 5. 동료가 고쳐서 건너뛴 줄 — 마스터와 다를 수 있습니다 ──────
-- 이 목록을 클로드에게 주시면 마스터에 담아 드립니다.
select ko as "한국어", de as "사이트의 독일어", st as "상태",
       updated_by as "고친 이", memo as "메모"
from glossary_entries
where updated_by <> ''
order by ko;


-- ── 6. 버려진 줄 치우기 ─────────────────────────────────────────
-- 표제어 이름이 바뀌면 줄을 알아보는 id 도 바뀌어, 옛 줄이 유령처럼 남습니다.
-- 마스터에 없는 줄을 치웁니다. 다만 ★이 둘은 건드리지 않습니다★:
--   · 사이트에서 새로 넣은 낱말 (book = '앱에서 넣음')
--   · 동료가 고친 줄 (updated_by <> '')

-- 먼저 무엇이 치워질지 보여 줍니다
select ko as "치워질_한국어", de as "독일어", book as "어디서"
from glossary_entries
where id not in (
   'e420ba6560730', 'e7bb31572f798', 'ee97474792108', 'ebc4a981568ab', 'e1eba93348531', 'ee984c8dfacea',
   'ef758529589af', 'e9c30b3b92876', 'ede8b6c7871ea', 'e3f45761dbe05', 'e6687c0a6a05d', 'e4fe9cf4d2e62',
   'ee9a517fc86fb', 'ea1405eb13538', 'e6297e393a80b', 'e2f826f3ee651', 'e3299d0c5f4f3', 'e2bd3a4071175',
   'e55637d14ea2c', 'e6dd1a9f13d3f', 'e19c4fb84001e', 'e5f74adfb9eb8', 'e16e8e4fd0620', 'e35388af76950',
   'e98acb69f31cc', 'e47f13f8bdc87', 'ec9c118f6483a', 'e4316fb9baf97', 'e8b42ef9c531b', 'e4e0790b7fe6a',
   'e6a150c47c21a', 'eed6577c7efdf', 'e402574f67d3c', 'ee1c7c31a826f', 'e90c3a21f7bfa', 'ee519941e85ac',
   'ec337b1d13331', 'e44f3c1bb3797', 'e072bb9e68eeb', 'e0fe389e89501', 'e90e191d362e6', 'e93d5cf37c1e3',
   'eb3ed8b11891e', 'e53d34f004e2e', 'e04c8a43663b5', 'e4da963f30957', 'e3fc55800a09e', 'e64a96b5fbee4',
   'e5ae3a785609c', 'e1d6a88ad6833', 'e9f521ff9da3a', 'edca01e517afe', 'e26cc862db51b', 'effa64d3d5103',
   'e3efbdd581642', 'ef221d8a877bc', 'ea33e8f708f12', 'e934dd25ec5f7', 'e1f563c873559', 'ed36c4dcdb11c',
   'ef84234af1124', 'ea93803c5da03', 'e6d6dc9a3419f', 'e93ab371bcaa1', 'ec3d78839f92b', 'ea3955bff910f',
   'e5a4348e7468d', 'e1a7ace0b40d4', 'e567527bb1a18', 'e1642542019a3', 'e54f02a425042', 'ed6dcbbfa11d1',
   'eea509247ac7a', 'ed936378a5049', 'eb153ca72572b', 'ea658847c065e', 'e2c43a47604d7', 'e0ec44fc67318',
   'e2744f5df977f', 'e9b15c47e82e7', 'e0614e6b00ec5', 'ecaeb0753687a', 'effd041247330', 'eaefb7150a6eb',
   'e2018a4d80a7e', 'e1c82ad6c86c9', 'e62ff2ed617c7', 'e2874ce3a605c', 'ee60a6212ac09', 'efc20115b4278',
   'ed17c95e195ea', 'e8c8458c6a6df', 'e059bc977bd3e', 'ee85afbae7497', 'e176124afd6d5', 'e23108f40e57c',
   'ebe1afd962eae', 'e0b853ed50154', 'e0cf2492c438f', 'ed0834e9983c8', 'e3a41342cb6d4', 'e284e0f11088d',
   'e874d8f5616f1', 'e5a6e13bb4379', 'e9261bf9840fc', 'e3235b07cbda8', 'ebd0b9f725e4b', 'e47def5b15528',
   'eed7034dc8f47', 'eb067fe9b0dab', 'e61e2ce95fede', 'ecedffbae3cda', 'e0643ebed7b48', 'e025c7787cd5f',
   'eace675521201', 'ea00589d89872', 'e152ba2af06d7', 'eeb02571524b8', 'e0232d64427d6', 'e678ae6c0a39d',
   'e9b21b7e7d341', 'ee1cdc753c3a7', 'ebed275fcedd4', 'e28891b8843bb', 'e86e748a92e1a', 'edd318b88161e',
   'eb6e33644ea79', 'e5fa8022353eb', 'e97d5254eaad3', 'e0f13689cc62a', 'ec54adfe0a8c8', 'e6dd14e773fa1',
   'e2fb0f3ef8466', 'ee70cb18dbe4c', 'e4b6826f4f6a2', 'e615405046e5c', 'e1cf7d6e64452', 'e00355ed7bf29',
   'e0100cbe07829', 'eb037fcbe1ac2', 'e37167893ca01', 'ebfef880fc0c6', 'e9efb3f80641f', 'e94f85a8066d2',
   'e1eeea7e800b0', 'e9cb03bcc1d1e', 'e13333674019e', 'e37d7ccdcaad0', 'e89e314d1a432', 'eb6ba6cbc4163',
   'e59ec38ef7c7c', 'e9bd9a7e39d44', 'eac15072cbbe5', 'e7f9c800c6d24', 'eba2d457be850', 'e15e028e83f13',
   'e3b040eab1375', 'e11e1eb287fa2', 'e7bd251cdf76f', 'e6d48127f5c4f', 'e16d9e24dcb5f', 'ea6fb74a85131',
   'ed4937c619d1c', 'ecbed5d5ee0d1', 'e561f3802ca68', 'eeae53a867b5a', 'e1a1cf034e6eb', 'eda0c0d71df42',
   'e8f58b1f536db', 'e695ab5295c7d', 'ebed5731de6ba', 'e1a243fada55e', 'efcc3df570adf', 'e1a76d9d75410',
   'e1c377a905dbc', 'e58f3f370c88b', 'e698cc92a67c0', 'e6e1de4133eab', 'e6bf88bfe8ebe', 'eef7c6487fdcc',
   'e9488263d7ae1', 'e9f4201469049', 'eb96b7c12b54a', 'eb254b082ab6c', 'ea321e7987ce4', 'ee35144bff423',
   'e7b74ed492b63', 'e6cd46062e357', 'e106f3f57ebf3', 'e3125186fb80e', 'e7ed095e30f4c', 'eed44197965e5',
   'e76862e6a485a', 'e3ccefad498de', 'e95471f6b0a1f', 'e3eff9fb23296', 'ea97dd041fdfd', 'ee830f9d788f6',
   'ea38ac0910207', 'e693df9d0ba7c', 'e5c72474a3a75', 'efff6d9e22e14', 'e1dc9a8a73dca', 'e0c9c4ae86838',
   'eca26c18698da', 'ef8b73e16b5ed', 'e0c98de216dfb', 'e91acf7e5304f'
  )
  and book <> '앱에서 넣음'
  and updated_by = '';

-- 그리고 치웁니다
delete from glossary_entries
where id not in (
   'e420ba6560730', 'e7bb31572f798', 'ee97474792108', 'ebc4a981568ab', 'e1eba93348531', 'ee984c8dfacea',
   'ef758529589af', 'e9c30b3b92876', 'ede8b6c7871ea', 'e3f45761dbe05', 'e6687c0a6a05d', 'e4fe9cf4d2e62',
   'ee9a517fc86fb', 'ea1405eb13538', 'e6297e393a80b', 'e2f826f3ee651', 'e3299d0c5f4f3', 'e2bd3a4071175',
   'e55637d14ea2c', 'e6dd1a9f13d3f', 'e19c4fb84001e', 'e5f74adfb9eb8', 'e16e8e4fd0620', 'e35388af76950',
   'e98acb69f31cc', 'e47f13f8bdc87', 'ec9c118f6483a', 'e4316fb9baf97', 'e8b42ef9c531b', 'e4e0790b7fe6a',
   'e6a150c47c21a', 'eed6577c7efdf', 'e402574f67d3c', 'ee1c7c31a826f', 'e90c3a21f7bfa', 'ee519941e85ac',
   'ec337b1d13331', 'e44f3c1bb3797', 'e072bb9e68eeb', 'e0fe389e89501', 'e90e191d362e6', 'e93d5cf37c1e3',
   'eb3ed8b11891e', 'e53d34f004e2e', 'e04c8a43663b5', 'e4da963f30957', 'e3fc55800a09e', 'e64a96b5fbee4',
   'e5ae3a785609c', 'e1d6a88ad6833', 'e9f521ff9da3a', 'edca01e517afe', 'e26cc862db51b', 'effa64d3d5103',
   'e3efbdd581642', 'ef221d8a877bc', 'ea33e8f708f12', 'e934dd25ec5f7', 'e1f563c873559', 'ed36c4dcdb11c',
   'ef84234af1124', 'ea93803c5da03', 'e6d6dc9a3419f', 'e93ab371bcaa1', 'ec3d78839f92b', 'ea3955bff910f',
   'e5a4348e7468d', 'e1a7ace0b40d4', 'e567527bb1a18', 'e1642542019a3', 'e54f02a425042', 'ed6dcbbfa11d1',
   'eea509247ac7a', 'ed936378a5049', 'eb153ca72572b', 'ea658847c065e', 'e2c43a47604d7', 'e0ec44fc67318',
   'e2744f5df977f', 'e9b15c47e82e7', 'e0614e6b00ec5', 'ecaeb0753687a', 'effd041247330', 'eaefb7150a6eb',
   'e2018a4d80a7e', 'e1c82ad6c86c9', 'e62ff2ed617c7', 'e2874ce3a605c', 'ee60a6212ac09', 'efc20115b4278',
   'ed17c95e195ea', 'e8c8458c6a6df', 'e059bc977bd3e', 'ee85afbae7497', 'e176124afd6d5', 'e23108f40e57c',
   'ebe1afd962eae', 'e0b853ed50154', 'e0cf2492c438f', 'ed0834e9983c8', 'e3a41342cb6d4', 'e284e0f11088d',
   'e874d8f5616f1', 'e5a6e13bb4379', 'e9261bf9840fc', 'e3235b07cbda8', 'ebd0b9f725e4b', 'e47def5b15528',
   'eed7034dc8f47', 'eb067fe9b0dab', 'e61e2ce95fede', 'ecedffbae3cda', 'e0643ebed7b48', 'e025c7787cd5f',
   'eace675521201', 'ea00589d89872', 'e152ba2af06d7', 'eeb02571524b8', 'e0232d64427d6', 'e678ae6c0a39d',
   'e9b21b7e7d341', 'ee1cdc753c3a7', 'ebed275fcedd4', 'e28891b8843bb', 'e86e748a92e1a', 'edd318b88161e',
   'eb6e33644ea79', 'e5fa8022353eb', 'e97d5254eaad3', 'e0f13689cc62a', 'ec54adfe0a8c8', 'e6dd14e773fa1',
   'e2fb0f3ef8466', 'ee70cb18dbe4c', 'e4b6826f4f6a2', 'e615405046e5c', 'e1cf7d6e64452', 'e00355ed7bf29',
   'e0100cbe07829', 'eb037fcbe1ac2', 'e37167893ca01', 'ebfef880fc0c6', 'e9efb3f80641f', 'e94f85a8066d2',
   'e1eeea7e800b0', 'e9cb03bcc1d1e', 'e13333674019e', 'e37d7ccdcaad0', 'e89e314d1a432', 'eb6ba6cbc4163',
   'e59ec38ef7c7c', 'e9bd9a7e39d44', 'eac15072cbbe5', 'e7f9c800c6d24', 'eba2d457be850', 'e15e028e83f13',
   'e3b040eab1375', 'e11e1eb287fa2', 'e7bd251cdf76f', 'e6d48127f5c4f', 'e16d9e24dcb5f', 'ea6fb74a85131',
   'ed4937c619d1c', 'ecbed5d5ee0d1', 'e561f3802ca68', 'eeae53a867b5a', 'e1a1cf034e6eb', 'eda0c0d71df42',
   'e8f58b1f536db', 'e695ab5295c7d', 'ebed5731de6ba', 'e1a243fada55e', 'efcc3df570adf', 'e1a76d9d75410',
   'e1c377a905dbc', 'e58f3f370c88b', 'e698cc92a67c0', 'e6e1de4133eab', 'e6bf88bfe8ebe', 'eef7c6487fdcc',
   'e9488263d7ae1', 'e9f4201469049', 'eb96b7c12b54a', 'eb254b082ab6c', 'ea321e7987ce4', 'ee35144bff423',
   'e7b74ed492b63', 'e6cd46062e357', 'e106f3f57ebf3', 'e3125186fb80e', 'e7ed095e30f4c', 'eed44197965e5',
   'e76862e6a485a', 'e3ccefad498de', 'e95471f6b0a1f', 'e3eff9fb23296', 'ea97dd041fdfd', 'ee830f9d788f6',
   'ea38ac0910207', 'e693df9d0ba7c', 'e5c72474a3a75', 'efff6d9e22e14', 'e1dc9a8a73dca', 'e0c9c4ae86838',
   'eca26c18698da', 'ef8b73e16b5ed', 'e0c98de216dfb', 'e91acf7e5304f'
  )
  and book <> '앱에서 넣음'
  and updated_by = '';


-- ── 7. 마무리 ───────────────────────────────────────────────────
select count(*) as "끝난_뒤_모두" from glossary_entries;
