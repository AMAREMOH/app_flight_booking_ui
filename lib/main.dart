import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart'; // Adjust the path based on the location of the file

void main() {
  runApp(AlamariTravelApp());
}

class AlamariTravelApp extends StatefulWidget {
  @override
  _AlamariTravelAppState createState() => _AlamariTravelAppState();
}

class _AlamariTravelAppState extends State<AlamariTravelApp> {
  Locale _locale = Locale('en');

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SearchScreen(onLanguageChange: _changeLanguage),
    );
  }
}

class SearchScreen extends StatefulWidget {
  final Function(String) onLanguageChange;

  SearchScreen({required this.onLanguageChange});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String tripType = "one-way"; // Default trip type
  int adultCount = 1, childCount = 0, infantCount = 0;
  DateTime? departureDate;
  DateTime? returnDate;

  void _changeTravelerCount(String type, bool isIncrement) {
    setState(() {
      if (type == 'adults') {
        adultCount = isIncrement
            ? adultCount + 1
            : (adultCount > 1 ? adultCount - 1 : adultCount);
      } else if (type == 'children') {
        childCount = isIncrement
            ? childCount + 1
            : (childCount > 0 ? childCount - 1 : childCount);
      } else if (type == 'infants') {
        infantCount = isIncrement
            ? infantCount + 1
            : (infantCount > 0 ? infantCount - 1 : infantCount);
      }
    });
  }

  Future<void> _selectDate(BuildContext context, bool isReturnDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isReturnDate) {
          returnDate = pickedDate;
        } else {
          departureDate = pickedDate;
        }
      });
    }
  }

  void _validateDates() {
    if (departureDate == null) {
      _showErrorDialog('يرجى اختيار تاريخ الذهاب.');
    } else if (tripType == "round-trip" && returnDate == null) {
      _showErrorDialog('يرجى اختيار تاريخ العودة.');
    } else if (tripType == "round-trip" &&
        returnDate != null &&
        returnDate!.isBefore(departureDate!)) {
      _showErrorDialog('تاريخ العودة لا يمكن أن يكون قبل تاريخ الذهاب.');
    } else {
      // Proceed with search logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Searching for flights...')),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('موافق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _navigateToAboutUsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutUsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 10, 10),
        title: Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'السفر مع العماري'
              : 'ALAMARI TRAVEL',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: widget.onLanguageChange,
            itemBuilder: (BuildContext context) {
              return [
                {'code': 'en', 'label': 'English'},
                {'code': 'ar', 'label': 'العربية'}
              ].map((language) {
                return PopupMenuItem<String>(
                  value: language['code'],
                  child: Text(language['label']!),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.login),
              title: Text(Localizations.localeOf(context).languageCode == 'ar'
                  ? 'تسجيل الدخول'
                  : 'Login'),
              onTap: _navigateToLoginScreen,
            ),
            ListTile(
              leading: Icon(Icons.policy),
              title: Text(Localizations.localeOf(context).languageCode == 'ar'
                  ? 'سياسة الخصوصية'
                  : 'Privacy Policy'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text(Localizations.localeOf(context).languageCode == 'ar'
                  ? 'شروط الاستخدام'
                  : 'Terms of Use'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.support),
              title: Text(Localizations.localeOf(context).languageCode == 'ar'
                  ? 'الدعم'
                  : 'Support'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(Localizations.localeOf(context).languageCode == 'ar'
                  ? 'من نحن'
                  : 'About Us'),
              onTap: _navigateToAboutUsScreen,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and Welcome Message
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.flight_takeoff,
                      size: 50,
                      color: Color.fromARGB(255, 201, 10, 10),
                    ),
                    SizedBox(height: 10),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'مرحبًا بك في السفر مع العماري'
                          : 'Welcome to ALAMARI TRAVEL',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'نتمنى لك رحلة ممتعة ومليئة بالتجارب الرائعة مع العماري!'
                          : 'We wish you a pleasant journey filled with wonderful experiences with Alamari!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Trip Type Selector
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'ذهاب'
                              : 'One-Way'),
                      value: "one-way",
                      groupValue: tripType,
                      onChanged: (value) {
                        setState(() {
                          tripType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'ذهاب وعودة'
                              : 'Round-Trip'),
                      value: "round-trip",
                      groupValue: tripType,
                      onChanged: (value) {
                        setState(() {
                          tripType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // Traveler Count Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(Localizations.localeOf(context).languageCode == 'ar'
                          ? 'الكبار'
                          : 'Adults'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                _changeTravelerCount('adults', false),
                          ),
                          Text('$adultCount'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                _changeTravelerCount('adults', true),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(Localizations.localeOf(context).languageCode == 'ar'
                          ? 'الأطفال'
                          : 'Children'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                _changeTravelerCount('children', false),
                          ),
                          Text('$childCount'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                _changeTravelerCount('children', true),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(Localizations.localeOf(context).languageCode == 'ar'
                          ? 'الرضع'
                          : 'Infants'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                _changeTravelerCount('infants', false),
                          ),
                          Text('$infantCount'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                _changeTravelerCount('infants', true),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Date Pickers
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText:
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'تاريخ الذهاب'
                          : 'Departure Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () {
                  _selectDate(context, false);
                },
              ),
              if (tripType == "round-trip") const SizedBox(height: 10),
              if (tripType == "round-trip")
                TextField(
                  decoration: InputDecoration(
                    labelText:
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'تاريخ العودة'
                            : 'Return Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () {
                    _selectDate(context, true);
                  },
                ),

              // Search Button
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _validateDates,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 201, 10, 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    Localizations.localeOf(context).languageCode == 'ar'
                        ? 'بحث'
                        : 'Search',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 10, 10),
        title: Text(Localizations.localeOf(context).languageCode == 'ar'
            ? 'من نحن'
            : 'About Us'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'نحن وكالة سفر في اليمن نقدم خدمات سفر متنوعة.'
                  : 'We are a travel agency in Yemen offering a variety of travel services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'قام بتطوير هذا التطبيق المطور محمد العماري.'
                  : 'This app was developed by Mohamed Alamari.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
