import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(const FixNGoApp());

// ═══════════════════════════════════════════
//  DESIGN TOKENS
// ═══════════════════════════════════════════
class AppColors {
  static const black  = Color(0xFF0C0C0C);
  static const white  = Color(0xFFFFFFFF);
  static const off    = Color(0xFFF5F5F5);
  static const off2   = Color(0xFFEBEBEB);
  static const border = Color(0xFFE2E2E2);
  static const muted  = Color(0xFF9B9B9B);
  static const dark2  = Color(0xFF1A1A1A);
  static const red    = Color(0xFFFF2D2D);
  static const green  = Color(0xFF00C853);
  static const yellow = Color(0xFFFFC107);
  static const blue   = Color(0xFF1A56FF);
}

class ResponsiveUtils {
  static double getScaleFactor(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 360) return 0.82;
    if (w < 390) return 0.92;
    if (w < 460) return 0.98;
    if (w < 600) return 1.0;
    if (w < 900) return 1.08;
    return 1.16;
  }

  static double scaledSize(BuildContext context, double base) =>
      base * getScaleFactor(context);

  static double scaledPadding(BuildContext context, double base) =>
      base * getScaleFactor(context);

  static int getGridColumns(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 360) return 2;
    if (w < 600) return 3;
    if (w < 900) return 4;
    return 5;
  }

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;
}

// ═══════════════════════════════════════════
//  FONT HELPERS
// ═══════════════════════════════════════════
class AppFonts {
  static double _s(BuildContext? ctx) =>
      ctx != null ? ResponsiveUtils.getScaleFactor(ctx) : 1.0;

  static TextStyle display({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w800,
    Color color = AppColors.black,
    double? letterSpacing,
    double? height,
    BuildContext? context,
  }) =>
      TextStyle(
        fontFamily: 'Outfit',
        fontSize: fontSize * _s(context),
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle body({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.black,
    double? letterSpacing,
    double? height,
    BuildContext? context,
  }) =>
      TextStyle(
        fontFamily: 'Nunito',
        fontSize: fontSize * _s(context),
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle label({
    Color color = AppColors.muted,
    double fontSize = 10,
    BuildContext? context,
  }) =>
      TextStyle(
        fontFamily: 'Nunito',
        fontSize: fontSize * _s(context),
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 1.2,
      );

  static TextStyle price({
    Color color = AppColors.black,
    double fontSize = 13,
    BuildContext? context,
  }) =>
      TextStyle(
        fontFamily: 'Outfit',
        fontSize: fontSize * _s(context),
        fontWeight: FontWeight.w700,
        color: color,
      );
}

// ═══════════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════════
class Brand {
  final String name, emoji;
  final List<String> models;
  const Brand({required this.name, required this.emoji, required this.models});
}

class Issue {
  final String name, emoji, description;
  final int price;
  const Issue(
      {required this.name,
      required this.emoji,
      required this.description,
      required this.price});
}

class Technician {
  final String name, emoji, rating, experience, eta, distance;
  final int jobs;
  const Technician(
      {required this.name,
      required this.emoji,
      required this.rating,
      required this.experience,
      required this.jobs,
      required this.eta,
      required this.distance});
}

class Order {
  final String id, brand, model, techName, date, status;
  final List<String> issues;
  final int total;
  const Order(
      {required this.id,
      required this.brand,
      required this.model,
      required this.issues,
      required this.techName,
      required this.date,
      required this.status,
      required this.total});
}

// ═══════════════════════════════════════════
//  APP STATE
// ═══════════════════════════════════════════
class AppState extends ChangeNotifier {
  String currentScreen = 'login';
  bool isLoggedIn = false;

  // User profile
  String userName = 'Rahul Mehta';
  String userEmail = 'rahul.mehta@gmail.com';
  String userPhone = '+91 98765 43210';
  String userLocation = 'Kondapur, Hyderabad';

  // Booking flow
  String selBrand = '';
  String selModel = '';
  List<Issue> selIssues = [];
  int total = 0;
  String pickedTechName = 'Ravi Kumar';
  String pickedEta = '12';
  String pickedRating = '4.9';

  // Orders history
  final List<Order> orders = const [
    Order(
        id: '#FNG-001',
        brand: 'Samsung',
        model: 'Galaxy S25 Ultra',
        issues: ['Screen Broken'],
        techName: 'Ravi Kumar',
        date: '24 May 2025',
        status: 'completed',
        total: 999),
    Order(
        id: '#FNG-002',
        brand: 'Apple',
        model: 'iPhone 16 Pro',
        issues: ['Battery Issue', 'Charging Port'],
        techName: 'Priya Sharma',
        date: '18 May 2025',
        status: 'completed',
        total: 1098),
    Order(
        id: '#FNG-003',
        brand: 'OnePlus',
        model: 'OnePlus 13',
        issues: ['Screen Guard'],
        techName: 'Suresh Babu',
        date: '12 May 2025',
        status: 'cancelled',
        total: 199),
    Order(
        id: '#FNG-004',
        brand: 'Xiaomi',
        model: 'Redmi Note 15 Pro',
        issues: ['Camera Issue', 'Software / Hang'],
        techName: 'Ravi Kumar',
        date: '3 May 2025',
        status: 'completed',
        total: 998),
  ];

  void go(String screen) {
    currentScreen = screen;
    notifyListeners();
  }

  void login(String name, String email) {
    if (name.isNotEmpty) userName = name;
    if (email.isNotEmpty) userEmail = email;
    isLoggedIn = true;
    currentScreen = 's1';
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    currentScreen = 'login';
    selBrand = '';
    selModel = '';
    selIssues = [];
    total = 0;
    notifyListeners();
  }

  void selectBrand(String brand) {
    selBrand = brand;
    selModel = '';
    notifyListeners();
  }

  void selectModel(String model) {
    selModel = model;
    notifyListeners();
  }

  void toggleIssue(Issue issue) {
    final idx = selIssues.indexWhere((i) => i.name == issue.name);
    if (idx == -1) {
      selIssues.add(issue);
      total += issue.price;
    } else {
      selIssues.removeAt(idx);
      total -= issue.price;
    }
    notifyListeners();
  }

  bool isIssueSelected(Issue issue) => selIssues.any((i) => i.name == issue.name);

  void pickTech(Technician tech) {
    pickedTechName = tech.name;
    pickedEta = tech.eta.replaceAll(' min', '');
    pickedRating = tech.rating;
    notifyListeners();
  }
}

// ═══════════════════════════════════════════
//  APP ROOT + PHONE SHELL
// ═══════════════════════════════════════════
class FixNGoApp extends StatelessWidget {
  const FixNGoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Fix-N-Go',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: AppColors.dark2),
        home: const PhoneShell(),
      );
}

class PhoneShell extends StatelessWidget {
  const PhoneShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark2,
      body: LayoutBuilder(builder: (ctx, constraints) {
        if (constraints.maxWidth < 600) {
          return const SafeArea(child: AppNavigator(showFakeStatusBar: false));
        }
        const ratio = 390.0 / 844.0;
        double fw = constraints.maxWidth * 0.9;
        double fh = fw / ratio;
        if (fh > constraints.maxHeight * 0.95) {
          fh = constraints.maxHeight * 0.95;
          fw = fh * ratio;
        }
        return Center(
          child: Container(
            width: fw,
            height: fh,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 44)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 120,
                    offset: const Offset(0, 48)),
                BoxShadow(
                    color: Colors.white.withValues(alpha: 0.08),
                    spreadRadius: 1.5),
              ],
            ),
            // ── KEY FIX: override MediaQuery so ResponsiveUtils
            //    sees the phone-frame size, not the browser width ──
            child: MediaQuery(
              data: MediaQuery.of(ctx).copyWith(size: Size(fw, fh)),
              child: const AppNavigator(showFakeStatusBar: true),
            ),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════
//  NAVIGATOR
// ═══════════════════════════════════════════
class AppNavigator extends StatefulWidget {
  final bool showFakeStatusBar;
  const AppNavigator({super.key, this.showFakeStatusBar = true});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final _state = AppState();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.showFakeStatusBar) const StatusBar(),
      Expanded(
        child: AnimatedBuilder(
          animation: _state,
          builder: (_, child) => switch (_state.currentScreen) {
            'login'    => ScreenLogin(state: _state),
            'register' => ScreenRegister(state: _state),
            's2'       => Screen2BrandModel(state: _state),
            's3'       => Screen3Issues(state: _state),
            's4'       => Screen4Finding(state: _state),
            's5'       => Screen5Confirmed(state: _state),
            'orders'   => ScreenOrders(state: _state),
            'profile'  => ScreenProfile(state: _state),
            _          => Screen1Home(state: _state),
          },
        ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════
//  STATUS BAR  (live clock + icons)
// ═══════════════════════════════════════════
class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmt(DateTime dt) {
    final h = dt.hour > 12
        ? dt.hour - 12
        : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveUtils.scaledSize(context, 44),
      color: AppColors.black,
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.scaledPadding(context, 18)),
      child: Stack(children: [
        // Dynamic island notch
        Positioned(
          top: 0, left: 0, right: 0,
          child: Center(
            child: Container(
              width: ResponsiveUtils.scaledSize(context, 120),
              height: ResponsiveUtils.scaledSize(context, 34),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(ResponsiveUtils.scaledSize(context, 20))),
              ),
            ),
          ),
        ),
        // Left: time
        Positioned(
          left: 0, top: 0, bottom: 0,
          child: Center(
            child: Text(
              _fmt(_now),
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        // Right: signal + wifi + battery
        Positioned(
          right: 0, top: 0, bottom: 0,
          child: Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.signal_cellular_alt,
                  color: Colors.white, size: ResponsiveUtils.scaledSize(context, 13)),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 4)),
              Icon(Icons.wifi, color: Colors.white, size: ResponsiveUtils.scaledSize(context, 13)),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 5)),
              // Battery shape
              Container(
                width: ResponsiveUtils.scaledSize(context, 22), height: ResponsiveUtils.scaledSize(context, 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 3)),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Row(children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 1.5)),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 1.5)),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                ]),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════
