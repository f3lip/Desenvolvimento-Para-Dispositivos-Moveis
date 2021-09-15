import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'validateemployee.dart';
import 'validateuser.dart';
import 'auth.dart';
import 'employeeregister.dart';
import 'userregister.dart';

/// Método main que inicializa o aplicativo, realizando os procedimentos
/// necessários para que o firebase funcione, e para que as rotas de acesso
/// as telas do app estejam disponíveis
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: 'Home',
    routes: {
      'Home': (context) => MyApp(),
      'Login': (context) => SignInPage(),
      'Prestadora de Serviços': (context) => EmployeeRegister(),
      'Registro de Usuária': (context) => UserRegister(),
      'Validar Usuárias': (context) => ValidateUser(),
      'Validar Prestadoras de Serviços': (context) => ValidateEmployee(),
    },
  ));
}

/// Classe principal do aplicativo
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  State<MyApp> createState()  => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CollectionReference users = FirebaseFirestore.instance.collection('usuários');
  CollectionReference employees = FirebaseFirestore.instance.collection('prestadora de serviços');
  late QuerySnapshot usersList;
  late QuerySnapshot employeesList;

  static const String _title = "Woman's Service";

  User? user;
  int selectedIndex = 0;

  /// Gera o body que conta com a animação de carregamento da tela, vigente
  /// enquanto o carregamento dos dados necessários para uso da tela principal
  /// não é concluído
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

  /// Gera o body que conta com o aviso de que é necessário realizar login para
  /// visualizar a tela principal
  Widget pendingLogin(){
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Column(
                  children: [
                    new Container(child: new Icon(Icons.warning_amber_outlined)),
                    new Container(child: new Text("")),
                    new Container(child: new Text("Faça login para visualizar.")),
                  ],
                )
              ],
            )],
          ),
        )
    );
  }

  /// Gera o body que conta com o aviso de que a usuária ainda não foi validada,
  /// e, portanto, não pode visualizar as prestadoras de serviços
  Widget pendingPermission() {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Column(children:[
                  new Container(child: new Icon(Icons.visibility_off)),
                  new Container(child: new Text("")),
                  new Container(child: new Text("Visualização desabilitada. Usuário ainda não validado.")),
                ]
                ),
              ],
            )],
          ),
        )
    );
  }

  /// Método para obter os dados da usuária em banco de dados
  Future<void> getUsersDocuments() async {
    usersList = await users.where('id', isEqualTo: user!.uid).get();
    setState(() {
      this.usersList = usersList;
    });
  }

  /// Método para atualizar o body da tela de acordo com o estado do app: se a
  /// usuária não realizou login, se não possui permissões, e se realizou o
  /// login e está autorizada a visualizar as prestadoras de serviços
  Future<void> updateBody() async {
    if (user == null) {
      this._body = pendingLogin();
    } else {
      if (usersList.docs[0].get('autorizado') == true) {
        this._body = showEmployees();
      } else {
        this._body = pendingPermission();
      }
    }
  }

  /// Método para obter os dados de prestadoras de serviços em banco de dados e
  /// solicitar a atualização da tela
  Future<void> getEmployeesDocuments() async {
    employeesList = await employees.where('autorizado', isEqualTo: true).get();
    setState(() {
      this.employeesList = employeesList;
    });
  }

  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    if(user != null){
      getUsersDocuments().whenComplete(() {
        setState(() {
          updateBody();
        });
      });
      getEmployeesDocuments().whenComplete(() {
        setState(() {
          updateBody();
        });
      });
    } else{
      updateBody();
    }
  }

  /// Tela principal do app, onde o body será substituído de acordo com o
  /// carregamento da página e com as permissões da usuária
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
                _title,
                style: TextStyle(color: Colors.white),
            )
        ),
        body: this._body,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (int index) {setState(() {
            this.selectedIndex = index;
            if(index == 1) {
              Navigator.pushNamed(context, 'Login').then((_) {
                setState(() {
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  this.user = _auth.currentUser;
                  this.selectedIndex = 0;
                  getUsersDocuments().whenComplete(() {
                    getEmployeesDocuments().whenComplete(() => updateBody());
                  });
                });
              });
            }
          });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Página Inicial"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Minha Conta"
            ),
          ],
        ),
      ),
      theme: new ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: const Color(0xFFffc107),
      ),
    );
  }

  /// Gera, dinamicamente, a lista de prestadoras de serviços, a partir da
  /// consulta em banco de dados
  Widget showEmployees() {
    return Scaffold(
        body: new Column(
          children: <Widget>[
            new Expanded(
                child: new ListView.builder (
                  itemCount: this.employeesList.size,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                      child: ExpansionTile(
                        leading: CircleAvatar(backgroundImage:
                        NetworkImage(this.employeesList.docs[index].get('foto')),
                        ),
                        title: Text(this.employeesList.docs[index].get('nome de prestadora')),
                        subtitle: Text(this.employeesList.docs[index].get('serviço prestado')),
                        children: [
                          new Container(
                            child: new Text(this.employeesList.docs[index].get('serviço prestado')),
                          ),
                          new Container(
                            child: new Text(''),
                          ),
                          new Container(
                            child: new Text('Nome: ' + this.employeesList.docs[index].get('nome de prestadora')),
                          ),
                          new Container(
                            child: new Text(''),
                          ),
                          new Container(
                            child: new Text('CPF/CNPJ: ' + this.employeesList.docs[index].get('cpfcnpj')),
                          ),
                          new Container(
                            child: new Text(''),
                          ),
                          new Container(
                            child: new Text('E-mail: ' + this.employeesList.docs[index].get('email de prestadora')),
                          ),
                          new Container(
                            child: new Text(''),
                          ),
                          new Container(
                            child: new Text('Estado de Atuação: ' + this.employeesList.docs[index].get('estado de atuação')),
                          ),
                          new Container(
                            child: new Text(''),
                          ),
                          new Container(
                            child: new Text('Município de Atuação: ' + this.employeesList.docs[index].get('município de atuação')),
                          ),
                          new Container(
                            child: new Text(''),
                          ),
                          new Container(
                            child: new Text('Telefone: ' + this.employeesList.docs[index].get('telefone')),
                          ),
                          new Container(
                            child: new Text(''),
                          ),
                          new Container(
                            child: new Text('Celular: ' + this.employeesList.docs[index].get('celular')),
                          ),
                          new Container(
                            child: new Text(''),
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