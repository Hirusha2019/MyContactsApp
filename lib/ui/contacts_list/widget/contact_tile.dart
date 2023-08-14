// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:contacts/data/contact.dart';
import 'package:contacts/ui/contacts_list/contact/contact_edit_page.dart';
import 'package:contacts/ui/contacts_list/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    required this.contactIndex,
  }) : super(key: key);

  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    //classic syntax of inherited widgets
    final model = ScopedModel.of<ContactsModel>(
        context); //new method for access the model
    final displayedContact = model.contact?[contactIndex];
    return Slidable(
      endActionPane: ActionPane(motion: BehindMotion(), children: [
        SlidableAction(
          onPressed: (BuildContext context) {
            model.deleteContact(displayedContact!);
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      startActionPane: ActionPane(motion: BehindMotion(), children: [
        SlidableAction(
          onPressed: (BuildContext context) => _callPhoneNumber(
            context,
            displayedContact!.phoneNumber,
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.call,
          label: 'Call',
        ),
        SlidableAction(
          onPressed: (BuildContext context) => _writeEmail(
            context,
            displayedContact!.email,
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.email,
          label: 'Email',
        ),
      ]),
      child: _buildContent(
        context,
        displayedContact!,
        model,
      ),
    );
  }

  Future _callPhoneNumber(
    BuildContext context,
    String number,
  ) async {
    final url = 'tel: $number';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      final snackbar = SnackBar(
        content: Text('Cannot make a call'),
      );
      //showing an error messege
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future _writeEmail(
    BuildContext context,
    String? emailAddress,
  ) async {
    final url = 'mailto: $emailAddress';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      final snackbar = SnackBar(
        content: Text('Cannot write an email'),
      );
      //showing an error messege
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Container _buildContent(
    BuildContext context,
    Contact displayedContact,
    ContactsModel model,
  ) {
    //containers are used to stylee your UI
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
        leading: _buildCircleAvatar(displayedContact),
        title: Text(displayedContact.name ?? ''),
        subtitle: Text(displayedContact.email ?? ''),
        trailing: IconButton(
          icon: Icon(
            displayedContact.isFavorite ? Icons.star : Icons.star_border,
            color: displayedContact.isFavorite ? Colors.amber : Colors.grey,
          ),
          //when the code executed this callback function is executing inside the parent
          onPressed: () {
            model.changeFavoriteStatus(displayedContact);
          },
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ContactEditPage(
                    editedContact: displayedContact,
                    // //editedContactIndex: contactIndex,
                  )));
        },
      ),
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    return Hero(
      //Hero widget facilities a Hero animation between routes(pages) in a simple way
      //It's important that the tag is same and unique in both routes
      tag: displayedContact.hashCode,
      //Hashcode returns a fairly unique integer based on the content of the displayedContact object
      child: CircleAvatar(child: _buildCircleAvatarContent(displayedContact)),
    );
  }

  _buildCircleAvatarContent(Contact displayedContact) {
    return ClipOval(
      child: AspectRatio(
        aspectRatio: 1,
        child: displayedContact.imageFile == null
            ? Center(
                child: Text(
                  displayedContact.name![0],
                ),
              )
            : Image.file(
                displayedContact
                    .imageFile!, // Adding the ! operator to assert non-nullability
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
