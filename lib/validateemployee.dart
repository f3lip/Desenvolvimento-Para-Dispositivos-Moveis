import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Classe principal da validação de prestadoras de serviços
class ValidateEmployee extends StatefulWidget {
  final String title = 'Validar Prestadoras de Serviços';

  @override
  State<StatefulWidget> createState() => _ValidateEmployeeState();
}

class _ValidateEmployeeState extends State<ValidateEmployee> {
  // Gera o body inicial da tela, que traz a animação de carregamento enquanto
  // os dados necessários para uso ainda não foram retornados
  Widget _body = Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)),
        ],
      )],
    ),
    )
  );

  // Variáveis necessárias para realizar conexão com banco de dados e obter os
  // dados das prestadoras de serviços que solicitaram validação
  CollectionReference users = FirebaseFirestore.instance.collection('prestadora de serviços');
  User? user;
  late QuerySnapshot list;

  @override
  void initState() {
    super.initState();
    getDocuments().whenComplete(() => setState(() {
      _body = _goToValidateEmployee();
    }));
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = _auth.currentUser!;
  }

  /// Método para solicitar ao banco de dados todas as prestadoras de serviços
  /// que estão disponíveis para validação
  Future<void> getDocuments() async {
    list = await users.where('disponível para validação', isEqualTo: true).get();
    setState(() {
      this.list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  /// Gera o body que traz a listagem de prestadoras de serviços pendentes de
  /// validação, criando cards dinâmicos de acordo com o retorno do banco
  /// de dados
  Widget _goToValidateEmployee() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
        actions: <Widget>[
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new ListView.builder (
              itemCount: list.size,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child: ExpansionTile(
                    leading: CircleAvatar(backgroundImage:
                    NetworkImage(user!.photoURL.toString()),
                    ),
                    title: Text(list.docs[index].get('nome de prestadora')),
                    subtitle: Text(list.docs[index].get('email de prestadora')),
                    children: [
                      new Container(
                        child: new Image.network(
                            list.docs[index].get('foto'),
                            width: 200,
                            //height: 200,
                            fit: BoxFit.cover
                        ),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: new Text('Serviço Prestado: ' + this.list.docs[index].get('serviço prestado')),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: new Text('Nome: ' + this.list.docs[index].get('nome de prestadora')),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: new Text('CPF/CNPJ: ' + this.list.docs[index].get('cpfcnpj')),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: new Text('E-mail: ' + this.list.docs[index].get('email de prestadora')),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: new Text('Estado de Atuação: ' + this.list.docs[index].get('estado de atuação')),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: new Text('Município de Atuação: ' + this.list.docs[index].get('município de atuação')),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: new Text('Telefone: ' + this.list.docs[index].get('telefone')),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: new Text('Celular: ' + this.list.docs[index].get('celular')),
                      ),
                      new Container(
                        child: new Text(''),
                      ),
                      new Container(
                        child: 
                        new ElevatedButton(
                            onPressed: () {
                              users.doc(list.docs[index].get('id'))
                                  .update({'autorizado': true, 'disponível para validação': false})
                                  .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prestadora de Serviços Validada!')),);
                                    getDocuments();
                                    Navigator.of(context).pop();
                                  });
                              },
                            child: const Text('Validar Prestadora de Serviços'),
                            style: ElevatedButton.styleFrom(primary: Colors.amber),
                        ),
                      ),
                      new Container(
                        child:
                        new ElevatedButton(
                          onPressed: () {
                            users.doc(list.docs[index].get('id'))
                                .update({'autorizado': false, 'disponível para validação': false})
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prestadora de Serviços Recusada!')),);
                              Navigator.of(context).pop();
                            });
                            setState(() {});
                          },
                          child: const Text('Recusar'),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          )
        ],
      )
    );
  }
}