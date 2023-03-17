import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahToDo extends StatefulWidget {
  final Map? tugas;
  const TambahToDo({super.key, this.tugas});

  @override
  State<TambahToDo> createState() => _TambahToDoState();
}

class _TambahToDoState extends State<TambahToDo> {
  final TextEditingController _tugas = TextEditingController();
  final TextEditingController _deskripsi = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.tugas != null) {
      isEdit = true;
      _tugas.text = widget.tugas!["title"];
      _deskripsi.text = widget.tugas!["description"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            (isEdit) ? const Text("Sunting To Do") : const Text("Tambah To Do"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          TextField(
            controller: _tugas,
            decoration: const InputDecoration(hintText: "Tugas"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _deskripsi,
            decoration: const InputDecoration(hintText: "Deskripsi"),
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: createData,
            child: (isEdit) ? const Text("Sunting") : const Text("Tambah"),
          ),
        ]),
      ),
    );
  }

  Future<void> createData() async {
    final String tugas = _tugas.text;
    final String deskripsi = _deskripsi.text;
    final Map<String, dynamic> body = {
      "title": tugas,
      "description": deskripsi,
      "is_completed": false,
    };
    final response = await http.post(Uri.parse("http://api.nstack.in/v1/todos"),
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
        });
    if (response.statusCode == 201) {
      _tugas.text = "";
      _deskripsi.text = "";
      tampilPesan(const SnackBar(
        content: Text(
          "Tugas berhasil ditambahkan",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ));
    } else {
      tampilPesan(const SnackBar(
        content: Text(
          "Tugas gagal dibuat",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> updateData() async {
    
  }

  void tampilPesan(SnackBar pesan) {
    ScaffoldMessenger.of(context).showSnackBar(pesan);
  }
}
