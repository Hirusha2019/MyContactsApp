import 'dart:io';

class Contact {
  //Database ID (Key)
  int? id;

  late String? name;
  late String? email;
  late String phoneNumber;
  bool isFavorite;
  File? imageFile;

  //Constructor with optional named parameters
  Contact({
    // @required annotation(or required) marks named arguments that must be passed
    //if not, the analyzer reports a hint
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
    this.imageFile, //this means imageFile will be null by default
  });

  //Map with String keys and dynamic values
  Map<String, dynamic> toMap() {
    //Map literals are created with curly braces {}
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite ?1:0,
      //We cannot store a file object in with SEMBAST Library directly
      //That's why we only store it's path
      'imageFilePath': imageFile?.path,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'] == 1 ? true :false,
      //If there is an imageFilePath, convert it to file
      //otherwise set imageFile to null
      imageFile:
          map['imageFilePath'] != null ? File(map['imageFilePath']) : null,
    );
  }
}
