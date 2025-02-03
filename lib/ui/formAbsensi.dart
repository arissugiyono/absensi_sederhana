import 'package:absensi_app_sqlite_130924/models/absensi.dart';
import 'package:flutter/material.dart';

class formAbsensi extends StatefulWidget {
  final Absensi? absensi;
  const formAbsensi({super.key, this.absensi});

  @override
  State<formAbsensi> createState() => _formAbsensiState(this.absensi);
}

class _formAbsensiState extends State<formAbsensi> {
  Absensi? absensi;

  _formAbsensiState(this.absensi);

  TextEditingController nameController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (absensi != null) {
      nameController.text = absensi!.nama;
      statusController.text = absensi!.status_hadir;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("form absensi"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "nama karyawan"),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextField(
                controller: statusController,
                decoration: InputDecoration(labelText: "status kehadiran"),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          if (absensi == null) {
                            absensi = Absensi(
                                nameController.text, statusController.text);
                          } else {
                            absensi!.nama = nameController.text;
                            absensi!.status_hadir = statusController.text;
                          }
                          Navigator.pop(context, absensi);
                        },
                        child: Text("saved")),
                  ),
                  Container(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("kembali")),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
