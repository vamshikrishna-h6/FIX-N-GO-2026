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
      },
    );
  }
}
