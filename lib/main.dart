import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dólar esta a 5 reais?',
      home: MyHomePage(title: 'Dólar esta a 5 reais?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<Cotacao> fetchData() async {
  final response = await http.get("https://economia.awesomeapi.com.br/json/USD-BRL");

  if (response.statusCode == 200) {
    return Cotacao.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load cotacao');
  }
}

class Cotacao {
  final String value;

  Cotacao({ this.value });

  factory Cotacao.fromJson(List<dynamic> json) {
    return Cotacao(value: json[0]['high']);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  double _cotacao;
  String _hasPassed;

  void getCotacao() {
    fetchData().then((aux) {
      double cotacao = double.parse(aux.value);
      setState(() {
        _cotacao = cotacao;
        _hasPassed = cotacao > 5 ? 'Sim' : 'Não';
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCotacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_hasPassed',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              'Cotação: $_cotacao',
            ),
          ],
        ),
      ),
    );
  }
}
