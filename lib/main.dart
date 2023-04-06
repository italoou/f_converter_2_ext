import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=02cf88a5";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final realController = TextEditingController();
  final pesoController = TextEditingController();
  final canadianDolarController = TextEditingController();

  double dolar = 0;
  double euro = 0;
  double peso = 0;
  double canadianDolar = 0;

  void _realChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    pesoController.text = (real / peso).toStringAsFixed(2);
    canadianDolarController.text = (real / canadianDolar).toStringAsFixed(2);
  }

  void _dolarChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    pesoController.text = (dolar * this.dolar / peso).toStringAsFixed(2);
    canadianDolarController.text = (dolar * this.dolar / canadianDolar).toStringAsFixed(2);
  }

  void _euroChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    pesoController.text = (euro * this.euro / peso).toStringAsFixed(2);
    canadianDolarController.text = (euro * this.euro / canadianDolar).toStringAsFixed(2);

  }

  void _pesoChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double peso = double.parse(text);
    realController.text = (peso * this.peso).toStringAsFixed(2);
    dolarController.text = (peso * this.peso / dolar).toStringAsFixed(2);
    euroController.text = (peso * this.peso / euro).toStringAsFixed(2);
    canadianDolarController.text = (peso * this.peso / canadianDolar).toStringAsFixed(2);

  }

  void _canadianDolarChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double canadianDolar = double.parse(text);
    realController.text = (canadianDolar * this.canadianDolar).toStringAsFixed(2);
    dolarController.text = (canadianDolar * this.canadianDolar / dolar).toStringAsFixed(2);
    euroController.text = (canadianDolar * this.canadianDolar / euro).toStringAsFixed(2);
    pesoController.text = (canadianDolar * this.canadianDolar / peso).toStringAsFixed(2);

  }

  void _clearAll() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
    canadianDolarController.clear();
    pesoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text("\$ Conversor de Moedas \$"),
            centerTitle: true,
            backgroundColor: Colors.blueGrey),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(
                      child: Text(
                    "Carregando dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                      "Erro ao carregar dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro =
                        snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                    peso = 
                        snapshot.data!["results"]["currencies"]["ARS"]["buy"];
                    canadianDolar = 
                        snapshot.data!["results"]["currencies"]["CAD"]["buy"];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.blue),
                          buildTextFormField(
                              "Reais", "R\$", realController, _realChange),
                          const Divider(),
                          buildTextFormField(
                              "Dólar", "US\$", dolarController, _dolarChange),
                          const Divider(),
                          buildTextFormField(
                              "Dólar Canadense", "CAD", canadianDolarController, _canadianDolarChange),
                          const Divider(),
                          buildTextFormField(
                              "Euro", "EUR", euroController, _euroChange),
                          const Divider(),
                          buildTextFormField(
                              "Peso Argentino", "ARS", pesoController, _pesoChange),
                        ],
                      ),
                    );
                  }
              }
            }));
  }

  Widget buildTextFormField(String label, String prefix,
      TextEditingController controller, Function f) {
    return TextField(
      onChanged: (value) => f(value),
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueAccent),
          border: const OutlineInputBorder(),
          prefixText: "$prefix ",
          prefixStyle: const TextStyle(color: Colors.blueGrey),),
      style: const TextStyle(color: Colors.blueAccent, fontSize: 25.0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}