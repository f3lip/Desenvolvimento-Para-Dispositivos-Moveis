import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Instanciamento de variáveis de conexão com a autenticação e com o banco de dados do firebase
final FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('usuários');
CollectionReference employees = FirebaseFirestore.instance.collection('prestadoras de serviço');

/// Classe principal da página 'Minha Conta'
class SignInPage extends StatefulWidget {
  final String title = 'Minha Conta';
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

  /// Verifica se a usuária conta com permissão de validar usuárias
  Future<void> userHasPermissionToValidateUser(User? user) async {
    if(user != null){
      DocumentSnapshot result;
      var resulttemp = false;
      try{
        result = await users.doc(user.uid).get();
        resulttemp = result.get('usuário validador');
      } catch(e){}
      if(resulttemp) {
        setState(() {
          validateUser = true;
        });
      }
    } else{
      validateUser = false;
    }
  }

  /// Verifica se a usuária conta com permissão para solicitar validação de cadastro
  Future<void> userHasPermissionToRegister(User? user) async {
    if(user != null){
      try{
        DocumentSnapshot result = await users.doc(user.uid).get();
        if((result.get('disponível para validação') == false) && (result.get('autorizado') == false)){
          setState(() {
            registerAsUser = true;
          });
        } else{
          setState(() {
            registerAsUser = false;
          });
        }
      } catch (e){
        setState(() {
          registerAsUser = true;
        });
      }
    } else{
      registerAsUser = false;
    }
  }

  /// Verifica se a usuária conta com permissão de solicitar registro como prestadora de serviços
  Future<void> userHasPermissionToRegisterAsEmployee(User? user) async {
    if(user != null){
      DocumentSnapshot result;
      var resulttemp = false;
      try{
        result = await users.doc(user.uid).get();
        resulttemp = result.get('autorizado');
      } catch (e){}
      if(resulttemp == true) {
        setState(() {
          registerAsEmployee = true;
        });
      }
    } else{
      registerAsEmployee = false;
    }
  }

  /// Verifica se a usuária conta com permissão para validar solicitações de registro de prestadoras de serviços
  Future<void> userHasPermissionToValidateEmployee(User? user) async {
    if(user != null){
      DocumentSnapshot result;
      var resulttemp = false;
      try{
        result = await users.doc(user.uid).get();
        resulttemp = result.get('usuário validador');
      } catch(e){}
      if(resulttemp == true) {
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

  /// Método para chamar todas as verificações de permissão da usuária
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

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Deslogou com sucesso!'),
                ));
              },
              child: Visibility(visible: this.user !=null, child: const Text('Sair', style: TextStyle(color: Colors.white))),
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            Visibility(visible: this.user != null, child: _UserInfoCard(user)),
            Visibility(visible: this.user == null, child: _SignInWithGoogle(user, checkPermissions())),
            Visibility(visible: (this.registerAsEmployee == true), child: _EmployeeRegister(user, checkPermissions)),
            Visibility(visible: (this.registerAsUser == true), child: _UserRegister(user, checkPermissions)),
            Visibility(visible: (this.validateUser == true), child: _ValidateUser(user)),
            Visibility(visible: (this.validateEmployee == true), child: _ValidateEmployee(user)),
          ],
        );
      }),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
  }
}

/// Gera o card que mostra informações sobre a usuária
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
                'Informações da Usuária',
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
                          subtitle: Text("${provider.displayName == null ? "" : "Name: ${provider.displayName}\n"}" "${provider.email == null ? "" : "Email: ${provider.email}\n"}"),
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

/// Gera os botões de atualizar, editar e excluir conta
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
      title: const Text('Atualizar perfil'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: _nameController,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'Nome:'),
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
          child: const Text('Atualizar'),
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

/// Gera o card que traz a opção de login com conta Google
class _SignInWithGoogle extends StatefulWidget {
  final User? user;
  final Future<void> checkPermissions;
  _SignInWithGoogle(this.user, this.checkPermissions);

  @override
  State<StatefulWidget> createState() => _SignInWithGoogleState();
}

class _SignInWithGoogleState extends State<_SignInWithGoogle> {


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
                  onPressed: () async {
                    await _signInWithGoogle();
                    setState(() {
                      widget.checkPermissions;
                    });
                  },
                )
            ),
          ]
        ),
      ),
    );
  }

  /// Método para realizar o login com Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(googleAuthCredential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login realizado com sucesso!'),
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Houve uma falha ao logar: $e'),
        ),
      );
    }
  }
}

/// Gera o card com o acesso para solicitar registro como prestadora de serviços
class _EmployeeRegister extends StatefulWidget {

  final User? user;
  final Future<void> Function() checkPermissions;
  _EmployeeRegister(this.user, this.checkPermissions);

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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('Prestadora de Serviços')
                      .then((value) => widget.checkPermissions());
                },
                child: Text("Seja uma Prestadora de Serviços"),),
              ),
            ]
        ),
    );
  }
}

/// Gera o card com o acesso para solicitar validação de cadastro
class _UserRegister extends StatefulWidget {
  final User? user;
  final Future<void> Function() checkPermissions;
  _UserRegister(this.user, this.checkPermissions);

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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('Registro de Usuária')
                      .whenComplete(() => widget.checkPermissions());
                  },
                child: Text("Solicitar Validação de Cadastro"),),
            ),
          ]
      ),
    );
  }
}

/// Gera o card com o acesso para validar usuárias
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

/// Gera o card com o acesso para validar solicitação de prestadora de serviços
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