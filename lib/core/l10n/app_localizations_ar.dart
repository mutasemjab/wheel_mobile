// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'WHEEL FC';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navStandings => 'الترتيب';

  @override
  String get navMatches => 'المباريات';

  @override
  String get navStats => 'الإحصائيات';

  @override
  String get navMore => 'المزيد';

  @override
  String lastUpdated(String date) {
    return 'آخر تحديث: $date';
  }

  @override
  String get offlineBanner => 'غير متصل — آخر بيانات محفوظة';

  @override
  String get liveNow => 'مباشر هلأ';

  @override
  String liveVs(String opponent) {
    return 'WHEEL FC ضد $opponent';
  }

  @override
  String get tapToWatch => 'اضغط عشان تتابع';

  @override
  String get teamRecord => 'سجل الفريق';

  @override
  String get awards => 'الجوائز';

  @override
  String get retry => 'جرّب مرة ثانية';

  @override
  String get emptyList => 'ما في إشي لهلأ';

  @override
  String get loading => 'عم نحمّل…';

  @override
  String get errorNetwork => 'ما في اتصال بالإنترنت';

  @override
  String get errorUnauthorized => 'لازم تسجّل دخول من جديد';

  @override
  String get errorForbidden => 'ما عندك صلاحية لهاد الإشي';

  @override
  String get errorNotFound => 'مش موجود';

  @override
  String get errorConflict => 'في تعارض مع بيانات موجودة';

  @override
  String get errorValidation => 'في بيانات مش صحيحة';

  @override
  String get errorRateLimit => 'كثير محاولات، استنى دقيقة';

  @override
  String get errorServer => 'صار خطأ بالسيرفر، جرّب بعدين';

  @override
  String get errorParsing => 'وصلت بيانات مش مفهومة من السيرفر';

  @override
  String get errorCache => 'ما في بيانات محفوظة، اتصل بالإنترنت';

  @override
  String get resultWin => 'فوز';

  @override
  String get resultDraw => 'تعادل';

  @override
  String get resultLoss => 'خسارة';

  @override
  String get recordWins => 'فوز';

  @override
  String get recordDraws => 'تعادل';

  @override
  String get recordLosses => 'خسارة';

  @override
  String get recordGoalsFor => 'سجّلنا';

  @override
  String get recordGoalsAgainst => 'استقبلنا';

  @override
  String get recordCleanSheets => 'شباك نظيفة';

  @override
  String get movedUp => 'صعد';

  @override
  String get movedDown => 'نزل';

  @override
  String rankLabel(int rank) {
    return '#$rank';
  }

  @override
  String shirtNumber(int number) {
    return 'رقم $number';
  }

  @override
  String get goalkeeper => 'حارس';

  @override
  String get viewCards => 'بطاقات';

  @override
  String get viewTable => 'جدول';

  @override
  String get sortRating => 'التقييم';

  @override
  String get sortGoals => 'الأهداف';

  @override
  String get sortAssists => 'الصناعة';

  @override
  String get sortMatches => 'المباريات';

  @override
  String get playerColumn => 'اللاعب';

  @override
  String get statMatches => 'مباريات';

  @override
  String get statGoals => 'أهداف';

  @override
  String get statAssists => 'صناعة';

  @override
  String get statSaves => 'تصديات';

  @override
  String get statTackles => 'افتكاك';

  @override
  String get statWins => 'فوز';

  @override
  String get statDraws => 'تعادل';

  @override
  String get statLosses => 'خسارة';

  @override
  String get statMotm => 'نجم المباراة';

  @override
  String get statCleanSheets => 'شباك نظيفة';

  @override
  String get statFairPlay => 'لعب نظيف';

  @override
  String get statValues => 'قيم الشركة';

  @override
  String get statExcused => 'اعتذار';

  @override
  String get statLate => 'تأخير';

  @override
  String get statCaused => 'تسبّب بهدف';

  @override
  String get rating => 'التقييم';

  @override
  String ratingExact(String value) {
    return 'التقييم الدقيق: $value';
  }

  @override
  String get ratingChart => 'تطور التقييم';

  @override
  String get insights => 'ملاحظات';

  @override
  String get nextTarget => 'المطلوب بالمباراة الجاية';

  @override
  String pointsValue(String points) {
    return '$points نقطة';
  }

  @override
  String gapToNextTier(String gap) {
    return 'باقي $gap للفئة اللي فوق';
  }

  @override
  String get matchLog => 'سجل المباريات';

  @override
  String get excusedRow => 'اعتذر عن المباراة';

  @override
  String get lateRow => 'متأخر';

  @override
  String get deltaLabel => 'التغيير';

  @override
  String get matchesTitle => 'المباريات';

  @override
  String get matchDetail => 'تفاصيل المباراة';

  @override
  String get motm => 'نجم المباراة';

  @override
  String get scorers => 'الأهداف';

  @override
  String assistBy(String name) {
    return 'صناعة $name';
  }

  @override
  String minuteLabel(int minute) {
    return '$minute\'';
  }

  @override
  String get savesTitle => 'التصديات';

  @override
  String get tacklesTitle => 'الافتكاك';

  @override
  String get opponentOwnGoals => 'أهداف عكسية من الخصم';

  @override
  String get causedGoals => 'تسبّب بأهداف علينا';

  @override
  String get lateTitle => 'المتأخرين';

  @override
  String get excusedTitle => 'المعتذرين';

  @override
  String get unfairTitle => 'خسروا اللعب النظيف';

  @override
  String get valuesTitle => 'قيم الشركة';

  @override
  String get noteTitle => 'ملاحظة';

  @override
  String get playedTitle => 'اللي لعبوا';

  @override
  String get everyonePlayed => 'الكل لعب';

  @override
  String get leaderboards => 'المتصدرين';

  @override
  String get boardGoals => 'الأهداف';

  @override
  String get boardAssists => 'الصناعة';

  @override
  String get boardGa => 'أهداف + صناعة';

  @override
  String get boardSaves => 'التصديات';

  @override
  String get boardTackles => 'الافتكاك';

  @override
  String get boardAppearances => 'المشاركات';

  @override
  String get teamAverages => 'معدلات الفريق';

  @override
  String get goalsPerMatch => 'أهداف بالمباراة';

  @override
  String get concededPerMatch => 'استقبلنا بالمباراة';

  @override
  String get appsPerPlayer => 'مشاركات لكل لاعب';

  @override
  String get goalsChart => 'الأهداف بآخر ١٠ مباريات';

  @override
  String get us => 'إحنا';

  @override
  String get them => 'الخصم';

  @override
  String get awardOpen => 'لسا مفتوح';

  @override
  String get teamTitle => 'الفريق';

  @override
  String get winPct => 'نسبة الفوز';

  @override
  String get last5 => 'آخر ٥ مباريات';

  @override
  String get rulesTitle => 'القوانين';

  @override
  String get pointsTable => 'جدول النقاط';

  @override
  String get examples => 'أمثلة';

  @override
  String get walkExamples => 'كيف بتحرك التقييم';

  @override
  String get walkRating => 'التقييم';

  @override
  String get walkPoints => 'النقاط';

  @override
  String get walkStep => 'الخطوة';

  @override
  String get walkNewRating => 'الجديد';

  @override
  String get total => 'المجموع';

  @override
  String get liveTitle => 'المباراة المباشرة';

  @override
  String get noLiveMatch => 'ما في مباراة هلأ';

  @override
  String get clockNotStarted => 'قبل البداية';

  @override
  String get clockBreak => 'استراحة';

  @override
  String get eventsFeed => 'الأحداث';

  @override
  String get playerStatsLive => 'إحصائيات اللاعبين';

  @override
  String get eventGoal => 'هدف';

  @override
  String get eventOwnGoal => 'هدف عكسي من الخصم';

  @override
  String get eventAgainst => 'هدف علينا';

  @override
  String get eventSave => 'تصدي';

  @override
  String get eventTackle => 'افتكاك';

  @override
  String get moreTitle => 'المزيد';

  @override
  String get teamInfo => 'عن الفريق';

  @override
  String get adminLogin => 'دخول الإدارة';

  @override
  String get adminPanel => 'لوحة الإدارة';

  @override
  String get about => 'عن التطبيق';

  @override
  String get aboutText =>
      'تطبيق فريق WHEEL FC: التقييمات والمباريات والإحصائيات، ومكتب المباراة المباشرة للإدارة.';

  @override
  String get publicSite => 'الموقع العام';

  @override
  String get loginTitle => 'دخول الإدارة';

  @override
  String get tabEmail => 'إيميل';

  @override
  String get tabPin => 'رمز PIN';

  @override
  String get email => 'الإيميل';

  @override
  String get password => 'كلمة السر';

  @override
  String get login => 'دخول';

  @override
  String get pinHint => 'دخّل الرمز (٤–٦ أرقام)';

  @override
  String get pinClear => 'مسح';

  @override
  String get pinDelete => 'حذف رقم';

  @override
  String get requiredField => 'هاد الحقل مطلوب';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String adminHello(String name) {
    return 'أهلين $name';
  }

  @override
  String get liveDesk => 'مكتب المباراة المباشرة';

  @override
  String get finishedMatches => 'المباريات المنتهية';

  @override
  String get playersAdmin => 'اللاعبين';

  @override
  String get settings => 'الإعدادات';

  @override
  String get noPermissions => 'ما عندك صلاحيات إدارة';

  @override
  String get setupTitle => 'مباراة جديدة';

  @override
  String get opponent => 'الخصم';

  @override
  String get date => 'التاريخ';

  @override
  String get squad => 'التشكيلة';

  @override
  String get squadHint => 'اضغط على اللاعب: لعب ← معتذر ← مش مستدعى';

  @override
  String get statusPlayed => 'لعب';

  @override
  String get statusExcused => 'معتذر';

  @override
  String get statusNotCalled => 'مش مستدعى';

  @override
  String get minPlayed => 'لازم يلعب لاعبين ٢ على الأقل';

  @override
  String playedCount(int count) {
    return 'لعب: $count';
  }

  @override
  String get startMatch => 'ابدأ المباراة';

  @override
  String get resumePrompt => 'في مباراة شغالة — تكمل عليها؟';

  @override
  String get resume => 'كمّل عليها';

  @override
  String get discard => 'احذفها';

  @override
  String get discardConfirm => 'متأكد بدك تحذف المباراة المباشرة؟ ما بترجع.';

  @override
  String get discardMatch => 'حذف المباراة المباشرة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get clockStart => 'شغّل';

  @override
  String get clockPause => 'وقّف';

  @override
  String get goalForUs => 'هدف لنا';

  @override
  String get ownGoalOpponent => 'هدف عكسي من الخصم';

  @override
  String get goalAgainstUs => 'هدف علينا';

  @override
  String get whoAssisted => 'مين صنع؟';

  @override
  String get noAssist => 'بدون صناعة';

  @override
  String get whoScored => 'مين سجّل؟';

  @override
  String get whoCaused => 'مين تسبب؟';

  @override
  String get nobody => 'ولا حدا';

  @override
  String get makeMotm => 'نجم المباراة';

  @override
  String get removeMotm => 'شيل نجم المباراة';

  @override
  String get valuesPlus => 'قيم الشركة +';

  @override
  String get valuesMinus => 'قيم الشركة −';

  @override
  String get toggleUnfair => 'خسر اللعب النظيف';

  @override
  String get toggleLate => 'متأخر';

  @override
  String get addEmergency => 'لاعب طوارئ';

  @override
  String get noEmergencyPlayers => 'ما في لاعبين برا التشكيلة';

  @override
  String get eventLog => 'سجل الأحداث';

  @override
  String get undo => 'تراجع';

  @override
  String get undone => 'انشالت آخر حركة';

  @override
  String get redo => 'رجّعها';

  @override
  String get editEvent => 'تعديل الحدث';

  @override
  String get deleteEvent => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get syncSynced => 'متزامن';

  @override
  String get syncPending => 'عم يزامن';

  @override
  String get syncOffline => 'غير متصل';

  @override
  String get syncError => 'فشلت المزامنة';

  @override
  String get finishMatch => 'إنهاء المباراة';

  @override
  String get finishConfirm => 'متأكد بدك تنهي المباراة؟';

  @override
  String get pickMotm => 'اختار نجم المباراة';

  @override
  String get waitingSync => 'عم نستنى المزامنة…';

  @override
  String get syncFailedRetry =>
      'ما زبطت المزامنة، تأكد من النت وجرّب مرة ثانية';

  @override
  String get summaryTitle => 'ملخص المباراة';

  @override
  String get copy => 'نسخ';

  @override
  String get share => 'مشاركة';

  @override
  String get copied => 'انْسَخ';

  @override
  String get publish => 'نشر المباراة';

  @override
  String get publishConfirm => 'النشر رح يحدّث تقييمات كل اللاعبين. متأكد؟';

  @override
  String get published => 'انْشرت المباراة';

  @override
  String get minuteField => 'الدقيقة';

  @override
  String get scorer => 'اللاعب';

  @override
  String get assistField => 'الصانع';

  @override
  String get eventType => 'النوع';

  @override
  String get noMinute => 'بدون دقيقة';

  @override
  String get eventsLimit => 'وصلت للحد الأقصى من الأحداث';

  @override
  String get pendingCreate =>
      'المباراة محفوظة عالجهاز، رح تنبعت أول ما يرجع النت';

  @override
  String get editMatch => 'تعديل المباراة';

  @override
  String get deleteMatch => 'حذف المباراة';

  @override
  String get deleteMatchConfirm =>
      'متأكد بدك تحذف هاي المباراة؟ رح ينعاد حساب التقييمات.';

  @override
  String get whatsappSummary => 'نسخ ملخص واتساب';

  @override
  String get saved => 'انحفظ';

  @override
  String get deleted => 'انحذف';

  @override
  String get noteField => 'ملاحظة';

  @override
  String get newPlayer => 'لاعب جديد';

  @override
  String get editPlayer => 'تعديل لاعب';

  @override
  String get slugField => 'المعرّف (slug)';

  @override
  String get slugHint => 'حروف إنجليزية صغيرة، أرقام، - أو _';

  @override
  String get invalidSlug =>
      'المعرّف لازم يكون حروف إنجليزية صغيرة وأرقام و - _ بس';

  @override
  String get nameField => 'الاسم';

  @override
  String get nameEnField => 'الاسم بالإنجليزي';

  @override
  String get numberField => 'الرقم';

  @override
  String get invalidNumber => 'الرقم لازم يكون من ١ لـ ٩٩';

  @override
  String get roleField => 'الدور';

  @override
  String get isGoalkeeper => 'حارس مرمى';

  @override
  String get startTier => 'الفئة البدائية';

  @override
  String get isActive => 'فعّال';

  @override
  String get inactive => 'مش فعّال';

  @override
  String get uploadPhoto => 'رفع صورة';

  @override
  String get photoUploaded => 'انرفعت الصورة';

  @override
  String get deletePlayer => 'حذف اللاعب';

  @override
  String deletePlayerConfirm(String name) {
    return 'متأكد بدك تحذف $name؟';
  }

  @override
  String get reorderHint => 'اسحب اللاعب عشان تغيّر الترتيب';

  @override
  String get ratingConfig => 'إعدادات التقييم';

  @override
  String get pointsSection => 'النقاط';

  @override
  String get startSection => 'التقييم البدائي لكل فئة';

  @override
  String get boundsSection => 'حدود التقييم';

  @override
  String get bandsSection => 'حدود الفئات';

  @override
  String get moveSection => 'حركة التقييم';

  @override
  String get recomputeWarning => 'الحفظ رح يعيد حساب كل التقييمات';

  @override
  String get teamSettings => 'إعدادات الفريق';

  @override
  String get teamName => 'اسم الفريق';

  @override
  String get slogan => 'الشعار';

  @override
  String get publicSiteUrl => 'رابط الموقع العام';

  @override
  String get recompute => 'إعادة الحساب';

  @override
  String recomputeDone(int version) {
    return 'انعاد الحساب (النسخة $version)';
  }

  @override
  String get errBands => 'حد الفئة A لازم يكون أكبر من حد B';

  @override
  String get errBounds => 'الحد الأدنى لازم يكون أقل من الحد الأعلى';

  @override
  String get errBrakeBottom => 'brakeBottom لازم يكون أكبر من الحد الأدنى';

  @override
  String get errBrakeTop => 'brakeTop لازم يكون أقل من 100';

  @override
  String get invalidNumberField => 'رقم مش صحيح';

  @override
  String get ratingsTitle => 'النقاط والتقييم';

  @override
  String get alreadyPublished =>
      'هاي المباراة انْشرت قبل هيك، ما بنقدر نكمل عليها. رح تنحذف من الجهاز.';

  @override
  String get backup => 'نسخة احتياطية';

  @override
  String get pinAdminHint =>
      'الدخول بالرمز لمدير المباراة بس. الإعدادات بدها دخول بالإيميل.';
}
