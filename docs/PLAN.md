# WHEEL FC mobile — implementation plan

## What was found (2026-10-31)

| Item | Value |
| --- | --- |
| Flutter | 3.41.6 stable (Dart 3.11.4) |
| SDK constraint | `^3.11.4` (kept) |
| Package / bundle id | `wheel_mobile` · Android `com.hamza.wheel_mobile` (kept) |
| Lints | `flutter_lints ^6.0.0` (kept, extra rules added) |
| Existing code | default counter app (`lib/main.dart`, `test/widget_test.dart`) — replaced |

## Packages added

Runtime: `flutter_bloc`, `bloc_concurrency`, `equatable`, `dio`, `get_it`, `go_router`,
`freezed_annotation`, `json_annotation`, `flutter_secure_storage`, `shared_preferences`,
`connectivity_plus`, `uuid`, `fl_chart`, `cached_network_image`, `intl`,
`flutter_localizations` (sdk), `share_plus`, `url_launcher`, `google_fonts` (Cairo), `logger`,
plus `device_info_plus` (login `device_name`) and `image_picker` (player photo upload).

Dev: `freezed`, `json_serializable`, `build_runner`, `bloc_test`, `mocktail`.

## Folder tree

```
lib/
  main.dart                 bootstrap (DI, Bloc observer, runApp)
  app/                      app.dart · router.dart · di.dart · shell (bottom nav)
  core/
    entities/               shared pure-Dart value types (Tier, Movement, MatchResult, Insight, …)
    error/                  failures · exceptions · error_mapper · failure_messages (l10n)
    l10n/                   app_ar.arb · app_en.arb (+ generated AppLocalizations)
    network/                dio_client · interceptors (auth, locale, etag, network-status, logging)
                            api_endpoints · api_config · cached_api · connectivity_service
    polling/                version_poller (+ version source)
    result/                 Result<T> = Success | Err
    storage/                secure_token_storage · json_cache
    theme/                  colors · typography · app_theme
    utils/                  json_parsing · match_clock · debouncer · date_utils · number_format · device_name
    widgets/                tier_badge, player_avatar, trend_arrow, stat_chip, form_dots, state views, section_card …
  features/<feature>/
    data/        datasources · models (fromJson → toEntity) · repositories (impl)
    domain/      entities · repositories (abstract) · usecases (one class = one action)
    presentation/ bloc · pages · widgets
```

Features: `home, standings, players, matches, leaderboards, awards, team, rules, live_viewer, more,
auth, live_desk, admin_matches, admin_players, admin_settings`.

## Screens

Viewer (bottom nav): Home · Standings · Matches · Stats (leaderboards + awards) · More.
Pushed: Player profile · Match detail · Team · Rules · Live viewer.
Admin: Login (email / PIN) · Admin hub · Live desk (setup → desk → finish/summary) ·
Finished matches (list, detail, editor) · Players (list/reorder, form + photo) · Settings (rating config, team, recompute).

## Key decisions

- Viewer screens use a shared `DataState<T>` (status enum + data) so pull-to-refresh / silent
  refresh never blanks the screen; cubits first show cached JSON, then fetch.
- `VersionPoller` exposes `dataChanges` / `liveChanges` streams; viewer cubits subscribe.
- Live desk: the phone is the source of truth. `LiveMatchState` (freezed) is persisted on every
  change; the only write path during the match is `PUT /admin/live/sync` (debounced 350 ms,
  sequential, retried every 4 s and on connectivity regained).

## Final architecture (as built)

### Layers
- **Domain** (pure Dart): `Equatable` entities, `LiveMatchState`/`LiveEvent`/`LiveClock` with
  `freezed`, abstract repositories, one use case class per file with `call()`.
  `LiveMatchRules` (extension) holds every live-desk transition and the sanitiser;
  `MatchEditorMapper` rebuilds editable events from a finished match.
- **Data**: DTOs parse with the `core/utils/json_parsing.dart` helpers (§5.9) and expose
  `toEntity()`. Repositories wrap every call in `guard()` → `Result<T>` (never throw).
  The persisted live state uses a `json_serializable` DTO.
- **Presentation**: cubits for screens, `MatchesBloc` / `AuthBloc` / `LiveDeskBloc` for event flows.

### Cross-cutting
- `CachedApi`: every public GET body is stored in `JsonCache`; on connectivity errors the cached
  body is returned. `DataCubit` shows the cached copy first, then fetches (`DataState.status`
  keeps data visible while refreshing/failing).
