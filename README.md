# 우명 용어집 / Woomyung-Glossar

한국어 · 한자 · 영어 · 독일어 번역 용어집. **등록되고 승인된 사람만** 볼 수 있습니다.

Nur für freigegebene Mitarbeitende. Ohne Freigabe durch die Administratorin
ist kein einziger Eintrag sichtbar.

## 이 저장소에는 용어집 내용이 없습니다

Dieses Repository enthält **keine** Glossardaten.

앱 껍데기(HTML·CSS·JS)만 들어 있습니다. 용어집은 Supabase에 있고,
**승인된 사람만** 읽을 수 있도록 데이터베이스 쪽에서 막혀 있습니다(RLS).
그래서 이 저장소가 공개여도 출간 전 원고는 새지 않습니다.

`config.js`의 `anonKey`는 본디 공개용 키입니다 — 막는 것은 이 키가 아니라 권한 규칙입니다.

## 쓰는 법

1. 사이트에서 **가입** (메일 · 비밀번호 · 이름)
2. 메일로 온 확인 링크를 누릅니다
3. **관리자 승인**을 기다립니다 — 승인 전에는 아무것도 보이지 않습니다
4. 승인되면 용어집이 열리고, 낱말마다 「고치기」로 바로 고칠 수 있습니다

### Auf Deutsch

1. Auf der Seite **registrieren** (E-Mail, Passwort, Name)
2. Bestätigungslink in der E-Mail anklicken
3. Auf die **Freigabe durch die Administratorin** warten — vorher ist nichts sichtbar
4. Nach der Freigabe öffnet sich das Glossar; jeder Eintrag lässt sich
   über „ändern" direkt bearbeiten

## 규칙

- **「확정 / festgelegt」은 관리자만** 정합니다 — 화면에서만이 아니라 데이터베이스가 막습니다
- 고친 자취는 **지워지지 않습니다.** 낱말마다 「이력」으로 이전 값을 봅니다
- **영문이 순리와 가짐에서 다른 것은 잘못이 아닙니다** — 각 책의 기출간 번역본을
  그대로 옮긴 것이므로 고치지 않습니다
- Abweichende englische Fassungen sind kein Fehler: sie stammen wörtlich aus der
  jeweils veröffentlichten Übersetzung.

## 만드는 쪽 (관리자용)

용어집의 정본은 `우명선생님_책번역_어휘집/작업/10_통합용어집_마스터.csv`입니다.
Supabase에 처음 넣을 SQL은 이렇게 만듭니다.

```
python 도구/사이트_SQL만들기.py      →  웹앱/supabase_설치.sql
```

그 파일을 Supabase → SQL Editor 에 붙여넣고 Run 하면 표·권한·승인 장치·용어집이 한 번에 들어갑니다.
여러 번 돌려도 안전합니다 (이미 있는 줄은 건드리지 않습니다).
