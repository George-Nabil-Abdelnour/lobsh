import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سياسة الخصوصية | Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سياسة الخصوصية - تطبيق لبش',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'تطبيق "لبش" يُقدِّم تجربة تعليمية ممتعة لتعلُّم اللغة القبطية. نحن لا نجمع أي بيانات شخصية أو معلومات حساسة من المستخدمين.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'استخدام البيانات:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '- لا نقوم بجمع أو تخزين أي معلومات شخصية.\n'
              '- قد يستخدم التطبيق بعض البيانات المجهولة لتحليل الأداء وتحسين التجربة.\n'
              '- التطبيق لا يشارك أي بيانات مع أطراف خارجية.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Privacy Policy - Lobsh App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Lobsh App provides an interactive learning experience for the Coptic language. We do not collect any personal data or sensitive user information.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Data Usage:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '- No personal data is collected or stored.\n'
              '- The app may use anonymous data to analyze performance and improve user experience.\n'
              '- No data is shared with third parties.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('موافق | Accept'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
