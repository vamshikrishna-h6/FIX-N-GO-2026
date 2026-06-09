import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const delegate = _AppLocalizationsDelegate();

  static const List<String> supportedLanguageCodes = [
    'en', 'hi', 'te', 'ta', 'kn', 'ml', 'mr', 'bn'
  ];

  // All translation strings
  static const Map<String, Map<String, String>> _strings = {
    // ── English ─────────────────────────────────────────────────────────────
    'en': {
      'app_name': 'Fix-N-Go',
      'language': 'Language',
      'select_language': 'Select Language',
      'apply': 'Apply',

      // Auth
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'full_name': 'Full Name',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'logout': 'Log Out',

      // Home
      'hi_greeting': 'Hi',
      'find_service': 'Find a Service',
      'our_services': 'Our Services',
      'popular_services': 'Popular Services',
      'book_repair': 'Book a Repair',
      'track_order': 'Track Order',
      'my_orders': 'My Orders',
      'profile': 'Profile',
      'home': 'Home',
      'search_placeholder': 'Search for a service...',
      'view_all': 'View All',
      'available_technicians': 'Available Technicians',
      'min_away': 'min away',

      // Services
      'screen_replacement': 'Screen Replacement',
      'battery_repair': 'Battery Repair',
      'camera_repair': 'Camera Repair',
      'software_fix': 'Software Fix',
      'select_device': 'Select Device',
      'select_brand': 'Select Brand',
      'select_issue': 'Select Issue',
      'book_now': 'Book Now',
      'price': 'Price',
      'total': 'Total',
      'estimated_time': 'Estimated Time',

      // Orders
      'orders': 'Orders',
      'active_orders': 'Active Orders',
      'past_orders': 'Past Orders',
      'order_id': 'Order ID',
      'order_status': 'Status',
      'pending': 'Pending',
      'assigned': 'Assigned',
      'in_progress': 'In Progress',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'no_orders': 'No orders yet',
      'view_details': 'View Details',

      // Profile
      'personal_info': 'Personal Info',
      'saved_addresses': 'Saved Addresses',
      'payment_methods': 'Payment Methods',
      'notifications': 'Notifications',
      'help_faq': 'Help & FAQ',
      'chat_support': 'Chat with Support',
      'rate_app': 'Rate the App',
      'account': 'Account',
      'support': 'Support',
      'preferences': 'Preferences',
      'repairs': 'Repairs',
      'saved': 'Saved',
      'rating': 'Rating',

      // Common
      'save': 'Save',
      'cancel': 'Cancel',
      'ok': 'OK',
      'back': 'Back',
      'loading': 'Loading...',
      'error': 'Something went wrong',
      'retry': 'Retry',
      'success': 'Success',
      'name': 'Name',
      'phone': 'Phone',
      'address': 'Address',
      'city': 'City',
      'pincode': 'Pincode',
      'submit': 'Submit',
      'version': 'Fix-N-Go v1.0.0',
    },

    // ── Hindi ───────────────────────────────────────────────────────────────
    'hi': {
      'app_name': 'Fix-N-Go',
      'language': 'भाषा',
      'select_language': 'भाषा चुनें',
      'apply': 'लागू करें',

      'login': 'लॉगिन',
      'register': 'पंजीकरण',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'full_name': 'पूरा नाम',
      'confirm_password': 'पासवर्ड की पुष्टि करें',
      'forgot_password': 'पासवर्ड भूल गए?',
      'dont_have_account': 'खाता नहीं है?',
      'already_have_account': 'पहले से खाता है?',
      'sign_in': 'साइन इन',
      'sign_up': 'साइन अप',
      'logout': 'लॉग आउट',

      'hi_greeting': 'नमस्ते',
      'find_service': 'सेवा खोजें',
      'our_services': 'हमारी सेवाएं',
      'popular_services': 'लोकप्रिय सेवाएं',
      'book_repair': 'मरम्मत बुक करें',
      'track_order': 'ऑर्डर ट्रैक करें',
      'my_orders': 'मेरे ऑर्डर',
      'profile': 'प्रोफ़ाइल',
      'home': 'होम',
      'search_placeholder': 'सेवा खोजें...',
      'view_all': 'सभी देखें',
      'available_technicians': 'उपलब्ध तकनीशियन',
      'min_away': 'मिनट दूर',

      'screen_replacement': 'स्क्रीन बदलना',
      'battery_repair': 'बैटरी मरम्मत',
      'camera_repair': 'कैमरा मरम्मत',
      'software_fix': 'सॉफ्टवेयर सुधार',
      'select_device': 'डिवाइस चुनें',
      'select_brand': 'ब्रांड चुनें',
      'select_issue': 'समस्या चुनें',
      'book_now': 'अभी बुक करें',
      'price': 'मूल्य',
      'total': 'कुल',
      'estimated_time': 'अनुमानित समय',

      'orders': 'ऑर्डर',
      'active_orders': 'सक्रिय ऑर्डर',
      'past_orders': 'पुराने ऑर्डर',
      'order_id': 'ऑर्डर आईडी',
      'order_status': 'स्थिति',
      'pending': 'लंबित',
      'assigned': 'असाइन किया गया',
      'in_progress': 'जारी है',
      'completed': 'पूर्ण',
      'cancelled': 'रद्द',
      'no_orders': 'कोई ऑर्डर नहीं',
      'view_details': 'विवरण देखें',

      'personal_info': 'व्यक्तिगत जानकारी',
      'saved_addresses': 'सहेजे गए पते',
      'payment_methods': 'भुगतान के तरीके',
      'notifications': 'सूचनाएं',
      'help_faq': 'सहायता और FAQ',
      'chat_support': 'सहायता से चैट करें',
      'rate_app': 'ऐप को रेट करें',
      'account': 'खाता',
      'support': 'सहायता',
      'preferences': 'प्राथमिकताएं',
      'repairs': 'मरम्मत',
      'saved': 'बचत',
      'rating': 'रेटिंग',

      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'ok': 'ठीक है',
      'back': 'वापस',
      'loading': 'लोड हो रहा है...',
      'error': 'कुछ गलत हुआ',
      'retry': 'पुनः प्रयास',
      'success': 'सफलता',
      'name': 'नाम',
      'phone': 'फ़ोन',
      'address': 'पता',
      'city': 'शहर',
      'pincode': 'पिनकोड',
      'submit': 'जमा करें',
      'version': 'Fix-N-Go v1.0.0',
    },

    // ── Telugu ───────────────────────────────────────────────────────────────
    'te': {
      'app_name': 'Fix-N-Go',
      'language': 'భాష',
      'select_language': 'భాష ఎంచుకోండి',
      'apply': 'వర్తించు',

      'login': 'లాగిన్',
      'register': 'నమోదు',
      'email': 'ఇమెయిల్',
      'password': 'పాస్‌వర్డ్',
      'full_name': 'పూర్తి పేరు',
      'confirm_password': 'పాస్‌వర్డ్ నిర్ధారించండి',
      'forgot_password': 'పాస్‌వర్డ్ మర్చిపోయారా?',
      'dont_have_account': 'ఖాతా లేదా?',
      'already_have_account': 'ఇప్పటికే ఖాతా ఉందా?',
      'sign_in': 'సైన్ ఇన్',
      'sign_up': 'సైన్ అప్',
      'logout': 'లాగ్ అవుట్',

      'hi_greeting': 'నమస్కారం',
      'find_service': 'సేవ కనుగొనండి',
      'our_services': 'మా సేవలు',
      'popular_services': 'ప్రముఖ సేవలు',
      'book_repair': 'రిపేర్ బుక్ చేయండి',
      'track_order': 'ఆర్డర్ ట్రాక్ చేయండి',
      'my_orders': 'నా ఆర్డర్‌లు',
      'profile': 'ప్రొఫైల్',
      'home': 'హోమ్',
      'search_placeholder': 'సేవ వెతకండి...',
      'view_all': 'అన్నీ చూడండి',
      'available_technicians': 'అందుబాటులో ఉన్న టెక్నీషియన్లు',
      'min_away': 'నిమిషాల దూరం',

      'screen_replacement': 'స్క్రీన్ మార్పు',
      'battery_repair': 'బ్యాటరీ రిపేర్',
      'camera_repair': 'కెమేరా రిపేర్',
      'software_fix': 'సాఫ్ట్‌వేర్ పరిష్కారం',
      'select_device': 'పరికరం ఎంచుకోండి',
      'select_brand': 'బ్రాండ్ ఎంచుకోండి',
      'select_issue': 'సమస్య ఎంచుకోండి',
      'book_now': 'ఇప్పుడు బుక్ చేయండి',
      'price': 'ధర',
      'total': 'మొత్తం',
      'estimated_time': 'అంచనా సమయం',

      'orders': 'ఆర్డర్‌లు',
      'active_orders': 'క్రియాశీల ఆర్డర్‌లు',
      'past_orders': 'గత ఆర్డర్‌లు',
      'order_id': 'ఆర్డర్ ID',
      'order_status': 'స్థితి',
      'pending': 'పెండింగ్',
      'assigned': 'అసైన్ అయింది',
      'in_progress': 'జరుగుతోంది',
      'completed': 'పూర్తయింది',
      'cancelled': 'రద్దు',
      'no_orders': 'ఆర్డర్‌లు లేవు',
      'view_details': 'వివరాలు చూడండి',

      'personal_info': 'వ్యక్తిగత సమాచారం',
      'saved_addresses': 'సేవ్ చేసిన చిరునామాలు',
      'payment_methods': 'చెల్లింపు పద్ధతులు',
      'notifications': 'నోటిఫికేషన్‌లు',
      'help_faq': 'సహాయం & FAQ',
      'chat_support': 'సపోర్ట్‌తో చాట్',
      'rate_app': 'యాప్‌ను రేట్ చేయండి',
      'account': 'ఖాతా',
      'support': 'సహాయం',
      'preferences': 'ప్రాధాన్యతలు',
      'repairs': 'రిపేర్‌లు',
      'saved': 'ఆదా',
      'rating': 'రేటింగ్',

      'save': 'సేవ్ చేయండి',
      'cancel': 'రద్దు చేయండి',
      'ok': 'సరే',
      'back': 'వెనక్కి',
      'loading': 'లోడవుతోంది...',
      'error': 'ఏదో తప్పు జరిగింది',
      'retry': 'మళ్ళీ ప్రయత్నించండి',
      'success': 'విజయం',
      'name': 'పేరు',
      'phone': 'ఫోన్',
      'address': 'చిరునామా',
      'city': 'నగరం',
      'pincode': 'పిన్‌కోడ్',
      'submit': 'సమర్పించండి',
      'version': 'Fix-N-Go v1.0.0',
    },

    // ── Tamil ────────────────────────────────────────────────────────────────
    'ta': {
      'app_name': 'Fix-N-Go',
      'language': 'மொழி',
      'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'apply': 'பயன்படுத்து',

      'login': 'உள்நுழைவு',
      'register': 'பதிவு செய்',
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'full_name': 'முழு பெயர்',
      'confirm_password': 'கடவுச்சொல்லை உறுதிப்படுத்தவும்',
      'forgot_password': 'கடவுச்சொல் மறந்துவிட்டீர்களா?',
      'dont_have_account': 'கணக்கு இல்லையா?',
      'already_have_account': 'ஏற்கனவே கணக்கு உள்ளதா?',
      'sign_in': 'உள் நுழை',
      'sign_up': 'பதிவு செய்',
      'logout': 'வெளியேறு',

      'hi_greeting': 'வணக்கம்',
      'find_service': 'சேவை தேடுங்கள்',
      'our_services': 'எங்கள் சேவைகள்',
      'popular_services': 'பிரபலமான சேவைகள்',
      'book_repair': 'பழுது பதிவு செய்',
      'track_order': 'ஆர்டர் கண்காணி',
      'my_orders': 'என் ஆர்டர்கள்',
      'profile': 'சுயவிவரம்',
      'home': 'முகப்பு',
      'search_placeholder': 'சேவை தேடுங்கள்...',
      'view_all': 'அனைத்தும் காண்க',
      'available_technicians': 'கிடைக்கும் தொழில்நுட்பவியலாளர்கள்',
      'min_away': 'நிமிட தூரம்',

      'screen_replacement': 'திரை மாற்றம்',
      'battery_repair': 'பேட்டரி பழுது',
      'camera_repair': 'கேமரா பழுது',
      'software_fix': 'மென்பொருள் திருத்தம்',
      'select_device': 'சாதனத்தைத் தேர்ந்தெடுக்கவும்',
      'select_brand': 'பிராண்டைத் தேர்ந்தெடுக்கவும்',
      'select_issue': 'சிக்கலைத் தேர்ந்தெடுக்கவும்',
      'book_now': 'இப்போது முன்பதிவு செய்',
      'price': 'விலை',
      'total': 'மொத்தம்',
      'estimated_time': 'மதிப்பிடப்பட்ட நேரம்',

      'orders': 'ஆர்டர்கள்',
      'active_orders': 'செயலில் உள்ள ஆர்டர்கள்',
      'past_orders': 'கடந்த ஆர்டர்கள்',
      'order_id': 'ஆர்டர் ID',
      'order_status': 'நிலை',
      'pending': 'நிலுவையில்',
      'assigned': 'ஒதுக்கப்பட்டது',
      'in_progress': 'நடப்பில்',
      'completed': 'முடிந்தது',
      'cancelled': 'ரத்து',
      'no_orders': 'ஆர்டர்கள் இல்லை',
      'view_details': 'விவரங்களைக் காண்க',

      'personal_info': 'தனிப்பட்ட தகவல்',
      'saved_addresses': 'சேமிக்கப்பட்ட முகவரிகள்',
      'payment_methods': 'கட்டண முறைகள்',
      'notifications': 'அறிவிப்புகள்',
      'help_faq': 'உதவி & FAQ',
      'chat_support': 'ஆதரவுடன் அரட்டை',
      'rate_app': 'ஆப்பை மதிப்பிடுங்கள்',
      'account': 'கணக்கு',
      'support': 'ஆதரவு',
      'preferences': 'விருப்பங்கள்',
      'repairs': 'பழுதுகள்',
      'saved': 'சேமிப்பு',
      'rating': 'மதிப்பீடு',

      'save': 'சேமி',
      'cancel': 'ரத்து செய்',
      'ok': 'சரி',
      'back': 'திரும்பு',
      'loading': 'ஏற்றுகிறது...',
      'error': 'ஏதோ தவறு',
      'retry': 'மீண்டும் முயற்சி',
      'success': 'வெற்றி',
      'name': 'பெயர்',
      'phone': 'தொலைபேசி',
      'address': 'முகவரி',
      'city': 'நகரம்',
      'pincode': 'பின்கோடு',
      'submit': 'சமர்ப்பி',
      'version': 'Fix-N-Go v1.0.0',
    },

    // ── Kannada ──────────────────────────────────────────────────────────────
    'kn': {
      'app_name': 'Fix-N-Go',
      'language': 'ಭಾಷೆ',
      'select_language': 'ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ',
      'apply': 'ಅನ್ವಯಿಸು',
      'login': 'ಲಾಗಿನ್', 'register': 'ನೋಂದಣಿ', 'email': 'ಇಮೇಲ್', 'password': 'ಪಾಸ್‌ವರ್ಡ್',
      'full_name': 'ಪೂರ್ಣ ಹೆಸರು', 'confirm_password': 'ಪಾಸ್‌ವರ್ಡ್ ದೃಢೀಕರಿಸಿ', 'forgot_password': 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿದ್ದೀರಾ?',
      'dont_have_account': 'ಖಾತೆ ಇಲ್ಲವೇ?', 'already_have_account': 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ?', 'sign_in': 'ಸೈನ್ ಇನ್', 'sign_up': 'ಸೈನ್ ಅಪ್', 'logout': 'ಲಾಗ್ ಔಟ್',
      'hi_greeting': 'ನಮಸ್ಕಾರ', 'find_service': 'ಸೇವೆ ಹುಡುಕಿ', 'our_services': 'ನಮ್ಮ ಸೇವೆಗಳು', 'popular_services': 'ಜನಪ್ರಿಯ ಸೇವೆಗಳು',
      'book_repair': 'ದುರಸ್ತಿ ಬುಕ್ ಮಾಡಿ', 'track_order': 'ಆರ್ಡರ್ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ', 'my_orders': 'ನನ್ನ ಆರ್ಡರ್‌ಗಳು', 'profile': 'ಪ್ರೊಫೈಲ್', 'home': 'ಮುಖಪುಟ',
      'search_placeholder': 'ಸೇವೆ ಹುಡುಕಿ...', 'view_all': 'ಎಲ್ಲ ನೋಡಿ', 'available_technicians': 'ಲಭ್ಯವಿರುವ ತಂತ್ರಜ್ಞರು', 'min_away': 'ನಿಮಿಷ ದೂರ',
      'screen_replacement': 'ಸ್ಕ್ರೀನ್ ಬದಲಾಯಿಸುವಿಕೆ', 'battery_repair': 'ಬ್ಯಾಟರಿ ದುರಸ್ತಿ', 'camera_repair': 'ಕ್ಯಾಮೆರಾ ದುರಸ್ತಿ', 'software_fix': 'ಸಾಫ್ಟ್‌ವೇರ್ ಸರಿಪಡಿಸಿ',
      'select_device': 'ಸಾಧನ ಆಯ್ಕೆ ಮಾಡಿ', 'select_brand': 'ಬ್ರಾಂಡ್ ಆಯ್ಕೆ ಮಾಡಿ', 'select_issue': 'ಸಮಸ್ಯೆ ಆಯ್ಕೆ ಮಾಡಿ', 'book_now': 'ಈಗ ಬುಕ್ ಮಾಡಿ',
      'price': 'ಬೆಲೆ', 'total': 'ಒಟ್ಟು', 'estimated_time': 'ಅಂದಾಜು ಸಮಯ',
      'orders': 'ಆರ್ಡರ್‌ಗಳು', 'active_orders': 'ಸಕ್ರಿಯ ಆರ್ಡರ್‌ಗಳು', 'past_orders': 'ಹಳೆಯ ಆರ್ಡರ್‌ಗಳು',
      'order_id': 'ಆರ್ಡರ್ ID', 'order_status': 'ಸ್ಥಿತಿ', 'pending': 'ಬಾಕಿ', 'assigned': 'ನಿಯೋಜಿಸಲಾಗಿದೆ', 'in_progress': 'ಪ್ರಗತಿಯಲ್ಲಿದೆ',
      'completed': 'ಪೂರ್ಣಗೊಂಡಿದೆ', 'cancelled': 'ರದ್ದು', 'no_orders': 'ಆರ್ಡರ್‌ಗಳಿಲ್ಲ', 'view_details': 'ವಿವರಗಳನ್ನು ನೋಡಿ',
      'personal_info': 'ವೈಯಕ್ತಿಕ ಮಾಹಿತಿ', 'saved_addresses': 'ಉಳಿಸಿದ ವಿಳಾಸಗಳು', 'payment_methods': 'ಪಾವತಿ ವಿಧಾನಗಳು',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು', 'help_faq': 'ಸಹಾಯ & FAQ', 'chat_support': 'ಬೆಂಬಲದೊಂದಿಗೆ ಚಾಟ್',
      'rate_app': 'ಅಪ್ಲಿಕೇಶನ್ ರೇಟ್ ಮಾಡಿ', 'account': 'ಖಾತೆ', 'support': 'ಬೆಂಬಲ', 'preferences': 'ಆದ್ಯತೆಗಳು',
      'repairs': 'ದುರಸ್ತಿಗಳು', 'saved': 'ಉಳಿತಾಯ', 'rating': 'ರೇಟಿಂಗ್',
      'save': 'ಉಳಿಸಿ', 'cancel': 'ರದ್ದು ಮಾಡಿ', 'ok': 'ಸರಿ', 'back': 'ಹಿಂದೆ', 'loading': 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...',
      'error': 'ಏನೋ ತಪ್ಪಾಯಿತು', 'retry': 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ', 'success': 'ಯಶಸ್ಸು',
      'name': 'ಹೆಸರು', 'phone': 'ಫೋನ್', 'address': 'ವಿಳಾಸ', 'city': 'ನಗರ', 'pincode': 'ಪಿನ್‌ಕೋಡ್', 'submit': 'ಸಲ್ಲಿಸಿ',
      'version': 'Fix-N-Go v1.0.0',
    },

    // ── Malayalam ────────────────────────────────────────────────────────────
    'ml': {
      'app_name': 'Fix-N-Go',
      'language': 'ഭാഷ',
      'select_language': 'ഭാഷ തിരഞ്ഞെടുക്കുക',
      'apply': 'പ്രയോഗിക്കുക',
      'login': 'ലോഗിൻ', 'register': 'രജിസ്റ്റർ', 'email': 'ഇമെയിൽ', 'password': 'പാസ്‌വേഡ്',
      'full_name': 'പൂർണ്ണ നാമം', 'confirm_password': 'പാസ്‌വേഡ് സ്ഥിരീകരിക്കുക', 'forgot_password': 'പാസ്‌വേഡ് മറന്നോ?',
      'dont_have_account': 'അക്കൗണ്ട് ഇല്ലേ?', 'already_have_account': 'ഇതിനകം അക്കൗണ്ട് ഉണ്ടോ?', 'sign_in': 'സൈൻ ഇൻ', 'sign_up': 'സൈൻ അപ്', 'logout': 'ലോഗ് ഔട്ട്',
      'hi_greeting': 'നമസ്കാരം', 'find_service': 'സേവനം കണ്ടെത്തുക', 'our_services': 'ഞങ്ങളുടെ സേവനങ്ങൾ', 'popular_services': 'ജനപ്രിയ സേവനങ്ങൾ',
      'book_repair': 'റിപ്പയർ ബുക്ക് ചെയ്യുക', 'track_order': 'ഓർഡർ ട്രാക്ക് ചെയ്യുക', 'my_orders': 'എന്റെ ഓർഡറുകൾ', 'profile': 'പ്രൊഫൈൽ', 'home': 'ഹോം',
      'search_placeholder': 'സേവനം തിരയുക...', 'view_all': 'എല്ലാം കാണുക', 'available_technicians': 'ലഭ്യമായ ടെക്നീഷ്യൻമാർ', 'min_away': 'മിനിറ്റ് ദൂരം',
      'screen_replacement': 'സ്ക്രീൻ മാറ്റൽ', 'battery_repair': 'ബാറ്ററി റിപ്പയർ', 'camera_repair': 'ക്യാമറ റിപ്പയർ', 'software_fix': 'സോഫ്റ്റ്‌വെയർ പരിഹാരം',
      'select_device': 'ഉപകരണം തിരഞ്ഞെടുക്കുക', 'select_brand': 'ബ്രാൻഡ് തിരഞ്ഞെടുക്കുക', 'select_issue': 'പ്രശ്നം തിരഞ്ഞെടുക്കുക', 'book_now': 'ഇപ്പോൾ ബുക്ക് ചെയ്യുക',
      'price': 'വില', 'total': 'ആകെ', 'estimated_time': 'കണക്കാക്കിയ സമയം',
      'orders': 'ഓർഡറുകൾ', 'active_orders': 'സജീവ ഓർഡറുകൾ', 'past_orders': 'കഴിഞ്ഞ ഓർഡറുകൾ',
      'order_id': 'ഓർഡർ ID', 'order_status': 'സ്ഥിതി', 'pending': 'തീർക്കാനുള്ളത്', 'assigned': 'നൽകിയത്', 'in_progress': 'പുരോഗമിക്കുന്നു',
      'completed': 'പൂർത്തിയായി', 'cancelled': 'റദ്ദാക്കി', 'no_orders': 'ഓർഡറുകൾ ഇല്ല', 'view_details': 'വിശദാംശങ്ങൾ കാണുക',
      'personal_info': 'വ്യക്തിഗത വിവരം', 'saved_addresses': 'സേവ് ചെയ്ത വിലാസങ്ങൾ', 'payment_methods': 'പേയ്‌മെന്റ് രീതികൾ',
      'notifications': 'അറിയിപ്പുകൾ', 'help_faq': 'സഹായം & FAQ', 'chat_support': 'പിന്തുണയുമായി ചാറ്റ്',
      'rate_app': 'ആപ്പ് റേറ്റ് ചെയ്യുക', 'account': 'അക്കൗണ്ട്', 'support': 'പിന്തുണ', 'preferences': 'മുൻഗണനകൾ',
      'repairs': 'റിപ്പയറുകൾ', 'saved': 'ലാഭം', 'rating': 'റേറ്റിംഗ്',
      'save': 'സേവ് ചെയ്യുക', 'cancel': 'റദ്ദാക്കുക', 'ok': 'ശരി', 'back': 'തിരികെ', 'loading': 'ലോഡ് ചെയ്യുന്നു...',
      'error': 'എന്തോ തകരാർ', 'retry': 'വീണ്ടും ശ്രമിക്കുക', 'success': 'വിജയം',
      'name': 'പേര്', 'phone': 'ഫോൺ', 'address': 'വിലാസം', 'city': 'നഗരം', 'pincode': 'പിൻകോഡ്', 'submit': 'സമർപ്പിക്കുക',
      'version': 'Fix-N-Go v1.0.0',
    },

    // ── Marathi ──────────────────────────────────────────────────────────────
    'mr': {
      'app_name': 'Fix-N-Go',
      'language': 'भाषा',
      'select_language': 'भाषा निवडा',
      'apply': 'लागू करा',
      'login': 'लॉगिन', 'register': 'नोंदणी', 'email': 'ईमेल', 'password': 'पासवर्ड',
      'full_name': 'पूर्ण नाव', 'confirm_password': 'पासवर्ड पुष्टी करा', 'forgot_password': 'पासवर्ड विसरलात?',
      'dont_have_account': 'खाते नाही?', 'already_have_account': 'आधीच खाते आहे?', 'sign_in': 'साइन इन', 'sign_up': 'साइन अप', 'logout': 'लॉग आउट',
      'hi_greeting': 'नमस्कार', 'find_service': 'सेवा शोधा', 'our_services': 'आमच्या सेवा', 'popular_services': 'लोकप्रिय सेवा',
      'book_repair': 'दुरुस्ती बुक करा', 'track_order': 'ऑर्डर ट्रॅक करा', 'my_orders': 'माझे ऑर्डर', 'profile': 'प्रोफाइल', 'home': 'मुख्यपृष्ठ',
      'search_placeholder': 'सेवा शोधा...', 'view_all': 'सर्व पहा', 'available_technicians': 'उपलब्ध तंत्रज्ञ', 'min_away': 'मिनिट दूर',
      'screen_replacement': 'स्क्रीन बदलणे', 'battery_repair': 'बॅटरी दुरुस्ती', 'camera_repair': 'कॅमेरा दुरुस्ती', 'software_fix': 'सॉफ्टवेअर सुधारणा',
      'select_device': 'उपकरण निवडा', 'select_brand': 'ब्रँड निवडा', 'select_issue': 'समस्या निवडा', 'book_now': 'आता बुक करा',
      'price': 'किंमत', 'total': 'एकूण', 'estimated_time': 'अंदाजे वेळ',
      'orders': 'ऑर्डर', 'active_orders': 'सक्रिय ऑर्डर', 'past_orders': 'मागील ऑर्डर',
      'order_id': 'ऑर्डर ID', 'order_status': 'स्थिती', 'pending': 'प्रलंबित', 'assigned': 'नियुक्त', 'in_progress': 'प्रगतीत',
      'completed': 'पूर्ण', 'cancelled': 'रद्द', 'no_orders': 'ऑर्डर नाहीत', 'view_details': 'तपशील पहा',
      'personal_info': 'वैयक्तिक माहिती', 'saved_addresses': 'जतन केलेले पत्ते', 'payment_methods': 'पेमेंट पद्धती',
      'notifications': 'सूचना', 'help_faq': 'मदत & FAQ', 'chat_support': 'समर्थनासह चॅट',
      'rate_app': 'ॲप रेट करा', 'account': 'खाते', 'support': 'समर्थन', 'preferences': 'प्राधान्ये',
      'repairs': 'दुरुस्त्या', 'saved': 'बचत', 'rating': 'रेटिंग',
      'save': 'जतन करा', 'cancel': 'रद्द करा', 'ok': 'ठीक आहे', 'back': 'मागे', 'loading': 'लोड होत आहे...',
      'error': 'काहीतरी चुकले', 'retry': 'पुन्हा प्रयत्न करा', 'success': 'यश',
      'name': 'नाव', 'phone': 'फोन', 'address': 'पत्ता', 'city': 'शहर', 'pincode': 'पिनकोड', 'submit': 'सबमिट करा',
      'version': 'Fix-N-Go v1.0.0',
    },

    // ── Bengali ──────────────────────────────────────────────────────────────
    'bn': {
      'app_name': 'Fix-N-Go',
      'language': 'ভাষা',
      'select_language': 'ভাষা নির্বাচন করুন',
      'apply': 'প্রয়োগ করুন',
      'login': 'লগইন', 'register': 'নিবন্ধন', 'email': 'ইমেল', 'password': 'পাসওয়ার্ড',
      'full_name': 'পূর্ণ নাম', 'confirm_password': 'পাসওয়ার্ড নিশ্চিত করুন', 'forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
      'dont_have_account': 'অ্যাকাউন্ট নেই?', 'already_have_account': 'ইতিমধ্যে অ্যাকাউন্ট আছে?', 'sign_in': 'সাইন ইন', 'sign_up': 'সাইন আপ', 'logout': 'লগ আউট',
      'hi_greeting': 'নমস্কার', 'find_service': 'সেবা খুঁজুন', 'our_services': 'আমাদের সেবা', 'popular_services': 'জনপ্রিয় সেবা',
      'book_repair': 'মেরামত বুক করুন', 'track_order': 'অর্ডার ট্র্যাক করুন', 'my_orders': 'আমার অর্ডার', 'profile': 'প্রোফাইল', 'home': 'হোম',
      'search_placeholder': 'সেবা খুঁজুন...', 'view_all': 'সব দেখুন', 'available_technicians': 'উপলব্ধ প্রযুক্তিবিদ', 'min_away': 'মিনিট দূরে',
      'screen_replacement': 'স্ক্রিন প্রতিস্থাপন', 'battery_repair': 'ব্যাটারি মেরামত', 'camera_repair': 'ক্যামেরা মেরামত', 'software_fix': 'সফটওয়্যার সমাধান',
      'select_device': 'ডিভাইস নির্বাচন করুন', 'select_brand': 'ব্র্যান্ড নির্বাচন করুন', 'select_issue': 'সমস্যা নির্বাচন করুন', 'book_now': 'এখনই বুক করুন',
      'price': 'মূল্য', 'total': 'মোট', 'estimated_time': 'আনুমানিক সময়',
      'orders': 'অর্ডার', 'active_orders': 'সক্রিয় অর্ডার', 'past_orders': 'পুরানো অর্ডার',
      'order_id': 'অর্ডার ID', 'order_status': 'অবস্থা', 'pending': 'মুলতুবি', 'assigned': 'নিযুক্ত', 'in_progress': 'চলছে',
      'completed': 'সম্পন্ন', 'cancelled': 'বাতিল', 'no_orders': 'কোনো অর্ডার নেই', 'view_details': 'বিস্তারিত দেখুন',
      'personal_info': 'ব্যক্তিগত তথ্য', 'saved_addresses': 'সংরক্ষিত ঠিকানা', 'payment_methods': 'পেমেন্ট পদ্ধতি',
      'notifications': 'বিজ্ঞপ্তি', 'help_faq': 'সাহায্য & FAQ', 'chat_support': 'সহায়তার সাথে চ্যাট',
      'rate_app': 'অ্যাপ রেট করুন', 'account': 'অ্যাকাউন্ট', 'support': 'সহায়তা', 'preferences': 'পছন্দসমূহ',
      'repairs': 'মেরামত', 'saved': 'সঞ্চয়', 'rating': 'রেটিং',
      'save': 'সংরক্ষণ', 'cancel': 'বাতিল', 'ok': 'ঠিক আছে', 'back': 'ফিরুন', 'loading': 'লোড হচ্ছে...',
      'error': 'কিছু ভুল হয়েছে', 'retry': 'আবার চেষ্টা করুন', 'success': 'সাফল্য',
      'name': 'নাম', 'phone': 'ফোন', 'address': 'ঠিকানা', 'city': 'শহর', 'pincode': 'পিনকোড', 'submit': 'জমা দিন',
      'version': 'Fix-N-Go v1.0.0',
    },
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    return _strings[langCode]?[key] ?? _strings['en']?[key] ?? key;
  }

  // Convenience getters for all strings
  String get appName => translate('app_name');
  String get language => translate('language');
  String get selectLanguage => translate('select_language');
  String get apply => translate('apply');
  String get login => translate('login');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get fullName => translate('full_name');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get dontHaveAccount => translate('dont_have_account');
  String get alreadyHaveAccount => translate('already_have_account');
  String get signIn => translate('sign_in');
  String get signUp => translate('sign_up');
  String get logout => translate('logout');
  String get hiGreeting => translate('hi_greeting');
  String get findService => translate('find_service');
  String get ourServices => translate('our_services');
  String get popularServices => translate('popular_services');
  String get bookRepair => translate('book_repair');
  String get trackOrder => translate('track_order');
  String get myOrders => translate('my_orders');
  String get profile => translate('profile');
  String get home => translate('home');
  String get searchPlaceholder => translate('search_placeholder');
  String get viewAll => translate('view_all');
  String get availableTechnicians => translate('available_technicians');
  String get minAway => translate('min_away');
  String get screenReplacement => translate('screen_replacement');
  String get batteryRepair => translate('battery_repair');
  String get cameraRepair => translate('camera_repair');
  String get softwareFix => translate('software_fix');
  String get selectDevice => translate('select_device');
  String get selectBrand => translate('select_brand');
  String get selectIssue => translate('select_issue');
  String get bookNow => translate('book_now');
  String get price => translate('price');
  String get total => translate('total');
  String get estimatedTime => translate('estimated_time');
  String get orders => translate('orders');
  String get activeOrders => translate('active_orders');
  String get pastOrders => translate('past_orders');
  String get orderId => translate('order_id');
  String get orderStatus => translate('order_status');
  String get pending => translate('pending');
  String get assigned => translate('assigned');
  String get inProgress => translate('in_progress');
  String get completed => translate('completed');
  String get cancelled => translate('cancelled');
  String get noOrders => translate('no_orders');
  String get viewDetails => translate('view_details');
  String get personalInfo => translate('personal_info');
  String get savedAddresses => translate('saved_addresses');
  String get paymentMethods => translate('payment_methods');
  String get notifications => translate('notifications');
  String get helpFaq => translate('help_faq');
  String get chatSupport => translate('chat_support');
  String get rateApp => translate('rate_app');
  String get account => translate('account');
  String get support => translate('support');
  String get preferences => translate('preferences');
  String get repairs => translate('repairs');
  String get saved => translate('saved');
  String get rating => translate('rating');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get ok => translate('ok');
  String get back => translate('back');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get success => translate('success');
  String get name => translate('name');
  String get phone => translate('phone');
  String get address => translate('address');
  String get city => translate('city');
  String get pincode => translate('pincode');
  String get submit => translate('submit');
  String get version => translate('version');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
