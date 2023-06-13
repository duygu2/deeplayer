import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({Key? key}) : super(key: key);

  Future<void> sendRequest() async {
    var url = 'http://192.168.1.107:8000/hello';

    try {
      var response = await Dio().get(url);

      if (response.statusCode == 200) {
        // Başarılı bir şekilde sunucuya istek gönderildi.
        print('Sunucuya istek gönderildi!');
      } else {
        // İstek gönderilirken bir hata oluştu.
        print(
            'İstek gönderilirken hata oluştu. Hata kodu: ${response.statusCode}');
      }
    } catch (error) {
      // Bağlantı hatası veya diğer istisnaları yakalayın.
      print('İstek gönderilirken bir hata oluştu: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            sendRequest();
          },
          child: const Text('İstek Gönder'),
        ),
      ),
    );
  }
}