//  SCREEN: LOGIN
// ═══════════════════════════════════════════
class ScreenLogin extends StatefulWidget {
  final AppState state;
  const ScreenLogin({super.key, required this.state});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure  = true;
  bool _loading  = false;

  void _doLogin() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _loading = false);
      widget.state.login(
          'Rahul Mehta',
          _emailCtrl.text.isNotEmpty
              ? _emailCtrl.text
              : 'rahul.mehta@gmail.com');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 26)),
        child: Column(children: [
          SizedBox(height: ResponsiveUtils.scaledSize(context, 42)),
          const _Logo(),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 8)),
          Text('Doorstep phone repair, in 60 min',
              textAlign: TextAlign.center,
              style: AppFonts.body(
                  fontSize: 12, color: const Color(0x55FFFFFF))),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 46)),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Welcome back 👋',
                  style: AppFonts.display(
                      fontSize: 24, color: Colors.white, context: context)),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 6)),
              Text('Log in to continue booking repairs',
                  style: AppFonts.body(
                      fontSize: 13, color: const Color(0x60FFFFFF))),
            ]),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 30)),
          _AuthInput(
              controller: _emailCtrl,
              hint: 'Email address',
              icon: Icons.mail_outline_rounded,
              keyboard: TextInputType.emailAddress),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
          _AuthInput(
            controller: _passCtrl,
            hint: 'Password',
            icon: Icons.lock_outline_rounded,
            obscure: _obscure,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscure = !_obscure),
              child: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.muted,
                  size: ResponsiveUtils.scaledSize(context, 20)),
            ),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 10)),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Forgot password?',
                style: AppFonts.body(fontSize: 12, color: AppColors.red)),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 26)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 16)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18))),
                elevation: 0,
              ),
              onPressed: _loading ? null : _doLogin,
              child: _loading
                  ? SizedBox(
                      height: ResponsiveUtils.scaledSize(context, 20), width: ResponsiveUtils.scaledSize(context, 20),
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text('Login',
                      style: AppFonts.display(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
            ),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 20)),
          Row(children: [
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 14)),
              child: Text('or',
                  style: AppFonts.body(
                      fontSize: 12, color: const Color(0x40FFFFFF))),
            ),
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
          ]),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 20)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                padding: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 14)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18))),
              ),
              onPressed: _doLogin,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('G', style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 18), color: Colors.white,
                    fontWeight: FontWeight.w800)),
                SizedBox(width: ResponsiveUtils.scaledSize(context, 10)),
                Text('Continue with Google',
                    style: AppFonts.body(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ]),
            ),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 30)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Don't have an account?",
                style: AppFonts.body(
                    fontSize: 13, color: const Color(0x60FFFFFF))),
            SizedBox(width: ResponsiveUtils.scaledSize(context, 5)),
            GestureDetector(
              onTap: () => widget.state.go('register'),
              child: Text('Register',
                  style: AppFonts.body(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.red)),
            ),
          ]),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 18)),
          GestureDetector(
            onTap: () => widget.state.login('Rahul Mehta', 'rahul@gmail.com'),
            child: Text('Skip → Continue as Guest',
                style: AppFonts.body(
                    fontSize: 11,
                    color: const Color(0x35FFFFFF),
                    letterSpacing: 0.3)),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 30)),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  SCREEN: REGISTER
// ═══════════════════════════════════════════
class ScreenRegister extends StatefulWidget {
  final AppState state;
  const ScreenRegister({super.key, required this.state});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  bool get _valid =>
      _nameCtrl.text.trim().isNotEmpty &&
      _phoneCtrl.text.trim().length >= 10 &&
      _emailCtrl.text.contains('@') &&
      _passCtrl.text.length >= 6;

  void _doRegister() async {
    if (!_valid) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _loading = false);
      widget.state.login(_nameCtrl.text.trim(), _emailCtrl.text.trim());
    }
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _phoneCtrl, _emailCtrl, _passCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 26)),
        child: Column(children: [
          SizedBox(height: ResponsiveUtils.scaledSize(context, 16)),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => widget.state.go('login'),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: ResponsiveUtils.scaledSize(context, 14)),
                SizedBox(width: ResponsiveUtils.scaledSize(context, 6)),
                Text('Back',
                    style: AppFonts.body(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.5))),
              ]),
            ),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 24)),
          const _Logo(),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 28)),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Create account ✨',
                  style: AppFonts.display(
                      fontSize: 24, color: Colors.white, context: context)),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 6)),
              Text('Get your phone fixed, fast',
                  style: AppFonts.body(
                      fontSize: 13, color: const Color(0x60FFFFFF))),
            ]),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 26)),
          _AuthInput(
              controller: _nameCtrl,
              hint: 'Full name',
              icon: Icons.person_outline_rounded,
              onChanged: (_) => setState(() {})),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
          _AuthInput(
              controller: _phoneCtrl,
              hint: 'Mobile number',
              icon: Icons.phone_outlined,
              keyboard: TextInputType.phone,
              onChanged: (_) => setState(() {})),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
          _AuthInput(
              controller: _emailCtrl,
              hint: 'Email address',
              icon: Icons.mail_outline_rounded,
              keyboard: TextInputType.emailAddress,
              onChanged: (_) => setState(() {})),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
          _AuthInput(
            controller: _passCtrl,
            hint: 'Password (min 6 chars)',
            icon: Icons.lock_outline_rounded,
            obscure: _obscure,
            onChanged: (_) => setState(() {}),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscure = !_obscure),
              child: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.muted,
                  size: ResponsiveUtils.scaledSize(context, 20)),
            ),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 28)),
          Opacity(
            opacity: _valid ? 1.0 : 0.4,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 16)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18))),
                  elevation: 0,
                ),
                onPressed: (_valid && !_loading) ? _doRegister : null,
                child: _loading
                    ? SizedBox(
                        height: ResponsiveUtils.scaledSize(context, 20), width: ResponsiveUtils.scaledSize(context, 20),
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text('Create Account',
                        style: AppFonts.display(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 20)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Already have an account?',
                style: AppFonts.body(
                    fontSize: 13, color: const Color(0x60FFFFFF))),
            SizedBox(width: ResponsiveUtils.scaledSize(context, 5)),
            GestureDetector(
              onTap: () => widget.state.go('login'),
              child: Text('Login',
                  style: AppFonts.body(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.red)),
            ),
          ]),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 32)),
        ]),
      ),
    );
  }
}

