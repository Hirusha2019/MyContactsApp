// ignore_for_file: unused_field, constant_identifier_names, unused_local_variable
import 'package:contacts/data/contact.dart';
import 'package:contacts/data/db/app_database.dart';
import 'package:sembast/sembast.dart';

class ContactDao {
  static const String CONTACT_STORE_NAME = 'contacts';
  //A store with int keys and Map<String, Object?> values
  //This is precisely what we need since we convert Contact objects to Map
  final _contactStore = intMapStoreFactory.store(CONTACT_STORE_NAME);
  // Initialize the database
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Contact contact) async {
    await _contactStore.add(
      await _db,
      contact.toMap(),
    );
  }

  Future update(Contact contact) async {
    //Finder object allows us to filter by key,field values and more
    final finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.update(
      await _db,
      contact.toMap(),
      finder: finder,
    );
  }

  Future delete(Contact contact) async {
    final finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Contact>> getAllInSortedOrder() async {
    //Finder object can also faciliate sorting.
    //As before we're primarily sorting based on favorite status
    //secondary sorting is alphabetical
    final finder = Finder(sortOrders: [
      //false indicates that isFavorite will be sorted in descending order
      //false should be displayed after true for isFavorite
      SortOrder('isFavorite', false),
      SortOrder('name'),
    ]);

    final recordSnapShots = await _contactStore.find(
      await _db,
      finder: finder,
    );

    //.map iterates the whole list and gives us access to every element
    //it also returns a new list containing different values(Contact objects)
    return recordSnapShots.map((snapshot) {
      final contact = Contact.fromMap(snapshot.value);
      contact.id = snapshot.key;
      return contact;
    }).toList();
  }
}
