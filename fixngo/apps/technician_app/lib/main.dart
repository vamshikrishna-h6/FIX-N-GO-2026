import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'earnings_screen.dart';
import 'job_detail_screen.dart';
import 'my_jobs_screen.dart';
import 'profile_screen.dart';
import 'payment_screen.dart';
import 'withdrawal_screen.dart';
import 'support_screen.dart';
import 'notifications_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/documents_kyc_screen.dart';
import 'screens/bank_details_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/activity_history_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FixNGoTechApp());
}

class FixNGoTechApp extends StatelessWidget {
  const FixNGoTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fix-N-Go Tech',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/job_detail': (context) => const JobDetailScreen(),
        '/earnings': (context) => EarningsScreen(),
        '/my_jobs': (context) => MyJobsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/withdrawal': (context) => const WithdrawalScreen(),
        '/support': (context) => const SupportScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/documents_kyc': (context) => const DocumentsKycScreen(),
        '/bank_details': (context) => const BankDetailsScreen(),
        '/notification_settings': (context) => const NotificationSettingsScreen(),
        '/privacy_policy': (context) => const PrivacyPolicyScreen(),
        '/terms': (context) => const TermsScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/activity_history': (context) => const ActivityHistoryScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