// Auth input helper
class _AuthInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType keyboard;
  final ValueChanged<String>? onChanged;

  const _AuthInput({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboard = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        onChanged: onChanged,
        style: AppFonts.body(fontSize: 14, color: Colors.white),
        cursorColor: AppColors.red,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.muted, size: ResponsiveUtils.scaledSize(context, 18)),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: AppFonts.body(
              fontSize: 14, color: const Color(0x40FFFFFF)),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(vertical: ResponsiveUtils.scaledPadding(context, 16), horizontal: ResponsiveUtils.scaledPadding(context, 4)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  SCREEN 1 – HOME
// ═══════════════════════════════════════════
class Screen1Home extends StatelessWidget {
  final AppState state;
  const Screen1Home({super.key, required this.state});

  static const _services = [
    _ServiceCard(
        emoji: '📱', name: 'Mobile Repair',
        desc: 'Screen · Battery · Port · Speaker',
        price: 'From ₹399', style: _SvcStyle.dark),
    _ServiceCard(
        emoji: '🛡️', name: 'Screen Guard',
        desc: 'Tempered · Anti-spy · UV',
        price: 'From ₹199', style: _SvcStyle.red),
    _ServiceCard(
        emoji: '🔋', name: 'Battery',
        desc: 'Genuine replacement',
        price: 'From ₹599', style: _SvcStyle.light),
    _ServiceCard(
        emoji: '⚡', name: 'Charging Port',
        desc: 'Clean · Fix · Replace',
        price: 'From ₹499', style: _SvcStyle.blue),
  ];

  static const _activity = [
    _ActivityItem(when: 'Now · Kondapur', model: 'iPhone 16 Pro', what: 'Screen replaced'),
    _ActivityItem(when: '5 min · Gachibowli', model: 'Samsung S25', what: 'Guard fitted'),
    _ActivityItem(when: '11 min · Madhapur', model: 'OnePlus 13', what: 'Battery replaced'),
    _ActivityItem(when: '18 min · HITEC City', model: 'Realme GT 7', what: 'Port fixed'),
  ];

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveUtils.isLandscape(context);
    final hp = ResponsiveUtils.scaledPadding(context, 18);
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _HomeHero(onTap: () => state.go('s2'), userName: state.userName),

            // Search
            Padding(
              padding: EdgeInsets.fromLTRB(hp, 16, hp, 0),
              child: GestureDetector(
                onTap: () => state.go('s2'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.scaledPadding(context, 16), vertical: ResponsiveUtils.scaledPadding(context, 13)),
                  decoration: BoxDecoration(
                    color: AppColors.off,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18)),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(children: [
                    Icon(Icons.search_rounded,
                        color: AppColors.muted, size: ResponsiveUtils.scaledSize(context, 20)),
                    SizedBox(width: ResponsiveUtils.scaledSize(context, 10)),
                    Flexible(
                      child: Text('Search by phone model…',
                          style: AppFonts.body(
                              fontSize: 14,
                              color: AppColors.muted,
                              context: context)),
                    ),
                  ]),
                ),
              ),
            ),

            // Services grid
            Padding(
              padding: EdgeInsets.fromLTRB(hp, 20, hp, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _SectionLabel('Our Services'),
                GridView.count(
                  crossAxisCount: ResponsiveUtils.getGridColumns(context),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: isLandscape ? 1.3 : 1.0,
                  children: _services
                      .map((s) =>
                          _ServiceTile(card: s, onTap: () => state.go('s2')))
                      .toList(),
                ),
              ]),
            ),

            // Trust strip
            Padding(
              padding: EdgeInsets.fromLTRB(hp, 14, hp, 18),
              child: GestureDetector(
                onTap: () => state.go('s2'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.scaledPadding(context, 16), vertical: ResponsiveUtils.scaledPadding(context, 14)),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18)),
                  ),
                  child: Row(children: [
                    Text('🏠', style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 26))),
                    SizedBox(width: ResponsiveUtils.scaledSize(context, 12)),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Doorstep in under 60 min',
                                style: AppFonts.display(
                                    fontSize: 13,
                                    color: Colors.white,
                                    context: context)),
                            SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
                            Text('Certified · Guaranteed · On-time',
                                style: AppFonts.body(
                                    fontSize: 11,
                                    color: const Color(0x66FFFFFF),
                                    context: context)),
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.scaledPadding(context, 11), vertical: ResponsiveUtils.scaledPadding(context, 5)),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 20)),
                      ),
                      child: Text('BOOK',
                          style: AppFonts.body(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              context: context)),
                    ),
                  ]),
                ),
              ),
            ),

            // Activity
            Padding(
              padding: EdgeInsets.fromLTRB(hp, 0, hp, 10),
              child: const _SectionLabel('Just fixed nearby'),
            ),
            SizedBox(
              height: isLandscape ? 100 : 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.fromLTRB(hp, 0, hp, 2),
                itemCount: _activity.length,
                separatorBuilder: (_, index) => SizedBox(width: ResponsiveUtils.scaledSize(context, 10)),
                itemBuilder: (_, i) => _ActivityCard(item: _activity[i]),
              ),
            ),
            SizedBox(height: ResponsiveUtils.scaledSize(context, 16)),
          ]),
        ),
      ),
      _BottomNav(
        activeIndex: 0,
        onTap: (i) {
          if (i == 1) {
            state.go('s2');
          } else if (i == 2) {
            state.go('orders');
          } else if (i == 3) {
            state.go('profile');
          }
        },
      ),
    ]);
  }
}

class _HomeHero extends StatefulWidget {
  final VoidCallback onTap;
  final String userName;
  const _HomeHero({required this.onTap, required this.userName});

  @override
  State<_HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<_HomeHero>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.scaledPadding(context, 22);
    final firstName = widget.userName.split(' ').first;
    return Container(
      padding: EdgeInsets.fromLTRB(padding, 18, padding, 24),
      color: AppColors.black,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const _Logo(),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: ResponsiveUtils.scaledSize(context, 36), height: ResponsiveUtils.scaledSize(context, 36),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: Center(
                  child: Text('👤', style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 15))),
              ),
            ),
          ),
        ]),
        SizedBox(height: ResponsiveUtils.scaledSize(context, 18)),
        Text('Hey $firstName 👋',
            style: AppFonts.body(
                fontSize: 13,
                color: const Color(0x73FFFFFF),
                context: context)),
        SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
        Text('What needs\nfixing today?',
            style: AppFonts.display(
                fontSize: 26,
                color: Colors.white,
                height: ResponsiveUtils.scaledSize(context, 1.1),
                context: context)),
        SizedBox(height: ResponsiveUtils.scaledSize(context, 6)),
        Row(children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => Container(
              width: ResponsiveUtils.scaledSize(context, 7), height: ResponsiveUtils.scaledSize(context, 7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green.withValues(alpha: 0.5 * (1 - _ctrl.value)),
                    blurRadius: 6,
                    spreadRadius: 3 * _ctrl.value,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: ResponsiveUtils.scaledSize(context, 7)),
          Flexible(
            child: Text('4 techs active near Kondapur',
                style: AppFonts.body(
                    fontSize: 12,
                    color: const Color(0x80FFFFFF),
                    context: context)),
          ),
        ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════
//  SCREEN 2 – BRAND + MODEL
// ═══════════════════════════════════════════
class Screen2BrandModel extends StatefulWidget {
  final AppState state;
  const Screen2BrandModel({super.key, required this.state});

  @override
  State<Screen2BrandModel> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2BrandModel> {
  final _searchCtrl = TextEditingController();
  List<String> _filteredModels = [];
  bool _showSearch = false;

  static const _brands = [
    Brand(name: 'Samsung', emoji: '📱', models: [
      'Galaxy S26 Ultra', 'Galaxy S25 Ultra', 'Galaxy S25', 'Galaxy S24',
      'Galaxy A55 5G', 'Galaxy A35', 'Galaxy F55', 'Galaxy Z Fold 6', 'Galaxy Z Flip 6'
    ]),
    Brand(name: 'Apple', emoji: '🍎', models: [
      'iPhone 17 Pro Max', 'iPhone 17 Pro', 'iPhone 17', 'iPhone 16 Pro Max',
      'iPhone 16 Pro', 'iPhone 16', 'iPhone 15 Pro', 'iPhone 15', 'iPhone 14'
    ]),
    Brand(name: 'OnePlus', emoji: '🔴', models: [
      'OnePlus 13', 'OnePlus 13R', 'OnePlus Nord 6', 'OnePlus Nord CE 6',
      'OnePlus Nord CE 5', 'OnePlus 12', 'OnePlus Open 2'
    ]),
    Brand(name: 'Xiaomi', emoji: '🟠', models: [
      'Xiaomi 17 Ultra', 'Xiaomi 14T Pro', 'Redmi Note 15 Pro',
      'Redmi Note 15 SE', 'POCO X7 Pro', 'POCO F7 Pro', 'Redmi 14C 5G'
    ]),
    Brand(name: 'Vivo', emoji: '🔵', models: [
      'Vivo X300 FE', 'Vivo V50 Pro', 'Vivo V50', 'Vivo T5 Pro',
      'Vivo T4x', 'Vivo Y300 Plus', 'Vivo Y200 Pro'
    ]),
    Brand(name: 'Realme', emoji: '🟢', models: [
      'Realme 16T', 'Realme GT 7 Pro', 'Realme 13 Pro+', 'Realme 13 Pro',
      'Realme Narzo 80 Pro', 'Realme P3 Pro', 'Realme GT 6'
    ]),
    Brand(name: 'OPPO', emoji: '⚪', models: [
      'OPPO Find X9 Ultra', 'OPPO Find X9s', 'OPPO Reno 13 Pro',
      'OPPO Reno 13', 'OPPO A3 Pro', 'OPPO A3x'
    ]),
    Brand(name: 'iQOO', emoji: '⚡', models: [
      'iQOO 13', 'iQOO Z9 Turbo+', 'iQOO Z9s Pro',
      'iQOO Neo 9 Pro', 'iQOO 12', 'iQOO Z9x'
    ]),
    Brand(name: 'Nothing', emoji: '⬛', models: [
      'Nothing Phone 3', 'Nothing Phone 3a Pro', 'Nothing Phone 3a',
      'Nothing Phone 2a Plus', 'Nothing Phone 2'
    ]),
  ];

  static const _allModels = [
    'Galaxy S26 Ultra', 'Galaxy S25', 'Galaxy S24', 'Galaxy A55 5G',
    'iPhone 17 Pro Max', 'iPhone 17 Pro', 'iPhone 16 Pro Max', 'iPhone 16 Pro', 'iPhone 16',
    'OnePlus 13', 'OnePlus Nord 6', 'OnePlus Nord CE 6',
    'Xiaomi 17 Ultra', 'Redmi Note 15 Pro',
    'Vivo X300 FE', 'Vivo V50 Pro',
    'Realme 16T', 'Realme GT 7 Pro',
    'OPPO Find X9 Ultra', 'Nothing Phone 3', 'iQOO 13', 'POCO X7 Pro',
  ];

  void _filterModels(String q) {
    if (q.trim().isEmpty) {
      setState(() {
        _showSearch = false;
        _filteredModels = [];
      });
      return;
    }
    setState(() {
      _showSearch = true;
      _filteredModels = _allModels
          .where((m) => m.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  Brand? get _selectedBrand => _brands.cast<Brand?>().firstWhere(
      (b) => b?.name == widget.state.selBrand,
      orElse: () => null);

  List<String> get _modelList =>
      _showSearch ? _filteredModels : (_selectedBrand?.models ?? []);

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final canContinue = s.selBrand.isNotEmpty && s.selModel.isNotEmpty;
    final gridCols = ResponsiveUtils.isSmallPhone(context) ? 2 : 3;

    return Column(children: [
      Container(
        color: AppColors.black,
        padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 20), ResponsiveUtils.scaledPadding(context, 14), ResponsiveUtils.scaledPadding(context, 20), ResponsiveUtils.scaledPadding(context, 20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _BackButton(onTap: () => s.go('s1')),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
          Text('Select your phone',
              style: AppFonts.display(
                  fontSize: 23, color: Colors.white, context: context)),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
          Text('Choose brand → pick model',
              style: AppFonts.body(
                  fontSize: 12, color: const Color(0x61FFFFFF))),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
          const _ProgressBar(steps: 3, active: 0),
        ]),
      ),
      Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 0)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _SearchInput(
                controller: _searchCtrl,
                hint: 'Search phone model…',
                onChanged: _filterModels),
            SizedBox(height: ResponsiveUtils.scaledSize(context, 4)),
            const _SectionLabel('Popular Brands'),
            SizedBox(height: ResponsiveUtils.scaledSize(context, 12)),
            GridView.count(
              crossAxisCount: gridCols,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.15,
              children: _brands.map((b) {
                final sel = s.selBrand == b.name;
                return GestureDetector(
                  onTap: () {
                    s.selectBrand(b.name);
                    setState(() {
                      _showSearch = false;
                      _searchCtrl.clear();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.black : AppColors.off,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 12)),
                      border: Border.all(
                          color: sel ? AppColors.black : Colors.transparent,
                          width: 2),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(b.emoji,
                              style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 20))),
                          SizedBox(height: ResponsiveUtils.scaledSize(context, 5)),
                          Flexible(
                            child: Text(b.name,
                                textAlign: TextAlign.center,
                                style: AppFonts.display(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: sel
                                        ? Colors.white
                                        : AppColors.black)),
                          ),
                          SizedBox(height: ResponsiveUtils.scaledSize(context, 1)),
                          Flexible(
                            child: Text('${b.models.length} models',
                                textAlign: TextAlign.center,
                                style: AppFonts.body(
                                    fontSize: 9,
                                    color: sel
                                        ? Colors.white.withValues(alpha: 0.4)
                                        : AppColors.muted)),
                          ),
                        ]),
                  ),
                );
              }).toList(),
            ),
            if (_modelList.isNotEmpty) ...[
              SizedBox(height: ResponsiveUtils.scaledSize(context, 18)),
              _SectionLabel(_showSearch
                  ? 'Search Results'
                  : '${s.selBrand} Models'),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 12)),
              ..._modelList.map((m) {
                final sel = s.selModel == m;
                final year = _showSearch
                    ? 'Search result'
                    : (m.contains('17') ||
                            m.contains('26') ||
                            m.contains('16T') ||
                            m.contains('Nord 6')
                        ? '2025–26'
                        : '2024');
                return Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveUtils.scaledPadding(context, 7)),
                  child: GestureDetector(
                    onTap: () => s.selectModel(m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.scaledPadding(context, 15), vertical: ResponsiveUtils.scaledPadding(context, 13)),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.black : AppColors.off,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 8)),
                        border: Border.all(
                            color: sel
                                ? AppColors.black
                                : Colors.transparent,
                            width: 2),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m,
                                    style: AppFonts.body(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: sel
                                            ? Colors.white
                                            : AppColors.black)),
                                SizedBox(height: ResponsiveUtils.scaledSize(context, 1)),
                                Text(year,
                                    style: AppFonts.body(
                                        fontSize: 10,
                                        color: sel
                                            ? Colors.white.withValues(alpha: 0.4)
                                            : AppColors.muted)),
                              ]),
                        ),
                        Container(
                          width: ResponsiveUtils.scaledSize(context, 20), height: ResponsiveUtils.scaledSize(context, 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: sel ? AppColors.red : Colors.transparent,
                            border: Border.all(
                                color: sel ? AppColors.red : AppColors.off2,
                                width: 2),
                          ),
                          child: sel
                              ? Icon(Icons.check,
                                  size: ResponsiveUtils.scaledSize(context, 10), color: Colors.white)
                              : null,
                        ),
                      ]),
                    ),
                  ),
                );
              }),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 20)),
            ] else
              SizedBox(height: ResponsiveUtils.scaledSize(context, 20)),
          ]),
        ),
      ),
      _CtaButton(
          label: 'Continue →',
          enabled: canContinue,
          onTap: () => s.go('s3'),
          color: AppColors.black),
    ]);
  }
}

