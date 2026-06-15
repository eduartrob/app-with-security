// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginWelcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Please enter your details to sign in.';

  @override
  String get emailHint => 'Email Address';

  @override
  String get passwordHint => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get orContinueWith => 'OR CONTINUE WITH';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get loginSuccess => 'Welcome!';

  @override
  String get registerCreateAccount => 'Create Account';

  @override
  String get registerSubtitle =>
      'Begin your journey with a seamless and quiet experience.';

  @override
  String get fullNameHint => 'Full Name';

  @override
  String get registerSuccess => 'Account Created!';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get logIn => 'Log in';

  @override
  String get errorInvalidCredentials => 'Email or password are incorrect.';

  @override
  String get errorEmptyFields => 'Please fill all fields.';

  @override
  String get homeTitle => 'Serenity';

  @override
  String homeGreeting(String name) {
    return 'Good morning, $name';
  }

  @override
  String get homeSubtitle => 'Ready to find your center today?';

  @override
  String get homeDailyReflection => 'DAILY REFLECTION';

  @override
  String get homeQuote => '\"Quiet the mind, and the\\nsoul will speak.\"';

  @override
  String get homeStartSession => 'Start Session';

  @override
  String get homePractices => 'Practices';

  @override
  String get practiceMindfulness => 'Mindfulness';

  @override
  String get practiceJournal => 'Journal';

  @override
  String get practiceSleep => 'Sleep';

  @override
  String get practiceYoga => 'Yoga';

  @override
  String get homeRecentActivity => 'Recent Activity';

  @override
  String get homeViewAll => 'View all';

  @override
  String get activityBreathwork => '10 min Breathwork';

  @override
  String get activityMorningStretch => 'Morning Stretch';

  @override
  String get activityTimeToday => 'Today, 7:30 AM';

  @override
  String get activityTimeYesterday => 'Yesterday, 8:00 AM';

  @override
  String get navHome => 'Home';

  @override
  String get navReflect => 'Reflect';

  @override
  String get navExplore => 'Explore';

  @override
  String get fakeGpsTitle => 'Access Denied';

  @override
  String get fakeGpsSubtitle =>
      'Our security systems have detected the use of a Fake GPS or mock location app on your device.';

  @override
  String get fakeGpsWarning =>
      'To protect the integrity of our application, you cannot continue using it while location spoofing is active.';

  @override
  String get fakeGpsButton => 'Close Application';

  @override
  String get usbDebuggingTitle => 'Insecure Environment';

  @override
  String get usbDebuggingSubtitle =>
      'USB Debugging has been detected as active on this device.';

  @override
  String get usbDebuggingWarning =>
      'Due to security policies, this application cannot run in an environment with debugging enabled. Please disable this option in your system settings.';
}
