import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'employeeregister.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: 'Home',
    routes: {
      'Home': (context) => const MyApp(),
      'Login': (context) => SignInPage(),
      'Prestadora de Serviços': (context) => EmployeeRegister(),
    },
  ));
}

/// This is the main application widget.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  State<MyApp> createState()  => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const String _title = "Woman's Service";

  int selectedIndex = 0;

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
        body: const MyStatelessWidget(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (int index) {setState(() {
            this.selectedIndex = index;
            if(index == 2) {
              Navigator.pushNamed(context, 'Login');
            }
          });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Página Inicial"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favoritos"
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
        //accentColor: const Color(0xFFffc107),
        //canvasColor: const Color(0xFFfafafa),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage:
            NetworkImage("",),
            ),
            title: Text('Pessoa 1'),
            subtitle: Text(
                'Legenda'
            ),
            trailing: Icon(Icons.add_call),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage:
            NetworkImage("",),
            ),
            title: Text('Pessoa 2'),
            subtitle: Text(
                'Legenda'
            ),
            trailing: Icon(Icons.add_call),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage:
            NetworkImage("",),
            ),
            title: Text('Pessoa 3'),
            subtitle: Text(
                'Legenda'
            ),
            trailing: Icon(Icons.add_call),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage:
            NetworkImage("",),
            ),
            title: Text('Pessoa 4'),
            subtitle: Text(
                'Legenda'
            ),
            trailing: Icon(Icons.add_call),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage:
            NetworkImage("",),
            ),
            title: Text('Pessoa 5'),
            subtitle: Text(
                'Legenda'
            ),
            trailing: Icon(Icons.add_call),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage:
            NetworkImage("",),
            ),
            title: Text('Pessoa 6'),
            subtitle: Text(
                'Legenda'
            ),
            trailing: Icon(Icons.add_call),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage:
            NetworkImage("",),
            ),
            title: Text('Pessoa 7'),
            subtitle: Text(
                'Legenda'
            ),
            trailing: Icon(Icons.add_call),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage:
            NetworkImage("",),
            ),
            title: Text('Pessoa 8'),
            subtitle: Text(
                'Legenda'
            ),
            trailing: Icon(Icons.add_call),
            isThreeLine: true,
          ),
        ),
      ],
    );
  }
}