// ═══════════════════════════════════════════
//  SCREEN 3 – ISSUES
// ═══════════════════════════════════════════
class Screen3Issues extends StatelessWidget {
  final AppState state;
  const Screen3Issues({super.key, required this.state});

  static const _issues = [
    Issue(name: 'Screen Broken', emoji: '🖥️',
        description: 'Cracked, shattered or unresponsive display', price: 999),
    Issue(name: 'Battery Issue', emoji: '🔋',
        description: 'Drains fast, swollen or not charging', price: 599),
    Issue(name: 'Charging Port', emoji: '⚡',
        description: 'Loose connection, not charging', price: 499),
    Issue(name: 'Speaker / Mic', emoji: '🔊',
        description: 'No sound, distortion or mic failure', price: 399),
    Issue(name: 'Back Glass', emoji: '🪟',
        description: 'Cracked rear panel replacement', price: 799),
    Issue(name: 'Camera Issue', emoji: '📷',
        description: "Blurry, black screen or won't open", price: 699),
    Issue(name: 'Screen Guard', emoji: '🛡️',
        description: 'Bubble-free tempered glass at door', price: 199),
    Issue(name: 'Water Damage', emoji: '💧',
        description: 'Wet phone, corrosion deep-clean', price: 1199),
    Issue(name: 'Software / Hang', emoji: '💻',
        description: 'Phone freezes, apps crash, slow', price: 299),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (_, child) {
        final n = state.selIssues.length;
        final padding = ResponsiveUtils.scaledPadding(context, 18);
        return Column(children: [
          Container(
            color: AppColors.black,
            padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 20), ResponsiveUtils.scaledPadding(context, 14), ResponsiveUtils.scaledPadding(context, 20), ResponsiveUtils.scaledPadding(context, 20)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BackButton(onTap: () => state.go('s2')),
                  SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
                  Text("What's the issue?",
                      style: AppFonts.display(
                          fontSize: 23,
                          color: Colors.white,
                          context: context)),
                  SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
                  Text(
                    state.selBrand.isNotEmpty
                        ? '${state.selBrand} ${state.selModel}'
                        : 'Select all that apply',
                    style: AppFonts.body(
                        fontSize: 12, color: const Color(0x61FFFFFF)),
                  ),
                  SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
                  const _ProgressBar(steps: 3, active: 1),
                ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(padding, 18, padding, 20),
              child: Column(
                children: _issues
                    .map((issue) => Padding(
                          padding: EdgeInsets.only(bottom: ResponsiveUtils.scaledPadding(context, 8)),
                          child: _IssueTile(
                            issue: issue,
                            selected: state.isIssueSelected(issue),
                            onTap: () => state.toggleIssue(issue),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(padding, 12, padding, 0),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 16), vertical: ResponsiveUtils.scaledPadding(context, 13)),
            decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('ESTIMATED TOTAL',
                        style: AppFonts.label(
                            color: const Color(0x66FFFFFF), fontSize: 10)),
                    Text('₹${state.total}',
                        style: AppFonts.display(
                            fontSize: 22, color: Colors.white)),
                  ]),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.scaledPadding(context, 11), vertical: ResponsiveUtils.scaledPadding(context, 5)),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 20)),
                    ),
                    child: Text('$n ${n == 1 ? 'issue' : 'issues'}',
                        style: AppFonts.body(
                            fontSize: 11,
                            color: const Color(0x99FFFFFF))),
                  ),
                ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 10), ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 22)),
            child: _CtaButton(
              label: 'Find Technician →',
              enabled: n > 0,
              onTap: () => state.go('s4'),
              color: AppColors.red,
              fullWidth: true,
              margin: EdgeInsets.zero,
            ),
          ),
        ]);
      },
    );
  }
}

class _IssueTile extends StatelessWidget {
  final Issue issue;
  final bool selected;
  final VoidCallback onTap;
  const _IssueTile(
      {required this.issue, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 15)),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : AppColors.off,
          borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18)),
          border: Border.all(
              color: selected ? AppColors.black : Colors.transparent,
              width: 2),
        ),
        child: Row(children: [
          Container(
            width: ResponsiveUtils.scaledSize(context, 44), height: ResponsiveUtils.scaledSize(context, 44),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 8)),
              border: Border.all(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.border),
            ),
            child: Center(
                child: Text(issue.emoji,
                    style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 20))),
            ),
          ),
          SizedBox(width: ResponsiveUtils.scaledSize(context, 12)),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(issue.name,
                      style: AppFonts.display(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : AppColors.black,
                          context: context)),
                  SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
                  Text(issue.description,
                      style: AppFonts.body(
                          fontSize: 11,
                          height: ResponsiveUtils.scaledSize(context, 1.35),
                          color: selected
                              ? Colors.white.withValues(alpha: 0.38)
                              : AppColors.muted,
                          context: context)),
                ]),
          ),
          SizedBox(width: ResponsiveUtils.scaledSize(context, 8)),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('₹${issue.price}',
                style: AppFonts.price(
                    fontSize: 13,
                    color: selected ? AppColors.yellow : AppColors.black,
                    context: context)),
            SizedBox(height: ResponsiveUtils.scaledSize(context, 4)),
            Container(
              width: ResponsiveUtils.scaledSize(context, 22), height: ResponsiveUtils.scaledSize(context, 22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.red : Colors.transparent,
                border: Border.all(
                    color: selected ? AppColors.red : AppColors.off2,
                    width: 2),
              ),
              child: selected
                  ? Icon(Icons.check, size: ResponsiveUtils.scaledSize(context, 10), color: Colors.white)
                  : null,
            ),
          ]),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  SCREEN 4 – FINDING (Rapido-style)
