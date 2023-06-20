import 'package:flutter/material.dart';
import 'main_page.dart';

class AlertScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'DeeP',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 74, 173), // Mavi yazı rengi
                    ),
                  ),
                  TextSpan(
                    text: 'layer',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(
                          255, 230, 13, 13), // Kırmızı yazı rengi
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Bu uygulama DeepFake teknolojisi kullanmaktadır. Lütfen kullanımına ilişkin sorumlulukları kabul ettiğinizi onaylayın.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // Yazı boyutunu belirler
                  fontWeight: FontWeight
                      .normal, // Yazı kalınlığını belirler (bold, normal, vs.)
                  fontStyle:
                      FontStyle.normal, // Yazı stili (italic, normal, vs.)
                  color: Colors.black, // Yazı rengini belirler
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Kullanıcı "Kabul Et" düğmesine tıkladığında burası çalışır
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Butonun arka plan rengi
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30)), // Butonun kenar yuvarlatma
                minimumSize: Size(200, 50), // Butonun minimum boyutu
              ),
              child: Text('Kabul Et',
                  style: TextStyle(fontSize: 20)), // Butonun metni ve stili
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Kullanıcı "Reddet" düğmesine tıkladığında burası çalışır
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Butonun arka plan rengi
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30)), // Butonun kenar yuvarlatma
                minimumSize: Size(200, 50), // Butonun minimum boyutu
              ),
              child: Text('Reddet',
                  style: TextStyle(fontSize: 20)), // Butonun metni ve stili
            ),
          ],
        ),
      ),
    );
  }
}
