import 'dart:convert';

import 'package:flutter/material.dart';
import 'tambah_todo.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> listToDo = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar To Do"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigasiCreateData,
        label: const Text("Tambah To Do"),
      ),
      body: RefreshIndicator(
        onRefresh: readData,
        child: ListView.builder(
            itemCount: listToDo.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(listToDo[index]["title"]),
                subtitle: Text(listToDo[index]["description"]),
                trailing: PopupMenuButton(onSelected: (value) {
                  if (value == "sunting") {
                    //edit
                    navigasiUpdateData(listToDo[index]);
                  }
                  if (value == "hapus") {
                    //hapus
                    deleteData(listToDo[index]["_id"]);
                  }
                }, itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: "sunting",
                      child: Text("Sunting"),
                    ),
                    const PopupMenuItem(
                      value: "hapus",
                      child: Text("Hapus"),
                    )
                  ];
                }),
              );
            }),
      ),
    );
  }

  void navigasiCreateData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahToDo(),
      ),
    );
  }

  Future<void> readData() async {
    final response = await http
        .get(Uri.parse("http://api.nstack.in/v1/todos?page=1&limit=10"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> hasil = json["items"];
      setState(() {
        listToDo = hasil;
      });
      print("Sukses");
    } else {
      print("gagal");
    }
  }

  Future<void> deleteData(String id) async {
    final response =
        await http.delete(Uri.parse("http://api.nstack.in/v1/todos/$id"));
    if (response.statusCode == 200) {
      final List<dynamic> listToDoBaru =
          listToDo.where((element) => element["_id"] != id).toList();
      setState(() {
        listToDo = listToDoBaru;
      });
    } else {
      tampilPesan(const SnackBar(
        content: Text(
          "Tugas gagal dihapus",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  void navigasiUpdateData(Map tugas) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TambahToDo(tugas: tugas),
        ));
  }

  void tampilPesan(SnackBar pesan) {
    ScaffoldMessenger.of(context).showSnackBar(pesan);
  }
}
