# Roadmap — Rap lyrics app (Flutter)

Policy: no manual implementation if a library already does it.

## Phase 1 — Foundations

- [x] `flutter create`, folder structure (`lib/models`, `lib/data`, `lib/ui`, `lib/services`)
- [x] Lint/format config (`flutter_lints`, `dart format` in pre-commit if possible)
- [x] `riverpod` integration: root `ProviderScope`, providers structured by domain (projects, lines, audio)
- [x] Data models with `freezed` + `json_serializable`: `Projet`, `Ligne`, `Audio`
- [x] `drift` schema: `projets` table, `lignes` table (text, detected language, nullable timecode, project FK), `audios` table (local path, duration, project FK)
- [x] Projects list screen (empty state handled)
- [x] "New project" creation screen (name, default language)
- [x] Basic navigation between screens (`go_router` or native `Navigator` depending on final complexity)

## Phase 2 — Notepad mode

- [x] Line editor via `ReorderableListView` (native): add, delete, reorder
- [x] `flutter_langdetect` integration: detect the language at the end of a line
- [x] Fetch and parse the Lexique dictionary (FR) → SQLite table indexed by word-ending sound
- [x] Fetch and parse the CMU Pronouncing Dictionary (EN) → same structure
- [x] `drift` query: find rhymes matching the current line's ending sound
- [x] Rhyme suggestions UI panel, with one-click insertion into the line

## Phase 3 — Timecoded mode

- [ ] `file_picker` integration: select an audio file on the phone
- [ ] Copy the selected audio file into the app's documents folder
- [ ] `just_audio` integration: play, pause, seek
- [ ] `audio_waveforms` integration: waveform display to visually align timecodes
- [ ] Per-line timecode-setting UI ("mark this line at time T" during playback)
- [ ] Persist timecodes in the database, linked to each `Ligne`
- [ ] Lyrics scrolling synced to the current playback position
- [ ] Support timecodes without an audio file (manual placement of time markers)

## Phase 4 — Export and file management

- [ ] Serialize a full project to JSON (lines, timecodes, metadata)
- [ ] `archive` integration: package into a `.rapproj` bundle (JSON + copied audio file)
- [ ] Export the bundle via `file_picker` (choose destination folder)
- [ ] Import a `.rapproj` bundle: deserialize and fully restore into the database
- [ ] Clean project deletion, including cleanup of the associated audio file on disk

## Phase 5 — Rap mode

- [ ] Clean display screen, with no editing elements
- [ ] `scrollable_positioned_list` integration: scrolling locked to the line index matching the timecode
- [ ] Auto-scroll sub-mode (follows audio playback if available)
- [ ] Static sub-mode, manual scroll
- [ ] `wakelock_plus` integration: prevents the screen from turning off during display
- [ ] Full-screen mode via `SystemChrome` (immersive mode)
- [ ] Font size adjustment for readability in studio/stage conditions

## Phase 6 — Polish and personal distribution

- [ ] Light/dark theme via native `ThemeData`
- [ ] `flutter_lucide` (or equivalent) integration for a consistent icon set
- [ ] General UI polish (spacing, visual consistency across screens)
- [ ] Local Android APK build for direct installation
- [ ] iOS ad-hoc/personal team build via Xcode for installation on your own iPhone
- [ ] If open source is chosen: create the public repo, write the README, pick a license
