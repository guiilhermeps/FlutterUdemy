import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactHelper {
  static final ContactHelper _getInstance = ContactHelper.internal();

  factory ContactHelper() => _getInstance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializeDb();
      return _db;
    }
  }

  Future<Database> inicializeDb() async {
    final dataBasesPath = await getDatabasesPath();
    final path = join(dataBasesPath, "contacts.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE DATABASE ContactTable (\" "
          "idColumn INTEGER PRIMARY KEY,"
          "nameColumn TEXT,"
          "emailColumn TEXT,"
          "telefoneColumn TEXT,"
          "imgColumn TEXT"
          " \") ");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert("ContactTable", contact.objectToMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query("ContactTable",
        columns: [
          "idColumn",
          "nameColumn",
          "emailColumn",
          "telefoneColumn",
          "imgColumn"
        ],
        where: "idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContac = await db;
    return await dbContac
        .delete("ContactTable", where: "idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update("ContactTable", contact.objectToMap(),
        where: "idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM ContacTable");
    List<Contact> listContact = List();
    for (Map contacMap in listMap) {
      listContact.add(Contact.fromMap(contacMap));
    }
    return listContact;
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  int id;
  String nome;
  String email;
  String telefone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map["idColumn"];
    nome = map["nameColumn"];
    email = map["emailColumn"];
    telefone = map["telefoneColumn"];
    img = map["imgColumn"];
  }

  Map objectToMap() {
    Map<String, dynamic> map = {
      "nameColumn": nome,
      "emailColumn": email,
      "telefoneColumn": telefone,
      "imgColumn": img
    };
    if (id != null) {
      map["idColumn"] = id;
    }
  }
}
