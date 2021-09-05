import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class EmployeeRegister extends StatelessWidget{
  const EmployeeRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Prestadora de Serviços'),
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
  final _formKey = GlobalKey<FormState>();

  final Uri uri = Uri.parse("https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome");

  List ufdata = List.empty(growable: true);
  List mundata = List.empty(growable: true);

  late File file = new File('');

  late var _myUFSelection = null;
  late var _myMunSelection = null;

  Future<String> getUFData() async {
    var res = await http.get(uri, headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      ufdata = resBody;
    });

    return "Sucess";
  }

  Future<String> getMData(munuri) async {
    var res = await http.get(munuri, headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      mundata = resBody;
    });

    return "Sucess";
  }

  Future getFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if(result != null) {
      file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    this.getUFData();
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
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'CPF/CNPJ*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (cpfcnpj) {
              if (cpfcnpj == null || cpfcnpj.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Telefone*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (phone1) {
              if (phone1 == null || phone1.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Celular*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (phone2) {
              if (phone2 == null || phone2.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Email*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            items: ufdata.map((item) {
              return new DropdownMenuItem(
                child: new Text(item['sigla'].toString()),
                value: item['id'].toString(),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'UF de Atuação*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            onChanged: (newVal) {
              setState(() {
                _myUFSelection = newVal;
                print(_myUFSelection);
              });
              getMData(Uri.parse("https://servicodados.ibge.gov.br/api/v1/localidades/estados/" + _myUFSelection + "/municipios"));
            },
            value: _myUFSelection,
          ),
          DropdownButtonFormField(
            items: mundata.map((item) {
              return new DropdownMenuItem(
                child: new Text(item['nome'].toString()),
                value: item['id'].toString(),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Município de Atuação*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            onChanged: (newVal) {
              setState(() {
                _myMunSelection = newVal;
              });
            },
            value: _myMunSelection,
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
                  child: Text("Arquivo carregado: " + file.path.toString(), textAlign: TextAlign.center,)
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processando')),
                  );
                }
              },
              child: const Text('Enviar')
            ),
          ),
        ],
      ),
    );
  }
}