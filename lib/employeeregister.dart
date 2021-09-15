import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Classe principal da tela de solicitação de registro como prestadora de serviços
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

/// Classe que cria o formulário a ser preenchido pela usuária para solicitar
/// registro como prestadora de serviços
class _RegisterForm extends StatefulWidget{
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();

}

class _RegisterFormState extends State<_RegisterForm>{

  // Instanciamento de variáveis necessárias para o formulário e envio de dados
  // para persistência em banco de dados
  final _formKey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('prestadora de serviços');
  String name = '';
  String cpfcnpj = '';
  String email = '';
  String phone1 = '';
  String phone2 = '';
  late final User user;

  // URI de acesso a API de consulta de estados do IBGE, ordenada por nome,
  // que será usada para popular as opções de UF de Atuação
  final Uri uri = Uri.parse("https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome");

  // Instanciamento de variáveis para atribuir o resultado das consultas a API
  // do IBGE.
  // ufdata se trata da lista de estados, e mundata da lista de municípios
  List ufdata = List.empty(growable: true);
  List mundata = List.empty(growable: true);

  // Variáveis para obter o que foi selecionado pela usuária nos campos de
  // UF de Atuação e Município de Atuação
  var _myUFSelection = null;
  var _myMunSelection = null;

  // Lista de serviços possíveis para a prestadora de serviços selecionar em que
  // atua.
  List<String> services = ['Serviços Elétricos', 'Serviços Mecânicos', 'Serviços Domésticos', 'Outros'];

  // Variável para obter o que foi selecionado pela usuária em serviço prestado
  var _myServiceSelection = null;

  /// Método para solicitar a lista de estados a API do IBGE e atualizar o
  /// dropdown com as opções disponíveis
  Future<String> getUFData() async {
    var res = await http.get(uri, headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      ufdata = resBody;
    });

    return "Sucess";
  }

  /// Método para solicitar a lista de municípios a API do IBGE e atualizar o
  /// dropdown com as opções disponíveis de acordo com o estado selecionado
  Future<String> getMData(munuri) async {
    var res = await http.get(munuri, headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      mundata = resBody;
    });

    return "Sucess";
  }

  /// Método para incluir a solicitação de registro como prestadora de serviços
  /// no banco de dados
  Future<void> addEmployee() {
    return users
        .doc(user.uid).set({
      'nome de prestadora': this.name,
      'email de prestadora': this.email,
      'id': this.user.uid,
      'cpfcnpj': this.cpfcnpj,
      'estado de atuação': this._myUFSelection,
      'município de atuação': this._myMunSelection,
      'telefone': this.phone1,
      'celular': this.phone2,
      'serviço prestado': this._myServiceSelection,
      'foto': this.user.photoURL,
      'disponível para validação': false,
      'autorizado': false,
    })
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Enviado com Sucesso!'),
      ));
      Navigator.of(context).pop();
    }).catchError((error) =>
    "Ocorreu um erro:\n $error");
  }

  @override
  void initState() {
    super.initState();
    this.getUFData();
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
            validator: (name) {
              if (name == null || name.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              setState(() {
                this.name = name;
              });
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
              setState(() {
                this.cpfcnpj = cpfcnpj;
              });
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
              setState(() {
                this.phone1 = phone1;
              });
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
              setState(() {
                this.phone2 = phone2;
              });
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
              setState(() {
                this.email = email;
              });
              return null;
            },
          ),
          DropdownButtonFormField(
            items: ufdata.map((item) {
              return new DropdownMenuItem(
                child: new Text(item['sigla'].toString()),
                value: item['sigla'].toString(),
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
                _myUFSelection = newVal.toString();
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
                value: item['nome'].toString(),
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
                _myMunSelection = newVal.toString();
              });
            },
            value: _myMunSelection,
          ),
          DropdownButtonFormField(
            items: services.map((item) {
              return new DropdownMenuItem(
                child: new Text(item),
                value: item.toString(),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Serviço Prestado*',
              labelStyle: TextStyle(color: Colors.amber),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            onChanged: (newVal) {
              setState(() {
                _myServiceSelection = newVal.toString();
              });
            },
            value: _myServiceSelection,
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
                  var resultado = addEmployee();
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