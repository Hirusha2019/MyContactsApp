// ignore_for_file: prefer_const_constructors, unused_import

import 'package:contacts/data/db/app_database.dart';
import 'package:contacts/data/db/contact_dao.dart';
import 'package:contacts/ui/contacts_list/contact/contact_create_page.dart';
import 'package:contacts/ui/contacts_list/contacts_list_page.dart';
import 'package:contacts/ui/contacts_list/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  // Ensure that Flutter engine's binding is initialized first
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      //this wrapping give access to use contact model inside every single possible widget
      //because Every widget is a part of a MaterialApp
      model: ContactsModel()
        ..loadContacts(), //load all contacts from the database as soon as the app starts
      //cascade operator(..) allows you to make a sequence of operations on the same object
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ContactsListPage(),
      ),
    );
  }
}
