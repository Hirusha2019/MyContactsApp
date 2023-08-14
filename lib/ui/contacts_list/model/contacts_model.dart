// ignore_for_file: prefer_interpolation_to_compose_strings, unused_field

import 'package:contacts/data/contact.dart';
import 'package:contacts/data/db/contact_dao.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsModel extends Model {
  //In a more advanced app we wouldn't instantiate ContactDao directly in ContactModel Class
  //Use dependancy injection method in advanced apps 
  final ContactDao _contactDao = ContactDao();


  bool _isLoading = true;
  bool get isLoading => _isLoading;

  late List<Contact> _contacts;

  List<Contact>? get contact => _contacts;

  Future loadContacts() async {
    //while contacts are loading, indicator shows
    _isLoading = true;
    notifyListeners();

    _contacts = await _contactDao.getAllInSortedOrder();

    //as soon as contacts are loaded, let listeners know(indicator hide)
    _isLoading = false;
    notifyListeners();
  }

  //To add new contacts from cotact_form
  Future addContact(Contact contact) async {
    await _contactDao.insert(contact);
    await loadContacts();
    notifyListeners();
  }

  //for update the edited contact
  Future updateContact(
    Contact contact,
  ) async {
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  }

  //for delete the contact
  Future deleteContact(
    Contact contact,
  ) async {
    await _contactDao.delete(contact);
    await loadContacts();
    notifyListeners();
  }

  //create function to change isFavorite status and also sort the cotacts
  Future changeFavoriteStatus(Contact contact) async {
    contact.isFavorite = !contact.isFavorite;
    await _contactDao.update(contact);
    _contacts = await _contactDao.getAllInSortedOrder();
    notifyListeners();
  }

}
