import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your details to sign in.'**
  String get loginSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'OR CONTINUE WITH'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get loginSuccess;

  /// No description provided for @registerCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerCreateAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Begin your journey with a seamless and quiet experience.'**
  String get registerSubtitle;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameHint;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account Created!'**
  String get registerSuccess;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password are incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmptyFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get errorEmptyFields;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Serenity'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to find your center today?'**
  String get homeSubtitle;

  /// No description provided for @homeDailyReflection.
  ///
  /// In en, this message translates to:
  /// **'DAILY REFLECTION'**
  String get homeDailyReflection;

  /// No description provided for @homeQuote.
  ///
  /// In en, this message translates to:
  /// **'\"Quiet the mind, and the\\nsoul will speak.\"'**
  String get homeQuote;

  /// No description provided for @homeStartSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get homeStartSession;

  /// No description provided for @homePractices.
  ///
  /// In en, this message translates to:
  /// **'Practices'**
  String get homePractices;

  /// No description provided for @practiceMindfulness.
  ///
  /// In en, this message translates to:
  /// **'Mindfulness'**
  String get practiceMindfulness;

  /// No description provided for @practiceJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get practiceJournal;

  /// No description provided for @practiceSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get practiceSleep;

  /// No description provided for @practiceYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get practiceYoga;

  /// No description provided for @homeRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get homeRecentActivity;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// No description provided for @activityBreathwork.
  ///
  /// In en, this message translates to:
  /// **'10 min Breathwork'**
  String get activityBreathwork;

  /// No description provided for @activityMorningStretch.
  ///
  /// In en, this message translates to:
  /// **'Morning Stretch'**
  String get activityMorningStretch;

  /// No description provided for @activityTimeToday.
  ///
  /// In en, this message translates to:
  /// **'Today, 7:30 AM'**
  String get activityTimeToday;

  /// No description provided for @activityTimeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, 8:00 AM'**
  String get activityTimeYesterday;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navReflect.
  ///
  /// In en, this message translates to:
  /// **'Reflect'**
  String get navReflect;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @fakeGpsTitle.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get fakeGpsTitle;

  /// No description provided for @fakeGpsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our security systems have detected the use of a Fake GPS or mock location app on your device.'**
  String get fakeGpsSubtitle;

  /// No description provided for @fakeGpsWarning.
  ///
  /// In en, this message translates to:
  /// **'To protect the integrity of our application, you cannot continue using it while location spoofing is active.'**
  String get fakeGpsWarning;

  /// No description provided for @fakeGpsButton.
  ///
  /// In en, this message translates to:
  /// **'Close Application'**
  String get fakeGpsButton;

  /// No description provided for @usbDebuggingTitle.
  ///
  /// In en, this message translates to:
  /// **'Insecure Environment'**
  String get usbDebuggingTitle;

  /// No description provided for @usbDebuggingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'USB Debugging has been detected as active on this device.'**
  String get usbDebuggingSubtitle;

  /// No description provided for @usbDebuggingWarning.
  ///
  /// In en, this message translates to:
  /// **'Due to security policies, this application cannot run in an environment with debugging enabled. Please disable this option in your system settings.'**
  String get usbDebuggingWarning;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
