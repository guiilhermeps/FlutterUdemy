import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_contatos/Helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.objectToMap());
      _nameController.text = _editedContact.nome;
      _emailController.text = _editedContact.email;
      _telefoneController.text = _editedContact.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact.nome ?? "Novo Contato"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact.img != null
                                ? FileImage(File(_editedContact.img))
                                : AssetImage("images/person_icon.png"))),
                  ),
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.gallery)
                        .then((file) {
                      if (file == null) {
                        return;
                      }
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                ),
                TextField(
                    decoration: InputDecoration(labelText: "Nome"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedContact.nome = text;
                      });
                    },
                    controller: _nameController,
                    focusNode: _nameFocus),
                TextField(
                    decoration: InputDecoration(labelText: "E-mail"),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController),
                TextField(
                    decoration: InputDecoration(labelText: "Telefone"),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.telefone = text;
                    },
                    keyboardType: TextInputType.phone,
                    controller: _telefoneController)
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.nome.isNotEmpty &&
                  _editedContact.nome != null) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            backgroundColor: Colors.red,
            child: Icon(Icons.save),
          ),
        ));
  }

  Future<bool> _requestPop() async {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações ?"),
              content: Text("Ao sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: Text("Sim"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
