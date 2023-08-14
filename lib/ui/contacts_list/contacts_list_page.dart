// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings
import 'package:contacts/ui/contacts_list/contact/contact_create_page.dart';
import 'package:contacts/ui/contacts_list/model/contacts_model.dart';
import 'package:contacts/ui/contacts_list/widget/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsListPage extends StatefulWidget {
  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  //build function runs whenthe every state changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contacts"),
        ),
        body: ScopedModelDescendant<ContactsModel>(
            //runs when every change which happen in the model
            //It means run when notifyListeners(); is called from the model.dart
            builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: model.contact?.length,
              //Runs & Builds every list time
              itemBuilder: (context, index) {
                return ContactTile(
                  contactIndex: index,
                );
              },
            );
          }
        }),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.person_add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ContactCreatePage()),
            );
          },
        ));
  }
}
