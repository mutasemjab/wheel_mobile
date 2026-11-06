# WHEEL FC — Mobile

تطبيق فريق **WHEEL FC**: التقييمات، الفئات، المباريات، الإحصائيات، ومكتب المباراة المباشرة للإدارة.
Flutter · BLoC · Clean Architecture. الواجهة عربي (RTL)، والـ backend هو Laravel على `/api/v1`.

> English version below.

---

## بالعربي

### المتطلبات
- Flutter **3.41** (stable) / Dart **3.11** أو أحدث.
- Android Studio أو Xcode حسب المنصة.
- الـ backend شغّال (XAMPP محلياً أو السيرفر).

### التشغيل
عنوان الـ API بينبعث وقت البناء بـ `--dart-define=API_BASE_URL=...` (ما في عنوان production مكتوب بالكود).

| البيئة | الأمر |
| --- | --- |
| محاكي Android (XAMPP على نفس الجهاز) | `flutter run --dart-define=API_BASE_URL=http://10.0.2.2/wheel/api/v1` |
| جهاز حقيقي على نفس الشبكة | `flutter run --dart-define=API_BASE_URL=http://<PC-IP>/wheel/api/v1` |
| Production | `flutter run --release --dart-define=API_BASE_URL=https://<domain>/wheel/api/v1` |

- إذا ما حطيت `API_BASE_URL`، الافتراضي هو `http://10.0.2.2/wheel/api/v1` (محاكي Android).
- **جهاز حقيقي:** لازم `APP_URL` بالـ backend يكون نفس الـ IP (`http://<PC-IP>/wheel`)، لأنه السيرفر بيبني `photo_url` منه؛ غير هيك الصور ما رح تفتح عالموبايل.
- الـ HTTP العادي (بدون https) مسموح بس بنسخة الـ debug على Android (`android/app/src/debug/AndroidManifest.xml`)، وعلى iOS عن طريق `NSAllowsLocalNetworking` للشبكة المحلية بس.

### توليد الكود
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + json_serializable
flutter gen-l10n                                            # ملفات الترجمة (بتصير تلقائياً مع pub get)
```

### الفحوصات
```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

### البناء
```bash
# Android
flutter build apk --release --dart-define=API_BASE_URL=https://<domain>/wheel/api/v1
flutter build appbundle --release --dart-define=API_BASE_URL=https://<domain>/wheel/api/v1

# iOS (على Mac)
flutter build ipa --release --dart-define=API_BASE_URL=https://<domain>/wheel/api/v1
```
ملاحظة: نسخة الـ release على Android لسا بتوقّع بمفتاح الـ debug (من قالب Flutter) — لازم تضيف signing config قبل النشر على المتجر.

### الإدارة
من **المزيد ← دخول الإدارة**: إيميل وكلمة سر، أو رمز PIN. الشاشات بتظهر حسب الصلاحيات (`permissions`) اللي بيرجعها `GET /admin/auth/me`:
`live.manage` مكتب المباراة · `matches.update/delete` المباريات المنتهية · `players.*` اللاعبين · `config.update` الإعدادات وإعادة الحساب.

مكتب المباراة المباشرة بيشتغل بدون نت: الموبايل هو المرجع خلال المباراة، كل تغيير بينحفظ عالجهاز وبينبعث للسيرفر (`PUT /admin/live/sync`) أول ما يرجع الاتصال.

---

## English

### Requirements
- Flutter **3.41** stable / Dart **3.11** or newer.
- Android Studio and/or Xcode.
- The Laravel backend running (local XAMPP or a server).

### Running
The API base URL is injected at build time with `--dart-define=API_BASE_URL=...`; no production URL lives in the code.

| Target | Command |
| --- | --- |
| Android emulator (XAMPP on the host) | `flutter run --dart-define=API_BASE_URL=http://10.0.2.2/wheel/api/v1` |
| Real device on the LAN | `flutter run --dart-define=API_BASE_URL=http://<PC-IP>/wheel/api/v1` |
| Production | `flutter run --release --dart-define=API_BASE_URL=https://<domain>/wheel/api/v1` |

- Without `API_BASE_URL` the default is `http://10.0.2.2/wheel/api/v1` (Android emulator).
- **Real device:** the backend's `APP_URL` must use the same IP (`http://<PC-IP>/wheel`); the server builds `photo_url` from it, so otherwise photos won't load on the phone.
- Plain HTTP is allowed only in Android **debug** builds (`android/app/src/debug/AndroidManifest.xml`) and on iOS via `NSAllowsLocalNetworking` (local network only).

### Code generation
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + json_serializable
flutter gen-l10n                                            # localizations (also runs on pub get)
```

### Checks
```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

### Building
```bash
# Android
flutter build apk --release --dart-define=API_BASE_URL=https://<domain>/wheel/api/v1
flutter build appbundle --release --dart-define=API_BASE_URL=https://<domain>/wheel/api/v1

# iOS (macOS only)
flutter build ipa --release --dart-define=API_BASE_URL=https://<domain>/wheel/api/v1
```
Note: Android release builds still use the template's debug signing key; add a real signing config before publishing to the Play Store.

### Architecture
Feature-first Clean Architecture (`presentation → domain ← data`), `flutter_bloc` for state, `get_it` for DI, `go_router` for navigation. See [docs/PLAN.md](docs/PLAN.md) for the folder tree, the refresh/polling strategy and the offline-first live desk design.
