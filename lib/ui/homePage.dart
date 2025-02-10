import 'package:absensi_app_sqlite_130924/helpers/dbhelper.dart';
import 'package:absensi_app_sqlite_130924/models/absensi.dart';
import 'package:absensi_app_sqlite_130924/ui/formAbsensi.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Absensi>? absensilist;

  @override
  Widget build(BuildContext context) {
    if (absensilist == null) {
      absensilist = <Absensi>[];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Absensi Karyawan"),
      ),
      body: createListAbsensi(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var absensi = await _navigateToFormAbsensi(context, null);
          if (absensi != null) _createAbsensi(absensi);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //floating action button
  Future<Absensi?> _navigateToFormAbsensi(
      BuildContext context, Absensi? absensi) async {
    // ignore: unused_local_variable
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return formAbsensi(absensi: absensi);
        },
      ),
    );
    return result as Absensi?;
  }

//list data
  ListView createListAbsensi() {
    return ListView.builder(
        itemCount: absensilist!.length,
        itemBuilder: ((context, index) {
          return Card(
              color: Colors.white,
              elevation: 3.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.people),
                ),
                title: Text(this.absensilist![index].nama),
                subtitle: Text(this.absensilist![index].status_hadir),
                trailing: GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    _deleteAbsensi(absensilist![index]);
                  },
                ),
                onTap: () async {
                  var absensi = await _navigateToFormAbsensi(
                      context, this.absensilist![index]);
                  if (absensi != null) _editAbsensi(absensi);
                },
              ));
        }));
  }

  void _createAbsensi(Absensi object) async {
    int result = await dbHelper.create(object);
    if (result > 0) {
      _updateListview();
    }
  }

  void _editAbsensi(Absensi object) async {
    int result = await dbHelper.update(object);
    if (result > 0) {
      _updateListview();
    }
  }

  void _deleteAbsensi(Absensi object) async {
    int result = await dbHelper.delete(object.id!);
    if (result > 0) {
      _updateListview();
    }
  }

  void _updateListview() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Absensi>> absensiListFuture = dbHelper.getAbsensiList();
      absensiListFuture.then((absensiList) {
        setState(() {
          this.absensilist = absensiList;
          this.count = absensiList.length;
        });
      });
    });
  }
}
