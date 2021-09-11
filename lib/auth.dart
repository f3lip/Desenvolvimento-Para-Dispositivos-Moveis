import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final FirebaseAuth _auth = FirebaseAuth.instance;

CollectionReference users = FirebaseFirestore.instance.collection('usuários');
CollectionReference employees = FirebaseFirestore.instance.collection('prestadoras de serviço');


class SignInPage extends StatefulWidget {
  final String title = 'Login';
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  User? user;

  bool registerAsEmployee = false;
  bool registerAsUser = false;
  bool validateUser = false;
  bool validateEmployee = false;

  Future<void> userHasPermissionToValidateUser(User? user) async {
    if(user != null){
      DocumentSnapshot result = await users.doc(user.uid).get();
      if(result.get('usuário validador')) {
        setState(() {
          validateUser = true;
        });
      }
    } else{
      validateUser = false;
    }
  }

  Future<void> userHasPermissionToRegister(User? user) async {
    if(user != null){
      DocumentSnapshot result = await users.doc(user.uid).get();
      if(result.get('disponível para validação') == false && result.get('autorizado') == false){
        setState(() {
          registerAsUser = true;
        });
      }
    } else{
      registerAsUser = false;
    }
  }

  Future<void> userHasPermissionToRegisterAsEmployee(User? user) async {
    if(user != null){
      DocumentSnapshot result = await users.doc(user.uid).get();
      if(result.get('autorizado') == true) {
        setState(() {
          registerAsEmployee = true;
        });
      }
    } else{
      registerAsEmployee = false;
    }
  }

  Future<void> userHasPermissionToValidateEmployee(User? user) async {
    if(user != null){
      DocumentSnapshot result = await users.doc(user.uid).get();
      if(result.get('usuário validador') == true) {
        setState(() {
          validateEmployee = true;
        });
      }
    } else{
      validateEmployee = false;
    }
  }

  @override
  void initState() {
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  Future<void> checkPermissions() async {
    await userHasPermissionToRegister(this.user);
    await userHasPermissionToRegisterAsEmployee(this.user);
    await userHasPermissionToValidateUser(this.user);
    await userHasPermissionToValidateEmployee(this.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                final User? user = _auth.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Nenhum usuário logado.', textAlign: TextAlign.center),
                  ));
                  return;
                }
                await _signOut();

                final String uid = user.uid;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$uid deslogou com sucesso.'),
                ));
              },
              child: const Text('Sair'),
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            _UserInfoCard(user),
            _OtherProvidersSignInSection(user, checkPermissions()),
            Visibility(visible: (this.registerAsEmployee == true), child: _EmployeeRegister(user)),
            Visibility(visible: (this.registerAsUser == true), child: _UserRegister(user)),
            Visibility(visible: (this.validateUser == true), child: _ValidateUser(user)),
            Visibility(visible: (this.validateEmployee == true), child: _ValidateEmployee(user)),
          ],
        );
      }),
    );
  }

  // Example code for sign out.
  Future<void> _signOut() async {
    await _auth.signOut();
  }
}

class _UserInfoCard extends StatefulWidget {
  final User? user;

  const _UserInfoCard(this.user);

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<_UserInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.center,
              child: const Text(
                'Informações do Usuário',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.user != null)
              if (widget.user?.photoURL != null)
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 8),
                )
              else
                Align(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.black,
                    child: const Text(
                      'Nenhuma imagem',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            if (widget.user != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var provider in widget.user!.providerData)
                    Dismissible(
                      key: Key(provider.uid!),
                      onDismissed: (action) =>
                          widget.user!.unlink(provider.providerId),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: provider.photoURL == null
                              ? IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () =>
                                  widget.user!.unlink(provider.providerId))
                              : Image.network(provider.photoURL!),
                          subtitle: Text(
                                  "${provider.email == null ? "" : "Email: ${provider.email}\n"}"
                                  "${provider.displayName == null ? "" : "Name: ${provider.displayName}\n"}"),
                          isThreeLine: true,
                        ),
                      ),
                    ),
                ],
              ),
            Visibility(
              visible: widget.user != null,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => widget.user?.reload(),
                      icon: const Icon(Icons.refresh),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => UpdateUserDialog(widget.user),
                      ),
                      icon: const Icon(Icons.text_snippet),
                    ),
                    IconButton(
                      onPressed: () => widget.user?.delete(),
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateUserDialog extends StatefulWidget {
  final User? user;

  const UpdateUserDialog(this.user);

  @override
  _UpdateUserDialogState createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _urlController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user?.displayName);
    _urlController = TextEditingController(text: widget.user?.photoURL);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update profile'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: _nameController,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'displayName'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.user?.updateProfile(
                displayName: _nameController.text,
                photoURL: _urlController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        )
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}

class _OtherProvidersSignInSection extends StatefulWidget {
  final User? user;
  final Future<void> checkPermissions;
  _OtherProvidersSignInSection(this.user, this.checkPermissions);

  @override
  State<StatefulWidget> createState() => _OtherProvidersSignInSectionState();
}

class _OtherProvidersSignInSectionState extends State<_OtherProvidersSignInSection> {


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Visibility(
        visible: widget.user == null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: SignInButton(Buttons.Google,
                  text: 'Sign in with Google',
                  onPressed: () {
                    _signInWithGoogle();
                    widget.checkPermissions;
                  },
                )
            ),
          ]
      ),),

    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign In ${user?.uid} with Google'),
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google: $e'),
        ),
      );
    }
  }
}

class _EmployeeRegister extends StatefulWidget {
  final User? user;

  _EmployeeRegister(this.user);

  @override
  State<StatefulWidget> createState() => _EmployeeRegisterState();
}

class _EmployeeRegisterState extends State<_EmployeeRegister> {


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child:
              TextButton(onPressed: () { Navigator.of(context).pushNamed('Prestadora de Serviços'); },
                child: Text("Seja uma Prestadora de Serviços"),),
              ),
            ]
        ),
    );
  }
}

class _UserRegister extends StatefulWidget {
  final User? user;
  _UserRegister(this.user);

  @override
  State<StatefulWidget> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<_UserRegister> {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child:
              TextButton(onPressed: () { Navigator.of(context).pushNamed('Registro de Usuária'); },
                child: Text("Solicitar Validação de Cadastro"),),
            ),
          ]
      ),
    );
  }
}

class _ValidateUser extends StatefulWidget {
  final User? user;
  _ValidateUser(this.user);

  @override
  State<StatefulWidget> createState() => _ValidateUserState();
}

class _ValidateUserState extends State<_ValidateUser> {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child:
              TextButton(onPressed: () { Navigator.of(context).pushNamed('Validar Usuárias'); },
                child: Text("Validar Usuárias"),),
            ),
          ]
      ),
    );
  }
}

class _ValidateEmployee extends StatefulWidget {
  final User? user;
  _ValidateEmployee(this.user);

  @override
  State<StatefulWidget> createState() => _ValidateEmployeeState();
}

class _ValidateEmployeeState extends State<_ValidateEmployee> {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child:
              TextButton(onPressed: () { Navigator.of(context).pushNamed('Validar Prestadoras de Serviços'); },
                child: Text("Validar Prestadoras de Serviços"),),
            ),
          ]
      ),
    );
  }
}