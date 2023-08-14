// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:contacts/ui/contacts_list/contact/widget/contact_form.dart';
import 'package:flutter/material.dart';

class ContactCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
        ),
      body: ContactForm(),
    );
  }
}
