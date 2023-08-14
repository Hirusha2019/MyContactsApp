// ignore_for_file: avoid_print

import 'dart:io';

import 'package:contacts/data/contact.dart';
import 'package:contacts/ui/contacts_list/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: use_key_in_widget_constructors
class ContactForm extends StatefulWidget {
  final Contact? editedContact; //for edited contacts

  const ContactForm({
    Key? key,
    this.editedContact,
  }) : super(key: key);
  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  //keys allows us to access widget from a different place in the code
  final _formkey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _phoneNumber;
  File? _contactImageFile;

  //for check the edited contact or not //true if it's a edited contact
  bool get isEditMode => widget.editedContact != null;

  //This field true if _contactImageFile isn't null (means when selected an image)
  bool get hasSelectedCustomImage => _contactImageFile != null;

  @override
  void initState() {
    super.initState();
    _contactImageFile = widget.editedContact?.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          const SizedBox(height: 10),
          _buildContactPicture(),
          //for spacing things out
          const SizedBox(height: 10),
          TextFormField(
            validator: _validateName,
            initialValue: widget.editedContact?.name,
            onSaved: (value) => _name = value!,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          TextFormField(
            validator: _validateEmail,
            initialValue: widget.editedContact?.email,
            onSaved: (value) => _email = value!,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          TextFormField(
            validator: _validatePhoneNumber,
            initialValue: widget.editedContact?.phoneNumber,
            onSaved: (value) => _phoneNumber = value!,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: _onSaveContactButtonPressed,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SAVE CONTACT'),
                Icon(
                  Icons.person,
                  size: 18,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

//for displaying a default image in contact edit page
  Widget _buildContactPicture() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      //If there are no matching tags found in both routes,hero animation will not happen
      tag: widget.editedContact.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          child: _buildCircleAvatarContent(halfScreenDiameter),
        ),
      ),
    );
  }

  void _onContactPictureTapped() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //print(imageFile!.path);
    if (imageFile != null) {
      setState(() {
        _contactImageFile = File(imageFile.path); // Convert XFile to File
      });
    }
  }

  Widget _buildCircleAvatarContent(double halfScreenDiameter) {
    if (isEditMode || hasSelectedCustomImage) {
      return _buildEditModeCircleAvatarContent(halfScreenDiameter);
    } else {
      return Icon(
        Icons.person,
        size: halfScreenDiameter / 2,
      );
    }
  }

  Widget _buildEditModeCircleAvatarContent(double halfScreenDiameter) {
    if (_contactImageFile == null) {
      return Text(
        widget.editedContact!.name![0],
        style: TextStyle(fontSize: halfScreenDiameter / 2),
      );
    } else {
      //ClipOval makes it's child oval to fit the ovelness of CircleAvatar
      return ClipOval(
        //we want to transform the image to squre,no matter what it's default aspect ratio is
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            _contactImageFile!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  //Function for validate name field
  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return 'Enter a Name';
    }
    return null;
  }

  //Function for validate email field
  String? _validateEmail(String? value) {
    //Regular Expression
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (value!.isEmpty) {
      return 'Enter an Email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid Email Address';
    }
    return null;
  }

  //Function for validate phonenumber field
  String? _validatePhoneNumber(String? value) {
    //Regular Expression
    final phoneRegex = RegExp(r"^(?:[+0]9)?[0-9]{10}$");
    if (value!.isEmpty) {
      return 'Enter a Phone Number';
    } else if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid Phone Number';
    }
    return null;
  }

  void _onSaveContactButtonPressed() {
    //Accessing forn through _formkey
    if (_formkey.currentState!.validate()) {
      //this implements if only the form is validated
      _formkey.currentState!.save();
      //create a new contact object when press the button
      final newOrEditedContacts = Contact(
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
        //elvis operator (?.) returns null if editedContact is null
        //it means that it's not trying to access .isFavorite part if the editedContact is null
        //null coalescing operator (??)
        //if the left side is null it returns right side
        isFavorite: widget.editedContact?.isFavorite ?? false,
        imageFile: _contactImageFile,
      );

      if (isEditMode) {
        //ID doesn't change after updating other contacts fields
        newOrEditedContacts.id = widget.editedContact!.id;

        ScopedModel.of<ContactsModel>(context).updateContact(
          newOrEditedContacts,
        );
      } else {
        ScopedModel.of<ContactsModel>(context).addContact(newOrEditedContacts);
      }
      Navigator.of(context).pop();
    }
  }
}
