import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = "Woman's Service";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatelessWidget(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
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
        accentColor: const Color(0xFFffc107),
        canvasColor: const Color(0xFFfafafa),
      ),

    );
  }
}

/// This is the stateless widget that the main application instantiates.
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