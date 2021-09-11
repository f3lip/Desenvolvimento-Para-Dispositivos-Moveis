import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'validateemployee.dart';
import 'validateuser.dart';
import 'auth.dart';
import 'employeeregister.dart';
import 'userregister.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
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

/// This is the main application widget.
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

  Future<void> getUsersDocuments() async {
    usersList = await users.where('id', isEqualTo: user!.uid).get();
    setState(() {
      this.usersList = usersList;
    });
  }

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
    user = _auth.currentUser!;
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
  }

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
                        NetworkImage(''),
                        ),
                        title: Text(this.employeesList.docs[index].get('nome de prestadora')),
                        subtitle: Text(this.employeesList.docs[index].get('email de prestadora')),
                        children: [
                          new Container(
                            child: new Text('data'),
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