// ═══════════════════════════════════════════
class Screen4Finding extends StatefulWidget {
  final AppState state;
  const Screen4Finding({super.key, required this.state});

  @override
  State<Screen4Finding> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4Finding>
    with TickerProviderStateMixin {
  late AnimationController _pingCtrl;
  late AnimationController _roamCtrl;
  String _selectedTech = 'Ravi Kumar';

  static const _technicians = [
    Technician(
        name: 'Ravi Kumar', emoji: '👨‍🔧',
        rating: '4.9', experience: '5+ yrs',
        jobs: 120, eta: '12 min', distance: '0.8 km'),
    Technician(
        name: 'Suresh Babu', emoji: '👨‍🔧',
        rating: '4.7', experience: '3 yrs',
        jobs: 88, eta: '18 min', distance: '1.4 km'),
    Technician(
        name: 'Priya Sharma', emoji: '👩‍🔧',
        rating: '4.8', experience: '4 yrs',
        jobs: 95, eta: '22 min', distance: '2.1 km'),
  ];

  @override
  void initState() {
    super.initState();
    _pingCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat();
    _roamCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pingCtrl.dispose();
    _roamCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Container(
          color: const Color(0xFF111111),
          child: Stack(children: [
            CustomPaint(painter: _GridPainter(), child: const SizedBox.expand()),
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.1),
                  colors: [
                    AppColors.red.withValues(alpha: 0.07),
                    Colors.transparent
                  ],
                  radius: 0.65,
                ),
              ),
            ),
            _RoamingDot(
                ctrl: _roamCtrl, emoji: '👨‍🔧', km: '1.2 km',
                left: 0.20, top: 0.22, delay: 0.0),
            _RoamingDot(
                ctrl: _roamCtrl, emoji: '👩‍🔧', km: '2.1 km',
                left: 0.72, top: 0.30, delay: 0.24),
            _RoamingDot(
                ctrl: _roamCtrl, emoji: '👨‍🔧', km: '0.8 km',
                left: 0.50, top: 0.18, delay: 0.40),
            Center(child: _UserPing(ctrl: _pingCtrl)),
            Positioned(
              top: 18,
              left: 18,
              child: Material(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 16)),
                elevation: 6,
                shadowColor: Colors.black.withValues(alpha: 0.14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 16)),
                  onTap: () => widget.state.go('s3'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.scaledPadding(context, 12), vertical: ResponsiveUtils.scaledPadding(context, 10)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.arrow_back_ios_new,
                          color: AppColors.black, size: ResponsiveUtils.scaledSize(context, 18)),
                      SizedBox(width: ResponsiveUtils.scaledSize(context, 6)),
                      Text('Back',
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils.scaledSize(context, 26))),
        ),
        padding: EdgeInsets.only(bottom: ResponsiveUtils.scaledPadding(context, 28)),
        child: Column(children: [
          Container(
            width: ResponsiveUtils.scaledSize(context, 36), height: ResponsiveUtils.scaledSize(context, 4),
            margin: EdgeInsets.symmetric(vertical: ResponsiveUtils.scaledPadding(context, 12)),
            decoration: BoxDecoration(
                color: AppColors.off2,
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 2))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 18)),
            child: Material(
              color: AppColors.off,
              borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 16)),
                onTap: () => widget.state.go('s3'),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.scaledPadding(context, 16), vertical: ResponsiveUtils.scaledPadding(context, 14)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.arrow_back_ios_new,
                        color: AppColors.black, size: ResponsiveUtils.scaledSize(context, 18)),
                    SizedBox(width: ResponsiveUtils.scaledSize(context, 8)),
                    Text('Back',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        )),
                  ]),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 12)),
          Container(
            padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 20), ResponsiveUtils.scaledPadding(context, 0), ResponsiveUtils.scaledPadding(context, 20), ResponsiveUtils.scaledPadding(context, 16)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border))),
            child: Row(children: [
              Stack(children: [
                Container(
                  width: ResponsiveUtils.scaledSize(context, 44), height: ResponsiveUtils.scaledSize(context, 44),
                  decoration: BoxDecoration(
                      color: AppColors.off, shape: BoxShape.circle),
                  child: Center(
                      child: Text('🔧', style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 22))),
                ),
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _pingCtrl,
                    builder: (_, child) => CircularProgressIndicator(
                      value: _pingCtrl.value,
                      strokeWidth: 2,
                      color: AppColors.red,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ]),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 10)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Finding technician…',
                    style: AppFonts.display(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        context: context)),
                SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
                Text('Broadcasting to nearby fixers',
                    style: AppFonts.body(
                        fontSize: 12,
                        color: AppColors.muted,
                        context: context)),
                SizedBox(height: ResponsiveUtils.scaledSize(context, 6)),
                Row(children: List.generate(3, (i) => _PulseDot(delay: i * 0.2))),
              ]),
            ]),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const _SectionLabel('Nearby Technicians'),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 4)),
              ..._technicians.map((t) {
                final picked = _selectedTech == t.name;
                return Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveUtils.scaledPadding(context, 8)),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedTech = t.name);
                      widget.state.pickTech(t);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 14), ResponsiveUtils.scaledPadding(context, 13), ResponsiveUtils.scaledPadding(context, 14), ResponsiveUtils.scaledPadding(context, 13)),
                      decoration: BoxDecoration(
                        color: picked ? AppColors.white : AppColors.off,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18)),
                        border: Border.all(
                            color: picked
                                ? AppColors.black
                                : Colors.transparent,
                            width: 2),
                      ),
                      child: Row(children: [
                        Stack(children: [
                          Container(
                            width: ResponsiveUtils.scaledSize(context, 46), height: ResponsiveUtils.scaledSize(context, 46),
                            decoration: BoxDecoration(
                                color: AppColors.off2,
                                shape: BoxShape.circle),
                            child: Center(
                                child: Text(t.emoji,
                                    style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 22))),
                            ),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: ResponsiveUtils.scaledSize(context, 16), height: ResponsiveUtils.scaledSize(context, 16),
                              decoration: BoxDecoration(
                                  color: AppColors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: Center(
                                  child: Text('✓',
                                      style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 8),
                                          color: Colors.white))),
                            ),
                          ),
                        ]),
                        SizedBox(width: ResponsiveUtils.scaledSize(context, 12)),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.name,
                                    style: AppFonts.display(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        context: context)),
                                SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
                                Text(
                                    '★ ${t.rating}  ·  ${t.experience}  ·  ${t.jobs} jobs',
                                    style: AppFonts.body(
                                        fontSize: 11,
                                        color: AppColors.muted,
                                        context: context)),
                              ]),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(t.eta,
                                  style: AppFonts.display(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      context: context)),
                              SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
                              Text(t.distance,
                                  style: AppFonts.body(
                                      fontSize: 10,
                                      color: AppColors.muted,
                                      context: context)),
                            ]),
                      ]),
                    ),
                  ),
                );
              }),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
              _CtaButton(
                label: 'Confirm $_selectedTech →',
                enabled: true,
                onTap: () => widget.state.go('s5'),
                color: AppColors.red,
                fullWidth: true,
                margin: EdgeInsets.zero,
              ),
            ]),
          ),
        ]),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════
//  SCREEN 5 – CONFIRMED / TRACKING
// ═══════════════════════════════════════════
class Screen5Confirmed extends StatefulWidget {
  final AppState state;
  const Screen5Confirmed({super.key, required this.state});

  @override
  State<Screen5Confirmed> createState() => _Screen5ConfirmedState();
}

