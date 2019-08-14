import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_contatos/Helpers/contact_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact_page.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Agenda"),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<OrderOptions>(
                itemBuilder: (Context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                      child: Text("Ordenar de A-Z"),
                      value: OrderOptions.orderaz),
                  const PopupMenuItem<OrderOptions>(
                      child: Text("Ordenar de Z-A"),
                      value: OrderOptions.orderza)
                ],
                onSelected: _orderList,
              )
            ],
            backgroundColor: Colors.red),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContactPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return _makeItem(context, index);
            }));
  }

  Widget _makeItem(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].img != null
                            ? FileImage(File(contacts[index].img))
                            : AssetImage("images/person_icon.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].nome ?? "",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold)),
                    Text(contacts[index].email ?? "",
                        style: TextStyle(fontSize: 22.0)),
                    Text(contacts[index].telefone ?? "",
                        style: TextStyle(fontSize: 22.0)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Ligar",
                            style:
                                TextStyle(color: Colors.red, fontSize: 20.0)),
                        onPressed: () {
                          launch("tel:${contacts[index].telefone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Editar",
                            style:
                                TextStyle(color: Colors.red, fontSize: 20.0)),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Excluir",
                            style:
                                TextStyle(color: Colors.red, fontSize: 20.0)),
                        onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContant = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContant != null) {
      if (contact != null) {
        await helper.updateContact(recContant);
      } else {
        await helper.saveContact(recContant);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}
