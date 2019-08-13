import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_contatos/Helpers/contact_helper.dart';

import 'contact_page.dart';

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
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Agenda"),
            centerTitle: true,
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
                            : AssetImage("images/person.png"))),
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
                        style: TextStyle(
                            fontSize: 22.0)),
                    Text(contacts[index].telefone ?? "",
                        style: TextStyle(
                            fontSize: 22.0)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showContactPage();
      },
    );
  }

  void _showContactPage({Contact contact}){
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );
  }
}
