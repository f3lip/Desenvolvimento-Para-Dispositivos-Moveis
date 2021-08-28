import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeRegister extends StatelessWidget{
  const EmployeeRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prestadora de Serviços'),
        backgroundColor: Colors.amber,
    ),
      body: Padding(
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

  FocusNode myFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void _requestFocus(){
    setState(() {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ListTile(
            title: Text('Cadastro de Prestadora de Serviços', textAlign: TextAlign.center,),
          ),
          TextFormField(
            textAlign: TextAlign.center,
            focusNode: myFocusNode,
            onTap: _requestFocus,
            decoration: InputDecoration(
              labelText: 'Nome *',
              labelStyle: TextStyle(
                color: myFocusNode.hasFocus ? Colors.amber : Colors.grey
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
            focusNode: myFocusNode,
            onTap: _requestFocus,
            decoration: InputDecoration(
              labelText: 'Sobrenome *',
              labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.amber : Colors.grey
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (lastname) {
              if (lastname == null || lastname.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            focusNode: myFocusNode,
            onTap: _requestFocus,
            decoration: InputDecoration(
              labelText: 'Nome *',
              labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.amber : Colors.grey
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            focusNode: myFocusNode,
            onTap: _requestFocus,
            decoration: InputDecoration(
              labelText: 'Nome *',
              labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.amber : Colors.grey
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            focusNode: myFocusNode,
            onTap: _requestFocus,
            decoration: InputDecoration(
              labelText: 'Nome *',
              labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.amber : Colors.grey
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            focusNode: myFocusNode,
            onTap: _requestFocus,
            decoration: InputDecoration(
              labelText: 'Nome *',
              labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.amber : Colors.grey
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            focusNode: myFocusNode,
            onTap: _requestFocus,
            decoration: InputDecoration(
              labelText: 'Nome *',
              labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.amber : Colors.grey
              ),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'O campo deve ser preenchido';
              }
              return null;
            },
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