class _Screen5ConfirmedState extends State<Screen5Confirmed>
    with SingleTickerProviderStateMixin {
  late AnimationController _moveCtrl;

  @override
  void initState() {
    super.initState();
    _moveCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _moveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    return Column(children: [
      Expanded(
        child: Container(
          color: const Color(0xFF0E0E0E),
          child: Stack(children: [
            CustomPaint(painter: _GridPainter(), child: const SizedBox.expand()),
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.2),
                  colors: [
                    AppColors.green.withValues(alpha: 0.06),
                    Colors.transparent
                  ],
                  radius: 0.6,
                ),
              ),
            ),
            Positioned(
              top: 16, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.scaledPadding(context, 14), vertical: ResponsiveUtils.scaledPadding(context, 6)),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 20)),
                    border: Border.all(
                        color: AppColors.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const _LiveDot(),
                    SizedBox(width: ResponsiveUtils.scaledSize(context, 6)),
                    Text('${s.pickedTechName} is on the way',
                        style: AppFonts.display(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green)),
                  ]),
                ),
              ),
            ),
            const Positioned.fill(child: _RoutePainterWidget()),
            Positioned(
              top: ResponsiveUtils.scaledSize(context, 16),
              left: ResponsiveUtils.scaledSize(context, 18),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint('Live track back tapped');
                  widget.state.go('s4');
                },
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(
                      ResponsiveUtils.scaledSize(context, 16)),
                  elevation: 6,
                  shadowColor: Colors.black.withValues(alpha: 0.14),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.scaledSize(context, 12),
                        vertical: ResponsiveUtils.scaledSize(context, 10)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.arrow_back_ios_new,
                          color: AppColors.black, size: ResponsiveUtils.scaledSize(context, 18)),
                      SizedBox(width: ResponsiveUtils.scaledSize(context, 6)),
                      Text('Back',
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ]),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _moveCtrl,
              builder: (_, child) {
                final t = _moveCtrl.value;
                return Positioned(
                  left: MediaQuery.of(context).size.width * 0.28 + t * 8,
                  top: 150 + t * 6,
                  child: Column(children: [
                    Container(
                      width: ResponsiveUtils.scaledSize(context, 38), height: ResponsiveUtils.scaledSize(context, 38),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.green, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.green.withValues(alpha: 0.35),
                              blurRadius: 12)
                        ],
                      ),
                      child: Center(
                          child: Text('👨‍🔧',
                              style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 18))),
                    ),
                    SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.scaledPadding(context, 7), vertical: ResponsiveUtils.scaledPadding(context, 2)),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 10)),
                      ),
                      child: Text(
                          '${s.pickedTechName.split(' ')[0]} · 0.8 km',
                          style: AppFonts.body(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ]),
                );
              },
            ),
            Positioned(
              bottom: 50, left: 175,
              child: Container(
                width: ResponsiveUtils.scaledSize(context, 14), height: ResponsiveUtils.scaledSize(context, 14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.red,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.red.withValues(alpha: 0.5),
                        blurRadius: 8)
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
      Container(
        color: AppColors.white,
        padding: EdgeInsets.only(bottom: ResponsiveUtils.scaledPadding(context, 28)),
        child: Column(children: [
          Container(
            width: ResponsiveUtils.scaledSize(context, 36), height: ResponsiveUtils.scaledSize(context, 4),
            margin: EdgeInsets.symmetric(vertical: ResponsiveUtils.scaledPadding(context, 12)),
            decoration: BoxDecoration(
                color: AppColors.off2,
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 2))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 18)),
            child: Material(
              color: AppColors.off,
              borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 16)),
                onTap: () => widget.state.go('s4'),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.scaledPadding(context, 16), vertical: ResponsiveUtils.scaledPadding(context, 14)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.arrow_back_ios_new,
                        color: AppColors.black, size: ResponsiveUtils.scaledSize(context, 18)),
                    SizedBox(width: ResponsiveUtils.scaledSize(context, 8)),
                    Text('Back',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        )),
                  ]),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 12)),
          Padding(
            padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 0), ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 16)),
            child: Row(children: [
              Container(
                width: ResponsiveUtils.scaledSize(context, 52), height: ResponsiveUtils.scaledSize(context, 52),
                decoration: BoxDecoration(
                    color: AppColors.off,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.off2, width: 2)),
                child: Center(
                    child: Text('👨‍🔧', style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 26))),
                ),
              ),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 12)),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.pickedTechName,
                          style: AppFonts.display(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              context: context)),
                      SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
                      Row(children: [
                        const Text('★',
                            style: TextStyle(
                                color: AppColors.yellow, fontSize: 14)),
                        Text(
                            ' ${s.pickedRating}  ·  5+ yrs exp.  ·  Verified',
                            style: AppFonts.body(
                                fontSize: 12,
                                color: AppColors.muted,
                                context: context)),
                      ]),
                    ]),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.scaledPadding(context, 13), vertical: ResponsiveUtils.scaledPadding(context, 8)),
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 12))),
                child: Column(children: [
                  Text(s.pickedEta,
                      style: AppFonts.display(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          context: context)),
                  Text('MIN AWAY',
                      style: AppFonts.body(
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: 0.4))),
                ]),
              ),
            ]),
          ),
          const Divider(color: AppColors.border, height: 1),
          Container(
            margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 18), vertical: ResponsiveUtils.scaledPadding(context, 14)),
            padding: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 16)),
            decoration: BoxDecoration(
                color: AppColors.off,
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18))),
            child: Column(children: [
              _SummaryRow(
                  label: 'Device',
                  value: s.selBrand.isNotEmpty
                      ? '${s.selBrand} ${s.selModel}'
                      : '—'),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 8)),
              _SummaryRow(
                  label: 'Services',
                  value: s.selIssues.isNotEmpty
                      ? s.selIssues.map((i) => i.name).join(', ')
                      : '—'),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 8)),
              const _SummaryRow(label: 'Location', value: 'Kondapur, Hyd'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.scaledPadding(context, 8)),
                child: const Divider(color: AppColors.border, height: 1),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: AppFonts.display(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            context: context)),
                    Text('₹${s.total}',
                        style: AppFonts.display(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            context: context)),
                  ]),
            ]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 18)),
            child: Row(children: [
              Expanded(
                  child: _ActionButton(
                      icon: '📞', label: 'Call', onTap: () {})),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 8)),
              Expanded(
                  child: _ActionButton(
                      icon: '💬', label: 'Chat', onTap: () {})),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 8)),
              Expanded(
                flex: 2,
                child: _CtaButton(
                  label: '📍 Live Track',
                  enabled: true,
                  onTap: () {},
                  color: AppColors.red,
                  fullWidth: true,
                  margin: EdgeInsets.zero,
                ),
              ),
            ]),
          ),
        ]),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════
//  SCREEN: ORDERS
// ═══════════════════════════════════════════
class ScreenOrders extends StatefulWidget {
  final AppState state;
  const ScreenOrders({super.key, required this.state});

  @override
  State<ScreenOrders> createState() => _ScreenOrdersState();
}

class _ScreenOrdersState extends State<ScreenOrders> {
  String _filter = 'all';

  List<Order> get _filtered {
    if (_filter == 'all') return widget.state.orders;
    return widget.state.orders
        .where((o) => o.status == _filter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(children: [
      Container(
        color: AppColors.black,
        padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 20), ResponsiveUtils.scaledPadding(context, 14), ResponsiveUtils.scaledPadding(context, 20), ResponsiveUtils.scaledPadding(context, 0)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const _Logo(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 10), vertical: ResponsiveUtils.scaledPadding(context, 4)),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 20)),
                border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
              ),
              child: Text('${widget.state.orders.length} orders',
                  style: AppFonts.body(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.red)),
            ),
          ]),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 16)),
          Text('My Orders',
              style: AppFonts.display(
                  fontSize: 23, color: Colors.white, context: context)),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
          Text('Track & manage your repairs',
              style: AppFonts.body(
                  fontSize: 12, color: const Color(0x61FFFFFF))),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 16)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _FilterChip(
                  label: 'All',
                  active: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all')),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 8)),
              _FilterChip(
                  label: 'Completed',
                  active: _filter == 'completed',
                  onTap: () => setState(() => _filter = 'completed')),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 8)),
              _FilterChip(
                  label: 'Cancelled',
                  active: _filter == 'cancelled',
                  onTap: () => setState(() => _filter = 'cancelled')),
            ]),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 16)),
        ]),
      ),
      Expanded(
        child: filtered.isEmpty
            ? Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('📦', style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 48))),
                      SizedBox(height: ResponsiveUtils.scaledSize(context, 12)),
                      Text('No orders found',
                          style: AppFonts.display(
                              fontSize: 16,
                              color: AppColors.muted,
                              context: context)),
                      SizedBox(height: ResponsiveUtils.scaledSize(context, 6)),
                      Text('Book a repair to see it here',
                          style: AppFonts.body(
                              fontSize: 13,
                              color: AppColors.muted.withValues(alpha: 0.6))),
                    ]),
              )
            : ListView.separated(
                padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 18), ResponsiveUtils.scaledPadding(context, 10)),
                itemCount: filtered.length,
                separatorBuilder: (_, index) => SizedBox(height: ResponsiveUtils.scaledSize(context, 12)),
                itemBuilder: (_, i) => _OrderCard(order: filtered[i]),
              ),
      ),
      _BottomNav(
        activeIndex: 2,
        onTap: (i) {
          if (i == 0) {
            widget.state.go('s1');
          } else if (i == 1) {
            widget.state.go('s2');
          } else if (i == 3) {
            widget.state.go('profile');
          }
        },
      ),
    ]);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 14), vertical: ResponsiveUtils.scaledPadding(context, 6)),
        decoration: BoxDecoration(
          color: active ? AppColors.red : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 20)),
          border: Border.all(
              color: active
                  ? AppColors.red
                  : Colors.white.withValues(alpha: 0.12)),
        ),
        child: Text(label,
            style: AppFonts.body(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6))),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  Color get _statusColor => switch (order.status) {
        'completed'   => AppColors.green,
        'in_progress' => AppColors.yellow,
        _             => AppColors.muted,
      };

  String get _statusLabel => switch (order.status) {
        'completed'   => '✓  Completed',
        'in_progress' => '⏱  In Progress',
        _             => '✕  Cancelled',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.off,
        borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18)),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(order.id,
              style: AppFonts.label(
                  color: AppColors.muted, fontSize: 10, context: context)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 10), vertical: ResponsiveUtils.scaledPadding(context, 3)),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 20)),
              border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(_statusLabel,
                style: AppFonts.body(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _statusColor)),
          ),
        ]),
        SizedBox(height: ResponsiveUtils.scaledSize(context, 10)),
        Row(children: [
          Text('📱', style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 18))),
          SizedBox(width: ResponsiveUtils.scaledSize(context, 10)),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${order.brand} ${order.model}',
                  style: AppFonts.display(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      context: context)),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
              Text(order.issues.join(' · '),
                  style: AppFonts.body(
                      fontSize: 11, color: AppColors.muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ]),
          ),
          Text('₹${order.total}',
              style: AppFonts.display(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                  context: context)),
        ]),
        SizedBox(height: ResponsiveUtils.scaledSize(context, 12)),
        const Divider(color: AppColors.border, height: 1),
        SizedBox(height: ResponsiveUtils.scaledSize(context, 10)),
        Row(children: [
          Container(
            width: ResponsiveUtils.scaledSize(context, 26), height: ResponsiveUtils.scaledSize(context, 26),
            decoration: BoxDecoration(
                color: AppColors.off2, shape: BoxShape.circle),
            child: Center(
                child: Text('👨‍🔧', style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 13))),
            ),
          ),
          SizedBox(width: ResponsiveUtils.scaledSize(context, 8)),
          Text(order.techName,
              style: AppFonts.body(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black)),
          const Spacer(),
          Text(order.date,
              style: AppFonts.body(fontSize: 11, color: AppColors.muted)),
        ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════