- Interceptors: locale/accept (`Accept-Language: ar` always) → auth (Bearer on `/admin/*`,
  401 → clear token + `sessionExpired`) → ETag (stores ETag + body per URL, sends `If-None-Match`;
  Dio's `validateStatus` accepts 304, which is answered from the stored body) → network status
  (offline banner) → logging (debug only).
- `VersionPoller`: `/version` every 10 s in the foreground (`AppLifecycleListener`), streams
  `dataChanges`, `liveChanges`, `anyChanges` feed the viewer cubits. Admin writes call
  `pollNow(forceDataRefresh: true)`.
- Errors: `ErrorMapper` → sealed `Failure` carrying the server's Arabic `message`;
  `FailureMessage.message(l10n)` shows it, falling back to l10n text only when there is none
  (no connection, parsing, empty body).
- Dates are calendar days (`YYYY-MM-DD`), no time-zone shift. `asIntMap` still accepts `[]` /
  `""` keys so old cached responses keep parsing.
- `/home` tier players carry photo/number/GK/tiers and the team carries absolute `crest_url` /
  `group_photo_url` — no merge with `/players`, no storage-URL building (still used only for the
  admin `photo_path` fallback). Awards are keyed by `key`; values shown with up to 2 decimals.

### Live desk
- Every local change → sanitise → persist (`SharedPreferences`) → `LiveDeskSyncRequested`.
- Sync events are debounced (350 ms) and processed one at a time (`asyncExpand`), and sync work
  from finish/sync is serialised through a single queue, so requests never overlap.
- `PUT /admin/live/sync` is the only write path and also **creates** the live match: setup →
  save locally → sync. `serverCreated` now means "a sync succeeded" (gates the clock hint and
  `DELETE` on discard). The sync body always has every key.
- The sync response (admin live state) is parsed: `server_now_ms` refreshes the clock offset and
  differences from the local state are only logged (`onServerDiff` → `Logger.w`).
- `POST /admin/live/clock` replies feed the offset too (`LiveDeskServerTimeReceived`).
- Sync 409 → `GET /admin/live`: a different live match → resume (take the server state) or
  discard (`DELETE /admin/live`, then sync ours again); no live match → our code was already
  published → the local copy is dropped after a notice.
- Failures mark `offline`/`error` and retry after 4 s; regained connectivity triggers a sync.
  If newer edits arrived during a sync (revision check), another sync is queued.
- Finish runs up to 3 exclusive syncs and only calls `/finish` once synced; its `summary` already
  starts with the score. Publish uses the returned public match (code) to navigate, clears local
  state and forces a public refresh. A 404 on discard counts as "already gone".

### Admin
- `GET /admin/matches?page=` (public match objects + `meta`) reuses `MatchesBloc` (it takes a
  page-fetcher function) and the shared `MatchesListView`.
- The editor pre-fills from the editor-shaped `GET /admin/matches/{code}`; saved with `PUT`
  (no clock, plus `note`). Match detail shows the new `ratings` as "النقاط والتقييم".
- Login/PIN responses carry `permissions` (no `/auth/me` after login); PIN = match admin.
- Settings: `recompute` reads `data.version`; "نسخة احتياطية" downloads `GET /admin/export` and
  shares it as a `.json` file (`share_plus` `XFile.fromData`).

### Tests (139)
Unit: clock, JSON helpers, error mapper, every DTO against `test/fixtures/*.json` (incl. sync,
clock, publish, editor shape, ratings), live rules, validators, poller. Bloc: Home, PlayerProfile,
Matches (pagination), LiveViewer, Auth, LiveDesk (open/resume, sync-creates start, offline retry,
server offset + diff logging, 409 resume / discard / already-published, events, debounce, clock
offset, finish gating, publish, 404 discard). Repository: fake Dio adapter for success,
304/ETag, offline cache, 401, sync keys + response, 409, 404, 422, login without `/me`,
recompute, export. Widget: tier card badges, live scoreboard labels, PIN pad.

### Deviations / decisions
- Added `core/entities`, `core/models`, `core/bloc` (shared types, the `DataCubit` base) and a
  small `features/more` page — not listed in the brief's tree.
- Added `device_info_plus` (login `device_name`) and `image_picker` (photo upload).
- Kept `flutter_lints` (the project's choice) with a few stricter rules.
- ETags live in memory only, so after an app restart the first request is a full 200 (the JSON
  cache still opens the screen instantly).
- The live desk resumes local state whenever the desk is opened (from app start or later); the
  app does not auto-navigate to the desk on launch.
- English ARB is a skeleton; untranslated keys fall back to Arabic.
- Live viewer data (`/live`) is never cached — stale live data would mislead.
- Fonts come from `google_fonts` (Cairo) at runtime; bundle them as assets if fully offline first
  launch matters.
