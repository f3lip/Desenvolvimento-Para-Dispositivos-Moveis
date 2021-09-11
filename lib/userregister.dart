import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRegister extends StatelessWidget{
  const UserRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuária'),
        backgroundColor: Colors.amber,
    ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 16.0),
          child: _RegisterForm()
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget{
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();

}

class _RegisterFormState extends State<_RegisterForm>{
  CollectionReference users = FirebaseFirestore.instance.collection('usuários');
  final _formKey = GlobalKey<FormState>();
  late String firstname = '';
  late String secondname = '';
  late String cpf = '';
  late final User user;
  late File file = File('');
  late String fileUrl = '';


  Future <void> getFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if(result != null) {
      setState(() {
        file = File(result.files.single.path);
      });
    } else {
      // User canceled the picker
    }
  }


  Future<void> addUser() {
    return users
        .doc(user.uid).set({
      'nome': this.firstname,
      'sobrenome': this.secondname,
      'email': this.user.email,
      'id': this.user.uid,
      'cpf': this.cpf,
      'identificação': this.fileUrl,
      'autorizado': false,
      'usuário validador': false,
      'disponível para validação': true,
    })
        .then((value) => "Adicionado com sucesso")
        .catchError((error) =>
    "Ocorreu um erro:\n $error");
  }

  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Nome*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (firstname) {
              if (firstname == null || firstname.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              setState(() {
                this.firstname = firstname;
              });
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Sobrenome*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (secondname) {
              if (secondname == null || secondname.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              setState(() {
                this.secondname = secondname;
              });
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'CPF*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (cpf) {
              if (cpf == null || cpf.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              setState(() {
                this.cpf = cpf;
              });
              return null;
            },
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    getFile();
                  },
                  child: const Text('Selecionar Documento de Identificação*')
              ),
              Visibility(
                  visible: file.path != '',
                  child: Text("Arquivo carregado: " + file.path.split('/').last, textAlign: TextAlign.center,)
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  /*
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processando')),
                  );*/
                  Reference ref = FirebaseStorage.instance.ref().child('${user.uid}/${file.path.split('/').last}');
                  UploadTask uploadTask = ref.putFile(file);
                  uploadTask.whenComplete(() async {
                    fileUrl = await FirebaseStorage.instance.ref().child('${user.uid}/${file.path.split('/').last}').getDownloadURL();
                    var resultado = addUser();
                  });
                }
              },
              child: const Text('Enviar para Validação')
            ),
          ),
        ],
      ),
    );
  }
}