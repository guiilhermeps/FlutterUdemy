import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestHttp = "https://api.hgbrasil.com/finance?format=json&key=ac1f6356";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white)));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChange(String text) {
    if (text.isEmpty) {
      _clearAllFields();
    } else {
      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
    }
  }

  void _dolarChange(String text) {
    if (text.isEmpty) {
      _clearAllFields();
    } else {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }
  }

  void _euroChange(String text) {
    if (text.isEmpty) {
      _clearAllFields();
    } else {
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }
  }

  void _clearAllFields() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor de Moedas \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando Dados",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Erro ao Carregar Dados :(",
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                          textAlign: TextAlign.center));
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.amber),
                        buidTextField(
                            "Reais", "R\$", realController, _realChange),
                        Divider(),
                        buidTextField(
                            "Dólar", "US\$", dolarController, _dolarChange),
                        Divider(),
                        buidTextField("Euros", "€", euroController, _euroChange)
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buidTextField(String labelMoeda, String prefix,
    TextEditingController controller, Function fun) {
  return TextField(
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: labelMoeda,
        labelStyle: TextStyle(color: Colors.amber),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        prefixText: prefix),
    controller: controller,
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: fun,
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(requestHttp);
  return json.decode(response.body);
}
