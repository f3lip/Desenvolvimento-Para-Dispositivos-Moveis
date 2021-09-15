import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Classe principal da página de validação de usuária
class ValidateUser extends StatefulWidget {
  final String title = 'Validar Usuárias';

  @override
  State<StatefulWidget> createState() => _ValidateUserState();
}

class _ValidateUserState extends State<ValidateUser> {
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
  // dados das usuárias que solicitaram validação
  CollectionReference users = FirebaseFirestore.instance.collection('usuários');
  User? user;
  late QuerySnapshot list;

  @override
  void initState() {
    super.initState();
    getDocuments().whenComplete(() => setState(() {
      _body = _goToValidateUser();
    }));
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = _auth.currentUser!;
  }

  /// Método para solicitar ao banco de dados todas as usuárias que estão
  /// disponíveis para validação
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

  /// Gera o body que traz a listagem de usuárias pendentes de validação,
  /// criando cards dinâmicos de acordo com o retorno do banco de dados
  Widget _goToValidateUser() {
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
                    title: Text(list.docs[index].get('nome') + " " + list.docs[index].get('sobrenome')),
                    subtitle: Text(list.docs[index].get('email')),
                    children: [
                      new Text('Documento de Identificação'),
                      new Container(
                        child: new Image.network(
                            list.docs[index].get('identificação'),
                            width: 200,
                            //height: 200,
                            fit: BoxFit.cover
                        ),
                      ),
                      new Container(
                        child: 
                        new ElevatedButton(
                            onPressed: () {
                              users.doc(list.docs[index].get('id'))
                                  .update({'autorizado': true, 'disponível para validação': false})
                                  .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuária Validada!')),);
                                    getDocuments();
                                    Navigator.of(context).pop();
                                  });
                              },
                            child: const Text('Validar Usuária'),
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
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuária Recusada!')),);
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