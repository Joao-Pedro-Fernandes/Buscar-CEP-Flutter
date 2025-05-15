import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Endereco {
  String cep = '';
  String state = '';
  String city = '';
  String neighborhood = '';
  String street = '';
  String service = '';

  Endereco();

  Endereco.fromJson(Map<String, dynamic> json) {
    cep = json['cep'] ?? '';
    state = json['state'] ?? '';
    city = json['city'] ?? '';
    neighborhood = json['neighborhood'] ?? '';
    street = json['street'] ?? '';
    service = json['service'] ?? '';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue)
      ),
      title: 'CEP',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var cepController = TextEditingController();
  Endereco resultado = Endereco();
  Future<Map<String, dynamic>> fetchCEP(String cep) async {
    final response =
        await http.get(Uri.parse('https://brasilapi.com.br/api/cep/v1/$cep'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao carregar CEP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar CEP'), backgroundColor: Colors.lightBlue,),
      body:
       Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [

            TextField(
              controller: cepController,
              decoration: const InputDecoration(
                labelText: "CEP",
                labelStyle: TextStyle(color: Colors.lightBlue),
                border: OutlineInputBorder()
              ),
              style: const TextStyle(color: Colors.lightBlue, fontSize: 20),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 30.0,
            ),
            FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              child: const Icon(Icons.search),
              onPressed: () async {
                final cepData = await fetchCEP(cepController.text);
                setState(() {
                  resultado = Endereco.fromJson(cepData);
                });
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              "Cidade: ${resultado.city}",
              style: const TextStyle(fontSize: 20.00),
            ),
            Text(
              "Estado: ${resultado.state}",
              style: const TextStyle(fontSize: 20.00),
            ),
            Text(
              "Bairro: ${resultado.neighborhood}",
              style: const TextStyle(fontSize: 20.00),
            ),
            Text(
              "Rua: ${resultado.street}",
              style: const TextStyle(fontSize: 20.00),
            )
        ],)    
      ),
    );
  }
}