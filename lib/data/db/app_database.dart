import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  //The only available instance of this AppDatabase class is stored in this private field
  static final AppDatabase _singleton = AppDatabase?._();

  //This instance get-only property is the only way for other classes to access the single AppDatabase object
  //singleton accessor
  static AppDatabase get instance => _singleton;

  //Completer is used for transforming synchronous code into asynchronous code
  Completer<Database>? _dbOpenCompleter;

  // Private constructor (Private constructor prevents instantiation from outside the class)
  //If a class specifies it's own constuctor, it immedietly loses the default one
  //This means that by providing a private constructor, we can create new instances only from within this AppDatabase class itself.
  AppDatabase._();

  //database object accessor
  Future<Database> get database async {
    //If completer is null,database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      //Calling _openDatabase() will also complete the completer with database instance
      _openDatabase();
    }
    //If the database is already opened,return immedietly
    //Otherwise, wait until complete is called on the completer in _openDatabase()
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    //Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // make sure it exists
    await appDocumentDir.create(recursive: true);
    //Generates a path with the form like this :- /platform-specific-directory/contacts1.db
    final dbPath = join(appDocumentDir.path, 'contacts1.db');
    //Open the database
    final database = await databaseFactoryIo.openDatabase(dbPath);
    
    return _dbOpenCompleter!.complete(database);
  }

    Future init() async {
    // Perform any additional setup or configuration for your database here
    // This method will be called during app initialization
    await database;
  }

  

  
}
