import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home(),debugShowCheckedModeBanner: false));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Afix Despesas"), leading: Icon(Icons.menu)),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10.0,
                    color: Colors.black45,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Saldo",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "R\$ 0,00",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemBuilder: _rowRelatorio,
                itemCount: 2,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Relatório",
                            style: TextStyle(
                                color: Colors.lightBlue[900],
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold)),
                        Divider(color: Colors.deepPurple),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 35.0),
                              child: Text("Relatório",
                                  style: TextStyle(
                                      color: Colors.lightBlue[900],
                                      fontSize: 16.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35.0),
                              child: Text("Empresa",
                                  style: TextStyle(
                                      color: Colors.lightBlue[900],
                                      fontSize: 16.0)),
                            ),
                          ],
                        ),
                        Divider(color: Colors.deepPurple),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 35.0),
                              child: Text("15",
                                  style: TextStyle(
                                      color: Colors.lightBlue[900],
                                      fontSize: 16.0)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 35.0),
                                  child: Container(
                                    color: Colors.grey[400],
                                    child: TextField(keyboardType: TextInputType.number, textAlign: TextAlign.center)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

Future<Null> _refresh() async {
  await Future.delayed(Duration(seconds: 2));
  return null;
}

Widget _rowRelatorio(BuildContext context, int index) {
  return Padding(
    padding: const EdgeInsets.only(top: 1.0, left: 5.0, right: 5.0),
    child: Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("Relatório: ${index + 1}", style: TextStyle(fontSize: 20.0)),
                Text("Data:********", style: TextStyle(fontSize: 20.0)),
                Text("Valor R\$ 0,00", style: TextStyle(fontSize: 20.0)),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
