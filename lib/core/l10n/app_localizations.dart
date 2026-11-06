import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'WHEEL FC'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navStandings.
  ///
  /// In ar, this message translates to:
  /// **'الترتيب'**
  String get navStandings;

  /// No description provided for @navMatches.
  ///
  /// In ar, this message translates to:
  /// **'المباريات'**
  String get navMatches;

  /// No description provided for @navStats.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get navStats;

  /// No description provided for @navMore.
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get navMore;

  /// No description provided for @lastUpdated.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث: {date}'**
  String lastUpdated(String date);

  /// No description provided for @offlineBanner.
  ///
  /// In ar, this message translates to:
  /// **'غير متصل — آخر بيانات محفوظة'**
  String get offlineBanner;

  /// No description provided for @liveNow.
  ///
  /// In ar, this message translates to:
  /// **'مباشر هلأ'**
  String get liveNow;

  /// No description provided for @liveVs.
  ///
  /// In ar, this message translates to:
  /// **'WHEEL FC ضد {opponent}'**
  String liveVs(String opponent);

  /// No description provided for @tapToWatch.
  ///
  /// In ar, this message translates to:
  /// **'اضغط عشان تتابع'**
  String get tapToWatch;

  /// No description provided for @teamRecord.
  ///
  /// In ar, this message translates to:
  /// **'سجل الفريق'**
  String get teamRecord;

  /// No description provided for @awards.
  ///
  /// In ar, this message translates to:
  /// **'الجوائز'**
  String get awards;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'جرّب مرة ثانية'**
  String get retry;

  /// No description provided for @emptyList.
  ///
  /// In ar, this message translates to:
  /// **'ما في إشي لهلأ'**
  String get emptyList;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'عم نحمّل…'**
  String get loading;

  /// No description provided for @errorNetwork.
  ///
  /// In ar, this message translates to:
  /// **'ما في اتصال بالإنترنت'**
  String get errorNetwork;

  /// No description provided for @errorUnauthorized.
  ///
  /// In ar, this message translates to:
  /// **'لازم تسجّل دخول من جديد'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In ar, this message translates to:
  /// **'ما عندك صلاحية لهاد الإشي'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In ar, this message translates to:
  /// **'مش موجود'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In ar, this message translates to:
  /// **'في تعارض مع بيانات موجودة'**
  String get errorConflict;

  /// No description provided for @errorValidation.
  ///
  /// In ar, this message translates to:
  /// **'في بيانات مش صحيحة'**
  String get errorValidation;

  /// No description provided for @errorRateLimit.
  ///
  /// In ar, this message translates to:
  /// **'كثير محاولات، استنى دقيقة'**
  String get errorRateLimit;

  /// No description provided for @errorServer.
  ///
  /// In ar, this message translates to:
  /// **'صار خطأ بالسيرفر، جرّب بعدين'**
  String get errorServer;

  /// No description provided for @errorParsing.
  ///
  /// In ar, this message translates to:
  /// **'وصلت بيانات مش مفهومة من السيرفر'**
  String get errorParsing;

  /// No description provided for @errorCache.
  ///
  /// In ar, this message translates to:
  /// **'ما في بيانات محفوظة، اتصل بالإنترنت'**
  String get errorCache;

  /// No description provided for @resultWin.
  ///
  /// In ar, this message translates to:
  /// **'فوز'**
  String get resultWin;

  /// No description provided for @resultDraw.
  ///
  /// In ar, this message translates to:
  /// **'تعادل'**
  String get resultDraw;

  /// No description provided for @resultLoss.
  ///
  /// In ar, this message translates to:
  /// **'خسارة'**
  String get resultLoss;

  /// No description provided for @recordWins.
  ///
  /// In ar, this message translates to:
  /// **'فوز'**
  String get recordWins;

  /// No description provided for @recordDraws.
  ///
  /// In ar, this message translates to:
  /// **'تعادل'**
  String get recordDraws;

  /// No description provided for @recordLosses.
  ///
  /// In ar, this message translates to:
  /// **'خسارة'**
  String get recordLosses;

  /// No description provided for @recordGoalsFor.
  ///
  /// In ar, this message translates to:
  /// **'سجّلنا'**
  String get recordGoalsFor;

  /// No description provided for @recordGoalsAgainst.
  ///
  /// In ar, this message translates to:
  /// **'استقبلنا'**
  String get recordGoalsAgainst;

  /// No description provided for @recordCleanSheets.
  ///
  /// In ar, this message translates to:
  /// **'شباك نظيفة'**
  String get recordCleanSheets;

  /// No description provided for @movedUp.
  ///
  /// In ar, this message translates to:
  /// **'صعد'**
  String get movedUp;

  /// No description provided for @movedDown.
  ///
  /// In ar, this message translates to:
  /// **'نزل'**
  String get movedDown;

  /// No description provided for @rankLabel.
  ///
  /// In ar, this message translates to:
  /// **'#{rank}'**
  String rankLabel(int rank);

  /// No description provided for @shirtNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم {number}'**
  String shirtNumber(int number);

  /// No description provided for @goalkeeper.
  ///
  /// In ar, this message translates to:
  /// **'حارس'**
  String get goalkeeper;

  /// No description provided for @viewCards.
  ///
  /// In ar, this message translates to:
  /// **'بطاقات'**
  String get viewCards;

  /// No description provided for @viewTable.
  ///
  /// In ar, this message translates to:
  /// **'جدول'**
  String get viewTable;

  /// No description provided for @sortRating.
  ///
  /// In ar, this message translates to:
  /// **'التقييم'**
  String get sortRating;

  /// No description provided for @sortGoals.
  ///
  /// In ar, this message translates to:
  /// **'الأهداف'**
  String get sortGoals;

  /// No description provided for @sortAssists.
  ///
  /// In ar, this message translates to:
  /// **'الصناعة'**
  String get sortAssists;

  /// No description provided for @sortMatches.
  ///
  /// In ar, this message translates to:
  /// **'المباريات'**
  String get sortMatches;

  /// No description provided for @playerColumn.
  ///
  /// In ar, this message translates to:
  /// **'اللاعب'**
  String get playerColumn;

  /// No description provided for @statMatches.
  ///
  /// In ar, this message translates to:
  /// **'مباريات'**
  String get statMatches;

  /// No description provided for @statGoals.
  ///
  /// In ar, this message translates to:
  /// **'أهداف'**
  String get statGoals;

  /// No description provided for @statAssists.
  ///
  /// In ar, this message translates to:
  /// **'صناعة'**
  String get statAssists;

  /// No description provided for @statSaves.
  ///
  /// In ar, this message translates to:
  /// **'تصديات'**
  String get statSaves;

  /// No description provided for @statTackles.
  ///
  /// In ar, this message translates to:
  /// **'افتكاك'**
  String get statTackles;

  /// No description provided for @statWins.
  ///
  /// In ar, this message translates to:
  /// **'فوز'**
  String get statWins;

  /// No description provided for @statDraws.
  ///
  /// In ar, this message translates to:
  /// **'تعادل'**
  String get statDraws;

  /// No description provided for @statLosses.
  ///
  /// In ar, this message translates to:
  /// **'خسارة'**
  String get statLosses;

  /// No description provided for @statMotm.
  ///
  /// In ar, this message translates to:
  /// **'نجم المباراة'**
  String get statMotm;

  /// No description provided for @statCleanSheets.
  ///
  /// In ar, this message translates to:
  /// **'شباك نظيفة'**
  String get statCleanSheets;

  /// No description provided for @statFairPlay.
  ///
  /// In ar, this message translates to:
  /// **'لعب نظيف'**
  String get statFairPlay;

  /// No description provided for @statValues.
  ///
  /// In ar, this message translates to:
  /// **'قيم الشركة'**
  String get statValues;

  /// No description provided for @statExcused.
  ///
  /// In ar, this message translates to:
  /// **'اعتذار'**
  String get statExcused;

  /// No description provided for @statLate.
  ///
  /// In ar, this message translates to:
  /// **'تأخير'**
  String get statLate;

  /// No description provided for @statCaused.
  ///
  /// In ar, this message translates to:
  /// **'تسبّب بهدف'**
  String get statCaused;

  /// No description provided for @rating.
  ///
  /// In ar, this message translates to:
  /// **'التقييم'**
  String get rating;

  /// No description provided for @ratingExact.
  ///
  /// In ar, this message translates to:
  /// **'التقييم الدقيق: {value}'**
  String ratingExact(String value);

  /// No description provided for @ratingChart.
  ///
  /// In ar, this message translates to:
  /// **'تطور التقييم'**
  String get ratingChart;

  /// No description provided for @insights.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get insights;

  /// No description provided for @nextTarget.
  ///
  /// In ar, this message translates to:
  /// **'المطلوب بالمباراة الجاية'**
  String get nextTarget;

  /// No description provided for @pointsValue.
  ///
  /// In ar, this message translates to:
  /// **'{points} نقطة'**
  String pointsValue(String points);

  /// No description provided for @gapToNextTier.
  ///
  /// In ar, this message translates to:
  /// **'باقي {gap} للفئة اللي فوق'**
  String gapToNextTier(String gap);

  /// No description provided for @matchLog.
  ///
  /// In ar, this message translates to:
  /// **'سجل المباريات'**
  String get matchLog;

  /// No description provided for @excusedRow.
  ///
  /// In ar, this message translates to:
  /// **'اعتذر عن المباراة'**
  String get excusedRow;

  /// No description provided for @lateRow.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get lateRow;

  /// No description provided for @deltaLabel.
  ///
  /// In ar, this message translates to:
  /// **'التغيير'**
  String get deltaLabel;

  /// No description provided for @matchesTitle.
  ///
  /// In ar, this message translates to:
  /// **'المباريات'**
  String get matchesTitle;

  /// No description provided for @matchDetail.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المباراة'**
  String get matchDetail;

  /// No description provided for @motm.
  ///
  /// In ar, this message translates to:
  /// **'نجم المباراة'**
  String get motm;

  /// No description provided for @scorers.
  ///
  /// In ar, this message translates to:
  /// **'الأهداف'**
  String get scorers;

  /// No description provided for @assistBy.
  ///
  /// In ar, this message translates to:
  /// **'صناعة {name}'**
  String assistBy(String name);

  /// No description provided for @minuteLabel.
  ///
  /// In ar, this message translates to:
  /// **'{minute}\''**
  String minuteLabel(int minute);

  /// No description provided for @savesTitle.
  ///
  /// In ar, this message translates to:
  /// **'التصديات'**
  String get savesTitle;

  /// No description provided for @tacklesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الافتكاك'**
  String get tacklesTitle;

  /// No description provided for @opponentOwnGoals.
  ///
  /// In ar, this message translates to:
  /// **'أهداف عكسية من الخصم'**
  String get opponentOwnGoals;

  /// No description provided for @causedGoals.
  ///
  /// In ar, this message translates to:
  /// **'تسبّب بأهداف علينا'**
  String get causedGoals;

  /// No description provided for @lateTitle.
  ///
  /// In ar, this message translates to:
  /// **'المتأخرين'**
  String get lateTitle;

  /// No description provided for @excusedTitle.
  ///
  /// In ar, this message translates to:
  /// **'المعتذرين'**
  String get excusedTitle;

  /// No description provided for @unfairTitle.
  ///
  /// In ar, this message translates to:
  /// **'خسروا اللعب النظيف'**
  String get unfairTitle;

  /// No description provided for @valuesTitle.
  ///
  /// In ar, this message translates to:
  /// **'قيم الشركة'**
  String get valuesTitle;

  /// No description provided for @noteTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة'**
  String get noteTitle;

  /// No description provided for @playedTitle.
  ///
  /// In ar, this message translates to:
  /// **'اللي لعبوا'**
  String get playedTitle;

  /// No description provided for @everyonePlayed.
  ///
  /// In ar, this message translates to:
  /// **'الكل لعب'**
  String get everyonePlayed;

  /// No description provided for @leaderboards.
  ///
  /// In ar, this message translates to:
  /// **'المتصدرين'**
  String get leaderboards;

  /// No description provided for @boardGoals.
  ///
  /// In ar, this message translates to:
  /// **'الأهداف'**
  String get boardGoals;

  /// No description provided for @boardAssists.
  ///
  /// In ar, this message translates to:
  /// **'الصناعة'**
  String get boardAssists;

  /// No description provided for @boardGa.
  ///
  /// In ar, this message translates to:
  /// **'أهداف + صناعة'**
  String get boardGa;

  /// No description provided for @boardSaves.
  ///
  /// In ar, this message translates to:
  /// **'التصديات'**
  String get boardSaves;

  /// No description provided for @boardTackles.
  ///
  /// In ar, this message translates to:
  /// **'الافتكاك'**
  String get boardTackles;

  /// No description provided for @boardAppearances.
  ///
  /// In ar, this message translates to:
  /// **'المشاركات'**
  String get boardAppearances;

  /// No description provided for @teamAverages.
  ///
  /// In ar, this message translates to:
  /// **'معدلات الفريق'**
  String get teamAverages;

  /// No description provided for @goalsPerMatch.
  ///
  /// In ar, this message translates to:
  /// **'أهداف بالمباراة'**
  String get goalsPerMatch;

  /// No description provided for @concededPerMatch.
  ///
  /// In ar, this message translates to:
  /// **'استقبلنا بالمباراة'**
  String get concededPerMatch;

  /// No description provided for @appsPerPlayer.
  ///
  /// In ar, this message translates to:
  /// **'مشاركات لكل لاعب'**
  String get appsPerPlayer;

  /// No description provided for @goalsChart.
  ///
  /// In ar, this message translates to:
  /// **'الأهداف بآخر ١٠ مباريات'**
  String get goalsChart;

  /// No description provided for @us.
  ///
  /// In ar, this message translates to:
  /// **'إحنا'**
  String get us;

  /// No description provided for @them.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get them;

  /// No description provided for @awardOpen.
  ///
  /// In ar, this message translates to:
  /// **'لسا مفتوح'**
  String get awardOpen;

  /// No description provided for @teamTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفريق'**
  String get teamTitle;

  /// No description provided for @winPct.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الفوز'**
  String get winPct;

  /// No description provided for @last5.
  ///
  /// In ar, this message translates to:
  /// **'آخر ٥ مباريات'**
  String get last5;

  /// No description provided for @rulesTitle.
  ///
  /// In ar, this message translates to:
  /// **'القوانين'**
  String get rulesTitle;

  /// No description provided for @pointsTable.
  ///
  /// In ar, this message translates to:
  /// **'جدول النقاط'**
  String get pointsTable;

  /// No description provided for @examples.
  ///
  /// In ar, this message translates to:
  /// **'أمثلة'**
  String get examples;

  /// No description provided for @walkExamples.
  ///
  /// In ar, this message translates to:
  /// **'كيف بتحرك التقييم'**
  String get walkExamples;

  /// No description provided for @walkRating.
  ///
  /// In ar, this message translates to:
  /// **'التقييم'**
  String get walkRating;

  /// No description provided for @walkPoints.
  ///
  /// In ar, this message translates to:
  /// **'النقاط'**
  String get walkPoints;

  /// No description provided for @walkStep.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة'**
  String get walkStep;

  /// No description provided for @walkNewRating.
  ///
  /// In ar, this message translates to:
  /// **'الجديد'**
  String get walkNewRating;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get total;

  /// No description provided for @liveTitle.
  ///
  /// In ar, this message translates to:
  /// **'المباراة المباشرة'**
  String get liveTitle;

  /// No description provided for @noLiveMatch.
  ///
  /// In ar, this message translates to:
  /// **'ما في مباراة هلأ'**
  String get noLiveMatch;

  /// No description provided for @clockNotStarted.
  ///
  /// In ar, this message translates to:
  /// **'قبل البداية'**
  String get clockNotStarted;

  /// No description provided for @clockBreak.
  ///
  /// In ar, this message translates to:
  /// **'استراحة'**
  String get clockBreak;

  /// No description provided for @eventsFeed.
  ///
  /// In ar, this message translates to:
  /// **'الأحداث'**
  String get eventsFeed;

  /// No description provided for @playerStatsLive.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات اللاعبين'**
  String get playerStatsLive;

  /// No description provided for @eventGoal.
  ///
  /// In ar, this message translates to:
  /// **'هدف'**
  String get eventGoal;

  /// No description provided for @eventOwnGoal.
  ///
  /// In ar, this message translates to:
  /// **'هدف عكسي من الخصم'**
  String get eventOwnGoal;

  /// No description provided for @eventAgainst.
  ///
  /// In ar, this message translates to:
  /// **'هدف علينا'**
  String get eventAgainst;

  /// No description provided for @eventSave.
  ///
  /// In ar, this message translates to:
  /// **'تصدي'**
  String get eventSave;

  /// No description provided for @eventTackle.
  ///
  /// In ar, this message translates to:
  /// **'افتكاك'**
  String get eventTackle;

  /// No description provided for @moreTitle.
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get moreTitle;

  /// No description provided for @teamInfo.
  ///
  /// In ar, this message translates to:
  /// **'عن الفريق'**
  String get teamInfo;

  /// No description provided for @adminLogin.
  ///
  /// In ar, this message translates to:
  /// **'دخول الإدارة'**
  String get adminLogin;

  /// No description provided for @adminPanel.
  ///
  /// In ar, this message translates to:
  /// **'لوحة الإدارة'**
  String get adminPanel;

  /// No description provided for @about.
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get about;

  /// No description provided for @aboutText.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق فريق WHEEL FC: التقييمات والمباريات والإحصائيات، ومكتب المباراة المباشرة للإدارة.'**
  String get aboutText;

  /// No description provided for @publicSite.
  ///
  /// In ar, this message translates to:
  /// **'الموقع العام'**
  String get publicSite;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'دخول الإدارة'**
  String get loginTitle;

  /// No description provided for @tabEmail.
  ///
  /// In ar, this message translates to:
  /// **'إيميل'**
  String get tabEmail;

  /// No description provided for @tabPin.
  ///
  /// In ar, this message translates to:
  /// **'رمز PIN'**
  String get tabPin;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'الإيميل'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر'**
  String get password;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get login;

  /// No description provided for @pinHint.
  ///
  /// In ar, this message translates to:
  /// **'دخّل الرمز (٤–٦ أرقام)'**
  String get pinHint;

  /// No description provided for @pinClear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get pinClear;

  /// No description provided for @pinDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف رقم'**
  String get pinDelete;

  /// No description provided for @requiredField.
  ///
  /// In ar, this message translates to:
  /// **'هاد الحقل مطلوب'**
  String get requiredField;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل خروج'**
  String get logout;

  /// No description provided for @adminHello.
  ///
  /// In ar, this message translates to:
  /// **'أهلين {name}'**
  String adminHello(String name);

  /// No description provided for @liveDesk.
  ///
  /// In ar, this message translates to:
  /// **'مكتب المباراة المباشرة'**
  String get liveDesk;

  /// No description provided for @finishedMatches.
  ///
  /// In ar, this message translates to:
  /// **'المباريات المنتهية'**
  String get finishedMatches;

  /// No description provided for @playersAdmin.
  ///
  /// In ar, this message translates to:
  /// **'اللاعبين'**
  String get playersAdmin;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @noPermissions.
  ///
  /// In ar, this message translates to:
  /// **'ما عندك صلاحيات إدارة'**
  String get noPermissions;

  /// No description provided for @setupTitle.
  ///
  /// In ar, this message translates to:
  /// **'مباراة جديدة'**
  String get setupTitle;

  /// No description provided for @opponent.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get opponent;

  /// No description provided for @date.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get date;

  /// No description provided for @squad.
  ///
  /// In ar, this message translates to:
  /// **'التشكيلة'**
  String get squad;

  /// No description provided for @squadHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على اللاعب: لعب ← معتذر ← مش مستدعى'**
  String get squadHint;

  /// No description provided for @statusPlayed.
  ///
  /// In ar, this message translates to:
  /// **'لعب'**
  String get statusPlayed;

  /// No description provided for @statusExcused.
  ///
  /// In ar, this message translates to:
  /// **'معتذر'**
  String get statusExcused;

  /// No description provided for @statusNotCalled.
  ///
  /// In ar, this message translates to:
  /// **'مش مستدعى'**
  String get statusNotCalled;

  /// No description provided for @minPlayed.
  ///
  /// In ar, this message translates to:
  /// **'لازم يلعب لاعبين ٢ على الأقل'**
  String get minPlayed;

  /// No description provided for @playedCount.
  ///
  /// In ar, this message translates to:
  /// **'لعب: {count}'**
  String playedCount(int count);

  /// No description provided for @startMatch.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ المباراة'**
  String get startMatch;

  /// No description provided for @resumePrompt.
  ///
  /// In ar, this message translates to:
  /// **'في مباراة شغالة — تكمل عليها؟'**
  String get resumePrompt;

  /// No description provided for @resume.
  ///
  /// In ar, this message translates to:
  /// **'كمّل عليها'**
  String get resume;

  /// No description provided for @discard.
  ///
  /// In ar, this message translates to:
  /// **'احذفها'**
  String get discard;

  /// No description provided for @discardConfirm.
  ///
  /// In ar, this message translates to:
  /// **'متأكد بدك تحذف المباراة المباشرة؟ ما بترجع.'**
  String get discardConfirm;

  /// No description provided for @discardMatch.
  ///
  /// In ar, this message translates to:
  /// **'حذف المباراة المباشرة'**
  String get discardMatch;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @clockStart.
  ///
  /// In ar, this message translates to:
  /// **'شغّل'**
  String get clockStart;

  /// No description provided for @clockPause.
  ///
  /// In ar, this message translates to:
  /// **'وقّف'**
  String get clockPause;

  /// No description provided for @goalForUs.
  ///
  /// In ar, this message translates to:
  /// **'هدف لنا'**
  String get goalForUs;

  /// No description provided for @ownGoalOpponent.
  ///
  /// In ar, this message translates to:
  /// **'هدف عكسي من الخصم'**
  String get ownGoalOpponent;

  /// No description provided for @goalAgainstUs.
  ///
  /// In ar, this message translates to:
  /// **'هدف علينا'**
  String get goalAgainstUs;

  /// No description provided for @whoAssisted.
  ///
  /// In ar, this message translates to:
  /// **'مين صنع؟'**
  String get whoAssisted;

  /// No description provided for @noAssist.
  ///
  /// In ar, this message translates to:
  /// **'بدون صناعة'**
  String get noAssist;

  /// No description provided for @whoScored.
  ///
  /// In ar, this message translates to:
  /// **'مين سجّل؟'**
  String get whoScored;

  /// No description provided for @whoCaused.
  ///
  /// In ar, this message translates to:
  /// **'مين تسبب؟'**
  String get whoCaused;

  /// No description provided for @nobody.
  ///
  /// In ar, this message translates to:
  /// **'ولا حدا'**
  String get nobody;

  /// No description provided for @makeMotm.
  ///
  /// In ar, this message translates to:
  /// **'نجم المباراة'**
  String get makeMotm;

  /// No description provided for @removeMotm.
  ///
  /// In ar, this message translates to:
  /// **'شيل نجم المباراة'**
  String get removeMotm;

  /// No description provided for @valuesPlus.
  ///
  /// In ar, this message translates to:
  /// **'قيم الشركة +'**
  String get valuesPlus;

  /// No description provided for @valuesMinus.
  ///
  /// In ar, this message translates to:
  /// **'قيم الشركة −'**
  String get valuesMinus;

  /// No description provided for @toggleUnfair.
  ///
  /// In ar, this message translates to:
  /// **'خسر اللعب النظيف'**
  String get toggleUnfair;

  /// No description provided for @toggleLate.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get toggleLate;

  /// No description provided for @addEmergency.
  ///
  /// In ar, this message translates to:
  /// **'لاعب طوارئ'**
  String get addEmergency;

  /// No description provided for @noEmergencyPlayers.
  ///
  /// In ar, this message translates to:
  /// **'ما في لاعبين برا التشكيلة'**
  String get noEmergencyPlayers;

  /// No description provided for @eventLog.
  ///
  /// In ar, this message translates to:
  /// **'سجل الأحداث'**
  String get eventLog;

  /// No description provided for @undo.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get undo;

  /// No description provided for @undone.
  ///
  /// In ar, this message translates to:
  /// **'انشالت آخر حركة'**
  String get undone;

  /// No description provided for @redo.
  ///
  /// In ar, this message translates to:
  /// **'رجّعها'**
  String get redo;

  /// No description provided for @editEvent.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الحدث'**
  String get editEvent;

  /// No description provided for @deleteEvent.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get deleteEvent;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @syncSynced.
  ///
  /// In ar, this message translates to:
  /// **'متزامن'**
  String get syncSynced;

  /// No description provided for @syncPending.
  ///
  /// In ar, this message translates to:
  /// **'عم يزامن'**
  String get syncPending;

  /// No description provided for @syncOffline.
  ///
  /// In ar, this message translates to:
  /// **'غير متصل'**
  String get syncOffline;

  /// No description provided for @syncError.
  ///
  /// In ar, this message translates to:
  /// **'فشلت المزامنة'**
  String get syncError;

  /// No description provided for @finishMatch.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء المباراة'**
  String get finishMatch;

  /// No description provided for @finishConfirm.
  ///
  /// In ar, this message translates to:
  /// **'متأكد بدك تنهي المباراة؟'**
  String get finishConfirm;

  /// No description provided for @pickMotm.
  ///
  /// In ar, this message translates to:
  /// **'اختار نجم المباراة'**
  String get pickMotm;

  /// No description provided for @waitingSync.
  ///
  /// In ar, this message translates to:
  /// **'عم نستنى المزامنة…'**
  String get waitingSync;

  /// No description provided for @syncFailedRetry.
  ///
  /// In ar, this message translates to:
  /// **'ما زبطت المزامنة، تأكد من النت وجرّب مرة ثانية'**
  String get syncFailedRetry;

  /// No description provided for @summaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص المباراة'**
  String get summaryTitle;

  /// No description provided for @copy.
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @copied.
  ///
  /// In ar, this message translates to:
  /// **'انْسَخ'**
  String get copied;

  /// No description provided for @publish.
  ///
  /// In ar, this message translates to:
  /// **'نشر المباراة'**
  String get publish;

  /// No description provided for @publishConfirm.
  ///
  /// In ar, this message translates to:
  /// **'النشر رح يحدّث تقييمات كل اللاعبين. متأكد؟'**
  String get publishConfirm;

  /// No description provided for @published.
  ///
  /// In ar, this message translates to:
  /// **'انْشرت المباراة'**
  String get published;

  /// No description provided for @minuteField.
  ///
  /// In ar, this message translates to:
  /// **'الدقيقة'**
  String get minuteField;

  /// No description provided for @scorer.
  ///
  /// In ar, this message translates to:
  /// **'اللاعب'**
  String get scorer;

  /// No description provided for @assistField.
  ///
  /// In ar, this message translates to:
  /// **'الصانع'**
  String get assistField;

  /// No description provided for @eventType.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get eventType;

  /// No description provided for @noMinute.
  ///
  /// In ar, this message translates to:
  /// **'بدون دقيقة'**
  String get noMinute;

  /// No description provided for @eventsLimit.
  ///
  /// In ar, this message translates to:
  /// **'وصلت للحد الأقصى من الأحداث'**
  String get eventsLimit;

  /// No description provided for @pendingCreate.
  ///
  /// In ar, this message translates to:
  /// **'المباراة محفوظة عالجهاز، رح تنبعت أول ما يرجع النت'**
  String get pendingCreate;

  /// No description provided for @editMatch.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المباراة'**
  String get editMatch;

  /// No description provided for @deleteMatch.
  ///
  /// In ar, this message translates to:
  /// **'حذف المباراة'**
  String get deleteMatch;

  /// No description provided for @deleteMatchConfirm.
  ///
  /// In ar, this message translates to:
  /// **'متأكد بدك تحذف هاي المباراة؟ رح ينعاد حساب التقييمات.'**
  String get deleteMatchConfirm;

  /// No description provided for @whatsappSummary.
  ///
  /// In ar, this message translates to:
  /// **'نسخ ملخص واتساب'**
  String get whatsappSummary;

  /// No description provided for @saved.
  ///
  /// In ar, this message translates to:
  /// **'انحفظ'**
  String get saved;

  /// No description provided for @deleted.
  ///
  /// In ar, this message translates to:
  /// **'انحذف'**
  String get deleted;

  /// No description provided for @noteField.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة'**
  String get noteField;

  /// No description provided for @newPlayer.
  ///
  /// In ar, this message translates to:
  /// **'لاعب جديد'**
  String get newPlayer;

  /// No description provided for @editPlayer.
  ///
  /// In ar, this message translates to:
  /// **'تعديل لاعب'**
  String get editPlayer;

  /// No description provided for @slugField.
  ///
  /// In ar, this message translates to:
  /// **'المعرّف (slug)'**
  String get slugField;

  /// No description provided for @slugHint.
  ///
  /// In ar, this message translates to:
  /// **'حروف إنجليزية صغيرة، أرقام، - أو _'**
  String get slugHint;

  /// No description provided for @invalidSlug.
  ///
  /// In ar, this message translates to:
  /// **'المعرّف لازم يكون حروف إنجليزية صغيرة وأرقام و - _ بس'**
  String get invalidSlug;

  /// No description provided for @nameField.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get nameField;

  /// No description provided for @nameEnField.
  ///
  /// In ar, this message translates to:
  /// **'الاسم بالإنجليزي'**
  String get nameEnField;

  /// No description provided for @numberField.
  ///
  /// In ar, this message translates to:
  /// **'الرقم'**
  String get numberField;

  /// No description provided for @invalidNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرقم لازم يكون من ١ لـ ٩٩'**
  String get invalidNumber;

  /// No description provided for @roleField.
  ///
  /// In ar, this message translates to:
  /// **'الدور'**
  String get roleField;

  /// No description provided for @isGoalkeeper.
  ///
  /// In ar, this message translates to:
  /// **'حارس مرمى'**
  String get isGoalkeeper;

  /// No description provided for @startTier.
  ///
  /// In ar, this message translates to:
  /// **'الفئة البدائية'**
  String get startTier;

  /// No description provided for @isActive.
  ///
  /// In ar, this message translates to:
  /// **'فعّال'**
  String get isActive;

  /// No description provided for @inactive.
  ///
  /// In ar, this message translates to:
  /// **'مش فعّال'**
  String get inactive;

  /// No description provided for @uploadPhoto.
  ///
  /// In ar, this message translates to:
  /// **'رفع صورة'**
  String get uploadPhoto;

  /// No description provided for @photoUploaded.
  ///
  /// In ar, this message translates to:
  /// **'انرفعت الصورة'**
  String get photoUploaded;

  /// No description provided for @deletePlayer.
  ///
  /// In ar, this message translates to:
  /// **'حذف اللاعب'**
  String get deletePlayer;

  /// No description provided for @deletePlayerConfirm.
  ///
  /// In ar, this message translates to:
  /// **'متأكد بدك تحذف {name}؟'**
  String deletePlayerConfirm(String name);

  /// No description provided for @reorderHint.
  ///
  /// In ar, this message translates to:
  /// **'اسحب اللاعب عشان تغيّر الترتيب'**
  String get reorderHint;

  /// No description provided for @ratingConfig.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات التقييم'**
  String get ratingConfig;

  /// No description provided for @pointsSection.
  ///
  /// In ar, this message translates to:
  /// **'النقاط'**
  String get pointsSection;

  /// No description provided for @startSection.
  ///
  /// In ar, this message translates to:
  /// **'التقييم البدائي لكل فئة'**
  String get startSection;

  /// No description provided for @boundsSection.
  ///
  /// In ar, this message translates to:
  /// **'حدود التقييم'**
  String get boundsSection;

  /// No description provided for @bandsSection.
  ///
  /// In ar, this message translates to:
  /// **'حدود الفئات'**
  String get bandsSection;

  /// No description provided for @moveSection.
  ///
  /// In ar, this message translates to:
  /// **'حركة التقييم'**
  String get moveSection;

  /// No description provided for @recomputeWarning.
  ///
  /// In ar, this message translates to:
  /// **'الحفظ رح يعيد حساب كل التقييمات'**
  String get recomputeWarning;

  /// No description provided for @teamSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الفريق'**
  String get teamSettings;

  /// No description provided for @teamName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الفريق'**
  String get teamName;

  /// No description provided for @slogan.
  ///
  /// In ar, this message translates to:
  /// **'الشعار'**
  String get slogan;

  /// No description provided for @publicSiteUrl.
  ///
  /// In ar, this message translates to:
  /// **'رابط الموقع العام'**
  String get publicSiteUrl;

  /// No description provided for @recompute.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الحساب'**
  String get recompute;

  /// No description provided for @recomputeDone.
  ///
  /// In ar, this message translates to:
  /// **'انعاد الحساب (النسخة {version})'**
  String recomputeDone(int version);

  /// No description provided for @errBands.
  ///
  /// In ar, this message translates to:
  /// **'حد الفئة A لازم يكون أكبر من حد B'**
  String get errBands;

  /// No description provided for @errBounds.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى لازم يكون أقل من الحد الأعلى'**
  String get errBounds;

  /// No description provided for @errBrakeBottom.
  ///
  /// In ar, this message translates to:
  /// **'brakeBottom لازم يكون أكبر من الحد الأدنى'**
  String get errBrakeBottom;

  /// No description provided for @errBrakeTop.
  ///
  /// In ar, this message translates to:
  /// **'brakeTop لازم يكون أقل من 100'**
  String get errBrakeTop;

  /// No description provided for @invalidNumberField.
  ///
  /// In ar, this message translates to:
  /// **'رقم مش صحيح'**
  String get invalidNumberField;

  /// No description provided for @ratingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'النقاط والتقييم'**
  String get ratingsTitle;

  /// No description provided for @alreadyPublished.
  ///
  /// In ar, this message translates to:
  /// **'هاي المباراة انْشرت قبل هيك، ما بنقدر نكمل عليها. رح تنحذف من الجهاز.'**
  String get alreadyPublished;

  /// No description provided for @backup.
  ///
  /// In ar, this message translates to:
  /// **'نسخة احتياطية'**
  String get backup;

  /// No description provided for @pinAdminHint.
  ///
  /// In ar, this message translates to:
  /// **'الدخول بالرمز لمدير المباراة بس. الإعدادات بدها دخول بالإيميل.'**
  String get pinAdminHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