//  SCREEN: PROFILE
// ═══════════════════════════════════════════
class ScreenProfile extends StatelessWidget {
  final AppState state;
  const ScreenProfile({super.key, required this.state});

  static const _menuItems = [
    _ProfileMenuItem(icon: '✏️', label: 'Edit Profile',
        sub: 'Name, phone, address'),
    _ProfileMenuItem(icon: '📍', label: 'My Addresses',
        sub: 'Home, work & saved locations'),
    _ProfileMenuItem(icon: '🔔', label: 'Notifications',
        sub: 'Alerts, updates & offers'),
    _ProfileMenuItem(icon: '💳', label: 'Payment Methods',
        sub: 'Cards, UPI & wallets'),
    _ProfileMenuItem(icon: '🆘', label: 'Help & Support',
        sub: 'Chat with us 24/7'),
    _ProfileMenuItem(icon: 'ℹ️', label: 'About Fix-N-Go',
        sub: 'Version 1.0.0'),
  ];

  @override
  Widget build(BuildContext context) {
    final completedCount =
        state.orders.where((o) => o.status == 'completed').length;
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: AppColors.black,
              padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 24), ResponsiveUtils.scaledPadding(context, 16), ResponsiveUtils.scaledPadding(context, 24), ResponsiveUtils.scaledPadding(context, 28)),
              child: Column(children: [
                Align(alignment: Alignment.topLeft, child: const _Logo()),
                SizedBox(height: ResponsiveUtils.scaledSize(context, 26)),
                Stack(alignment: Alignment.center, children: [
                  Container(
                    width: ResponsiveUtils.scaledSize(context, 82), height: ResponsiveUtils.scaledSize(context, 82),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.red, width: 2.5),
                    ),
                    child: Center(
                        child: Text('👤',
                            style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 36))),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: ResponsiveUtils.scaledSize(context, 26), height: ResponsiveUtils.scaledSize(context, 26),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.black, width: 2),
                      ),
                      child: Center(
                          child: Icon(Icons.edit,
                              color: Colors.white, size: ResponsiveUtils.scaledSize(context, 12))),
                    ),
                  ),
                ]),
                SizedBox(height: ResponsiveUtils.scaledSize(context, 14)),
                Text(state.userName,
                    style: AppFonts.display(
                        fontSize: 20,
                        color: Colors.white,
                        context: context)),
                SizedBox(height: ResponsiveUtils.scaledSize(context, 4)),
                Text(state.userEmail,
                    style: AppFonts.body(
                        fontSize: 12,
                        color: const Color(0x70FFFFFF))),
                SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
                Text(state.userPhone,
                    style: AppFonts.body(
                        fontSize: 12,
                        color: const Color(0x50FFFFFF))),
                SizedBox(height: ResponsiveUtils.scaledSize(context, 20)),
                Container(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.scaledPadding(context, 14)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 16)),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(children: [
                    _StatItem(value: '$completedCount', label: 'Repairs'),
                    _VertDivider(),
                    const _StatItem(value: '⭐ 4.8', label: 'Avg Rating'),
                    _VertDivider(),
                    const _StatItem(value: '6 mo', label: 'Member'),
                  ]),
                ),
              ]),
            ),
            Container(
              color: AppColors.white,
              child: Column(children: [
                SizedBox(height: ResponsiveUtils.scaledSize(context, 8)),
                ..._menuItems.map((item) => Column(children: [
                      _ProfileMenuTile(item: item),
                        Divider(
                          color: AppColors.border,
                          height: ResponsiveUtils.scaledSize(context, 1),
                          indent: 74,
                          endIndent: 20),
                    ])),
                const Divider(color: AppColors.border, height: 1),
                GestureDetector(
                  onTap: () => state.logout(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.scaledPadding(context, 20), vertical: ResponsiveUtils.scaledPadding(context, 16)),
                    child: Row(children: [
                      Container(
                        width: ResponsiveUtils.scaledSize(context, 40), height: ResponsiveUtils.scaledSize(context, 40),
                        decoration: BoxDecoration(
                          color: AppColors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 12)),
                        ),
                        child: Center(
                            child: Text('🚪',
                                style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 18))),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.scaledSize(context, 14)),
                      Text('Logout',
                          style: AppFonts.display(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                              context: context)),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: ResponsiveUtils.scaledSize(context, 14), color: AppColors.red),
                    ]),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.scaledSize(context, 8)),
              ]),
            ),
          ]),
        ),
      ),
      _BottomNav(
        activeIndex: 3,
        onTap: (i) {
          if (i == 0) {
            state.go('s1');
          } else if (i == 1) {
            state.go('s2');
          } else if (i == 2) {
            state.go('orders');
          }
        },
      ),
    ]);
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value,
            style: AppFonts.display(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                context: context)),
        SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
        Text(label,
            style: AppFonts.body(
                fontSize: 10, color: const Color(0x60FFFFFF))),
      ]),
    );
  }
}

class _VertDivider extends StatelessWidget {
  const _VertDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: ResponsiveUtils.scaledSize(context, 1), height: ResponsiveUtils.scaledSize(context, 30), color: Colors.white.withValues(alpha: 0.12));
}

class _ProfileMenuItem {
  final String icon, label, sub;
  const _ProfileMenuItem(
      {required this.icon, required this.label, required this.sub});
}

class _ProfileMenuTile extends StatelessWidget {
  final _ProfileMenuItem item;
  const _ProfileMenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 20), vertical: ResponsiveUtils.scaledPadding(context, 10)),
        child: Row(children: [
          Container(
            width: ResponsiveUtils.scaledSize(context, 40), height: ResponsiveUtils.scaledSize(context, 40),
            decoration: BoxDecoration(
                color: AppColors.off,
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 12))),
            child: Center(
                child: Text(item.icon,
                    style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 18))),
            ),
          ),
          SizedBox(width: ResponsiveUtils.scaledSize(context, 14)),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.label,
                  style: AppFonts.display(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      context: context)),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 1)),
              Text(item.sub,
                  style: AppFonts.body(fontSize: 11, color: AppColors.muted)),
            ]),
          ),
          Icon(Icons.arrow_forward_ios,
              size: ResponsiveUtils.scaledSize(context, 14), color: AppColors.muted),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  SHARED PAINTER WIDGETS
// ═══════════════════════════════════════════
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _UserPing extends StatelessWidget {
  final AnimationController ctrl;
  const _UserPing({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveUtils.scaledSize(context, 90), height: ResponsiveUtils.scaledSize(context, 90),
      child: Stack(alignment: Alignment.center, children: [
        AnimatedBuilder(
          animation: ctrl,
          builder: (_, child) => Container(
            width: 90 * ctrl.value + 10,
            height: 90 * ctrl.value + 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.red
                      .withValues(alpha: 0.35 * (1 - ctrl.value)),
                  width: 1.5),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: ctrl,
          builder: (_, child) {
            final v2 = (ctrl.value + 0.3) % 1.0;
            return Container(
              width: 60 * v2 + 10,
              height: 60 * v2 + 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.red.withValues(alpha: 0.25 * (1 - v2)),
                    width: 1),
              ),
            );
          },
        ),
        Container(
          width: ResponsiveUtils.scaledSize(context, 14), height: ResponsiveUtils.scaledSize(context, 14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.red,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                  color: AppColors.red.withValues(alpha: 0.5), blurRadius: 8)
            ],
          ),
        ),
      ]),
    );
  }
}

class _RoamingDot extends StatelessWidget {
  final AnimationController ctrl;
  final String emoji, km;
  final double left, top, delay;
  const _RoamingDot(
      {required this.ctrl,
      required this.emoji,
      required this.km,
      required this.left,
      required this.top,
      required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, child) {
        final t = (ctrl.value + delay) % 1.0;
        return Positioned(
          left: MediaQuery.of(context).size.width * left +
              sin(t * pi * 2) * 5,
          top: 200 * top + cos(t * pi * 2) * 4,
          child: Column(children: [
            Container(
              width: ResponsiveUtils.scaledSize(context, 36), height: ResponsiveUtils.scaledSize(context, 36),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.green, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.green.withValues(alpha: 0.3),
                      blurRadius: 10)
                ],
              ),
              child: Center(
                  child: Text(emoji,
                      style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 16))),
              ),
            ),
            SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 6), vertical: ResponsiveUtils.scaledPadding(context, 2)),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 10)),
              ),
              child: Text(km,
                  style: AppFonts.body(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ]),
        );
      },
    );
  }
}

