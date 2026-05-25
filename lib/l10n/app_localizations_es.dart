// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginWelcomeBack => 'Bienvenido de nuevo';

  @override
  String get loginSubtitle =>
      'Por favor, ingresa tus datos para iniciar sesión.';

  @override
  String get emailHint => 'Correo Electrónico';

  @override
  String get passwordHint => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get orContinueWith => 'O CONTINÚA CON';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Regístrate';

  @override
  String get loginSuccess => '¡Bienvenido!';

  @override
  String get registerCreateAccount => 'Crear Cuenta';

  @override
  String get registerSubtitle =>
      'Comienza tu viaje con una experiencia fluida y silenciosa.';

  @override
  String get fullNameHint => 'Nombre Completo';

  @override
  String get registerSuccess => '¡Cuenta Creada!';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get logIn => 'Inicia sesión';

  @override
  String get errorInvalidCredentials =>
      'El correo o la contraseña son incorrectos.';

  @override
  String get errorEmptyFields => 'Por favor, complete todos los campos.';

  @override
  String get homeTitle => 'Serenity';

  @override
  String homeGreeting(String name) {
    return 'Buenos días, $name';
  }

  @override
  String get homeSubtitle => '¿Listo para encontrar tu centro hoy?';

  @override
  String get homeDailyReflection => 'REFLEXIÓN DIARIA';

  @override
  String get homeQuote => '\"Silencia la mente, y el\\nalma hablará.\"';

  @override
  String get homeStartSession => 'Iniciar Sesión';

  @override
  String get homePractices => 'Prácticas';

  @override
  String get practiceMindfulness => 'Atención Plena';

  @override
  String get practiceJournal => 'Diario';

  @override
  String get practiceSleep => 'Sueño';

  @override
  String get practiceYoga => 'Yoga';

  @override
  String get homeRecentActivity => 'Actividad Reciente';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String get activityBreathwork => 'Respiración de 10 min';

  @override
  String get activityMorningStretch => 'Estiramiento Matutino';

  @override
  String get activityTimeToday => 'Hoy, 7:30 AM';

  @override
  String get activityTimeYesterday => 'Ayer, 8:00 AM';

  @override
  String get navHome => 'Inicio';

  @override
  String get navReflect => 'Reflexionar';

  @override
  String get navExplore => 'Explorar';

  @override
  String get fakeGpsTitle => 'Acceso Denegado';

  @override
  String get fakeGpsSubtitle =>
      'Nuestros sistemas de seguridad han detectado el uso de un Fake GPS o aplicación de ubicación simulada en su dispositivo.';

  @override
  String get fakeGpsWarning =>
      'Para proteger la integridad de nuestra aplicación, no puede continuar usándola mientras la simulación de ubicación esté activa.';

  @override
  String get fakeGpsButton => 'Cerrar Aplicación';
}
