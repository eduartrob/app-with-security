import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:protection_information/core/l10n/app_localizations.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/secure_data_service.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/services/notification_history_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../auth/login/presentation/pages/login_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../../features/notifications/presentation/pages/notifications_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    // Inicializar datos simulados si no existen
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final secureDataService = context.read<SecureDataService>();
      await secureDataService.loadData();
      
      // Obtener el token de FCM para probar el borrado específico
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (mounted) {
          setState(() {
            _fcmToken = token;
          });
          debugPrint("FCM Token: $_fcmToken");
        }
      } catch (e) {
        debugPrint("Error getting FCM token: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definimos los colores extraídos del HTML
    const Color bgBackground = Color(0xFFF9F9F9);
    const Color textPrimary = Color(0xFF4C6455);
    const Color textSecondary = Color(0xFF5F5E58);
    const Color surfaceContainer = Color(0xFFEEEEED);
    const Color onSurface = Color(0xFF1A1C1C);
    const Color primaryContainer = Color(0xFF8FA998);
    const Color onPrimaryContainer = Color(0xFF273E31);
    const Color primaryFixed = Color(0xFFCEE9D6);
    const Color onPrimaryFixed = Color(0xFF082014);
    const Color onPrimaryFixedVariant = Color(0xFF344C3E);
    const Color surfaceContainerLowest = Color(0xFFFFFFFF);
    const Color secondaryContainer = Color(0xFFE5E2DA);
    const Color onSecondaryContainer = Color(0xFF65645E);
    const Color surfaceContainerLow = Color(0xFFF3F4F3);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bgBackground,
      appBar: AppBar(
        backgroundColor: bgBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
          child: Consumer<UserProfileService>(
            builder: (context, userProfile, _) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: userProfile.profileImageBase64 != null
                      ? Image.memory(
                          base64Decode(userProfile.profileImageBase64!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: textSecondary),
                        )
                      : const Icon(Icons.person, color: textSecondary),
                ),
              );
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          l10n.homeTitle,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Consumer<NotificationHistoryService>(
              builder: (context, historyService, _) {
                final unreadCount = historyService.unreadCount;
                return IconButton(
                  icon: Badge(
                    isLabelVisible: unreadCount > 0,
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.notifications_none, color: textSecondary),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsPage()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Consumer<UserProfileService>(
              builder: (context, userProfile, _) {
                return Text(
                  l10n.homeGreeting(userProfile.userName),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              l10n.homeSubtitle,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                color: onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            // Daily Reflection Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: primaryFixed,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(76, 100, 85, 0.05),
                    blurRadius: 40,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.self_improvement, color: onPrimaryFixedVariant, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.homeDailyReflection,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: onPrimaryFixedVariant.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.homeQuote,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: onPrimaryFixed,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Practices
            Text(
              l10n.homePractices,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: onSurface,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: [
                  _buildPracticeItem('Mindfulness', Icons.spa, l10n.practiceMindfulness, surfaceContainer, textPrimary),
                  const SizedBox(width: 16),
                  _buildPracticeItem('Journal', Icons.book, l10n.practiceJournal, surfaceContainer, textPrimary),
                  const SizedBox(width: 16),
                  _buildPracticeItem('Sleep', Icons.bedtime, l10n.practiceSleep, surfaceContainer, textPrimary),
                  const SizedBox(width: 16),
                  _buildPracticeItem('Yoga', Icons.sports_gymnastics, l10n.practiceYoga, surfaceContainer, textPrimary),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Recent Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.homeRecentActivity,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    l10n.homeViewAll,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              l10n.activityBreathwork,
              l10n.activityTimeToday,
              Icons.air,
              surfaceContainerLowest,
              secondaryContainer,
              onSecondaryContainer,
              onSurface,
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              l10n.activityMorningStretch,
              l10n.activityTimeYesterday,
              Icons.accessibility_new,
              surfaceContainerLowest,
              secondaryContainer,
              onSecondaryContainer,
              onSurface,
            ),
            const SizedBox(height: 40), // Espacio para el BottomNav
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 24, top: 16, left: 16, right: 16),
        decoration: const BoxDecoration(
          color: surfaceContainerLow,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 40,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavButton(Icons.home, l10n.navHome, true, primaryContainer, onPrimaryContainer),
            _buildNavButton(Icons.self_improvement, l10n.navReflect, false, Colors.transparent, textSecondary),
            _buildNavButton(Icons.spa, l10n.navExplore, false, Colors.transparent, textSecondary),
            // Botón de configuración actuará como "Cerrar sesión"
            IconButton(
              onPressed: () async {
                // Volver al login de forma abrupta simulando cerrar sesión
                context.read<SessionService>().stopSession();
                await context.read<StorageService>().remove('is_logged_in');
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.logout), // Usamos logout en vez de settings
              color: textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeItem(String id, IconData icon, String label, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.03),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424844), // on-surface-variant
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      String title, String subtitle, IconData icon, Color bgColor, Color iconBgColor, Color iconColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.02),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    color: Color(0xFF424844), // on-surface-variant
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, bool isActive, Color activeBg, Color activeFg) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: activeBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: activeFg),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: activeFg,
              ),
            ),
          ],
        ),
      );
    }
    return IconButton(
      onPressed: () {},
      icon: Icon(icon),
      color: activeFg,
    );
  }

}
