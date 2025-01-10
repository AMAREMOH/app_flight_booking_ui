import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 10, 10),
        title: Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'من نحن'
              : 'About Us',
        ),
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
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