class _PulseDot extends StatefulWidget {
  final double delay;
  const _PulseDot({required this.delay});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: ResponsiveUtils.scaledPadding(context, 4)),
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _c2) => Container(
          width: ResponsiveUtils.scaledSize(context, 6), height: ResponsiveUtils.scaledSize(context, 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.red.withValues(alpha: 0.3 + 0.7 * _c.value),
          ),
        ),
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _c2) => Container(
        width: ResponsiveUtils.scaledSize(context, 7), height: ResponsiveUtils.scaledSize(context, 7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.green.withValues(alpha: 0.3 + 0.7 * _c.value),
        ),
      ),
    );
  }
}

class _RoutePainterWidget extends StatelessWidget {
  const _RoutePainterWidget();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _RoutePainter());
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.red.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.5,
          size.width * 0.5, size.height * 0.85);

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    var distance = 0.0;
    for (final pm in path.computeMetrics()) {
      while (distance < pm.length) {
        canvas.drawPath(pm.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ═══════════════════════════════════════════
//  COMMON UI COMPONENTS
// ═══════════════════════════════════════════
class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppFonts.body(
                  fontSize: 12, color: AppColors.muted, context: context)),
          SizedBox(width: ResponsiveUtils.scaledSize(context, 12)),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: AppFonts.body(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    context: context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ]);
  }
}

class _ActionButton extends StatelessWidget {
  final String icon, label;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.scaledPadding(context, 13)),
        decoration: BoxDecoration(
          color: AppColors.off,
          borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 12)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(icon, style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 14))),
          SizedBox(width: ResponsiveUtils.scaledSize(context, 6)),
          Text(label,
              style: AppFonts.display(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  context: context)),
        ]),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.arrow_back_ios_new, color: Colors.white, size: ResponsiveUtils.scaledSize(context, 14)),
        SizedBox(width: ResponsiveUtils.scaledSize(context, 6)),
        Text('Back',
            style: AppFonts.body(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.5))),
      ]),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int steps, active;
  const _ProgressBar({required this.steps, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps, (index) {
        final isActive = index == active;
        final isDone   = index < active;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: ResponsiveUtils.scaledPadding(context, 4)),
            height: ResponsiveUtils.scaledSize(context, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 2)),
              color: isActive
                  ? AppColors.red
                  : (isDone
                      ? AppColors.green.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.15)),
            ),
          ),
        );
      }),
    );
  }
}

class _SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchInput(
      {required this.controller,
      required this.hint,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.off,
        borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppFonts.body(fontSize: 14, color: AppColors.black, context: context),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search_rounded,
              color: AppColors.muted, size: ResponsiveUtils.scaledSize(context, 20)),
          hintText: hint,
          hintStyle: AppFonts.body(
              fontSize: 14, color: AppColors.muted, context: context),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.scaledPadding(context, 14), horizontal: ResponsiveUtils.scaledPadding(context, 16)),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final Color color;
  final bool fullWidth;
  final EdgeInsets? margin;
  const _CtaButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.color = AppColors.black,
    this.fullWidth = false,
    this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btn = Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 16)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18))),
          elevation: 0,
        ),
        onPressed: enabled ? onTap : null,
        child: Text(label,
            style: AppFonts.display(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                context: context)),
      ),
    );
    final resolvedMargin = margin ?? EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 18), vertical: ResponsiveUtils.scaledPadding(context, 22));
    if (fullWidth) {
      return Padding(
        padding: resolvedMargin,
        child: SizedBox(width: double.infinity, child: btn),
      );
    }
    return Padding(
      padding: resolvedMargin,
      child: SizedBox(width: double.infinity, child: btn),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('Fix',
          style: AppFonts.display(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              context: context)),
      Text('-N-',
          style: AppFonts.display(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.red,
              context: context)),
      Text('Go',
          style: AppFonts.display(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              context: context)),
    ]);
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.scaledPadding(context, 12)),
      child: Text(
        label.toUpperCase(),
        style: AppFonts.label(
            color: AppColors.muted, fontSize: 10, context: context),
      ),
    );
  }
}

// ─── Service card data ───────────────────
enum _SvcStyle { dark, red, light, blue }

class _ServiceCard {
  final String emoji, name, desc, price;
  final _SvcStyle style;
  const _ServiceCard(
      {required this.emoji,
      required this.name,
      required this.desc,
      required this.price,
      required this.style});
}

// ─── _ScaleTap: press-scale animation ───
class _ScaleTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _ScaleTap({required this.child, required this.onTap});

  @override
  State<_ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<_ScaleTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}

// ─── _ServiceTile ────────────────────────
class _ServiceTile extends StatelessWidget {
  final _ServiceCard card;
  final VoidCallback onTap;
  const _ServiceTile({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = card.style == _SvcStyle.dark ||
        card.style == _SvcStyle.red ||
        card.style == _SvcStyle.blue;

    final Color bg;
    final Color textCol;
    final Color descCol;

    switch (card.style) {
      case _SvcStyle.dark:
        bg = AppColors.black;
        textCol = Colors.white;
        descCol = Colors.white.withValues(alpha: 0.55);
      case _SvcStyle.red:
        bg = AppColors.red;
        textCol = Colors.white;
        descCol = Colors.white.withValues(alpha: 0.55);
      case _SvcStyle.blue:
        bg = AppColors.blue;
        textCol = Colors.white;
        descCol = Colors.white.withValues(alpha: 0.55);
      case _SvcStyle.light:
        bg = AppColors.off;
        textCol = AppColors.black;
        descCol = AppColors.muted;
    }

    return _ScaleTap(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.scaledPadding(context, 10)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(card.emoji, style: TextStyle(fontSize: ResponsiveUtils.scaledSize(context, 22))),
                Text('↗',
                    style: TextStyle(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.35)
                            : AppColors.muted,
                        fontSize: 12)),
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(card.name,
                  style: AppFonts.display(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textCol,
                      context: context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
              Text(card.desc,
                  style: AppFonts.body(
                      fontSize: 9,
                      color: descCol,
                      height: ResponsiveUtils.scaledSize(context, 1.3),
                      context: context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
              Text(card.price,
                  style: AppFonts.body(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? textCol.withValues(alpha: 0.75)
                          : AppColors.blue,
                      context: context)),
            ]),
          ],
        ),
      ),
    );
  }
}

// ─── Activity feed ───────────────────────
class _ActivityItem {
  final String when, model, what;
  const _ActivityItem(
      {required this.when, required this.model, required this.what});
}

class _ActivityCard extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveUtils.scaledSize(context, 160),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 14), vertical: ResponsiveUtils.scaledPadding(context, 11)),
        decoration: BoxDecoration(
          color: AppColors.off,
          borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.when,
                style: AppFonts.body(
                    fontSize: 10,
                    color: AppColors.muted,
                    context: context)),
            SizedBox(height: ResponsiveUtils.scaledSize(context, 3)),
            Text(item.model,
                style: AppFonts.display(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    context: context)),
            SizedBox(height: ResponsiveUtils.scaledSize(context, 1)),
            Row(children: [
              Container(
                width: ResponsiveUtils.scaledSize(context, 6), height: ResponsiveUtils.scaledSize(context, 6),
                decoration: BoxDecoration(
                    color: AppColors.green, shape: BoxShape.circle),
              ),
              SizedBox(width: ResponsiveUtils.scaledSize(context, 4)),
              Expanded(
                child: Text(item.what,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.body(
                        fontSize: 11,
                        color: AppColors.muted,
                        context: context)),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Navigation ───────────────────
class _BottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.activeIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(ResponsiveUtils.scaledPadding(context, 0), ResponsiveUtils.scaledPadding(context, 8), ResponsiveUtils.scaledPadding(context, 0), ResponsiveUtils.scaledPadding(context, 20)),
      decoration: BoxDecoration(
        color: AppColors.black,
        border: Border(top: BorderSide(color: Color(0xFF1E1E1E), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(emoji: '🏠', label: 'Home',
              active: activeIndex == 0, onTap: () => onTap(0)),
          _NavItem(emoji: '🔧', label: 'Book',
              active: activeIndex == 1, onTap: () => onTap(1)),
          _NavItem(emoji: '📦', label: 'Orders',
              active: activeIndex == 2, onTap: () => onTap(2)),
          _NavItem(emoji: '👤', label: 'Profile',
              active: activeIndex == 3, onTap: () => onTap(3)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String emoji, label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem(
      {required this.emoji,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 12), vertical: ResponsiveUtils.scaledPadding(context, 4)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.scaledPadding(context, 10), vertical: ResponsiveUtils.scaledPadding(context, 4)),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.red.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(ResponsiveUtils.scaledSize(context, 10)),
            ),
            child: Text(emoji,
                style: TextStyle(fontSize: active ? 22 : 20)),
          ),
          SizedBox(height: ResponsiveUtils.scaledSize(context, 2)),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppFonts.body(
                fontSize: active ? 11 : 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active
                    ? AppColors.red
                    : Colors.white.withValues(alpha: 0.4),
                letterSpacing: 0.1,
                context: context),
            child: Text(label),
          ),
        ]),
      ),
    );
  }
}
