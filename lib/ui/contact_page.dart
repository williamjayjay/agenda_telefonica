import 'dart:io';

import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEddited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null ){
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text( _editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.orange,
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
                            : AssetImage("images/person.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                onTap: (){
                  showModalBottomSheet(context: context,
                      builder: (context) {
                        return BottomSheet(
                          onClosing: (){},
                          builder: (context){
                            return Container(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: FlatButton(
                                      child: Text("Câmera",
                                      style: TextStyle(color: Colors.redAccent, fontSize: 20.0),
                                      ),
                                      onPressed: () async {
                                        await ImagePicker.pickImage(source: ImageSource.camera).then((file){
                                          if (file == null) return;
                                          setState(() {
                                            _editedContact.img = file.path;
                                            _userEddited = true;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: FlatButton(
                                      child: Text("Galeria",
                                        style: TextStyle(color: Colors.redAccent, fontSize: 20.0),
                                      ),
                                      onPressed: () async {
                                        await ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                                          if (file == null) return;
                                          setState(() {
                                            _editedContact.img = file.path;
                                            _userEddited = true;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },

                        );

                      } );

                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEddited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                } ,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _userEddited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text){
                  _userEddited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ) ,
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEddited){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descargar alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }


}


