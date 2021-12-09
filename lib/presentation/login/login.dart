import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:control_gastos/data/model/usuarios.dart';
import 'package:control_gastos/presentation/home/my_home.dart';
import 'package:control_gastos/presentation/registro/captura_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    const appTitle = 'Inicio de Sesión';
    const titleDialog = 'APP Gastos';
    const mssgDialog = 'Datos incorrectos';
    TextEditingController txtUsuario = new TextEditingController();
    TextEditingController txtContra = new TextEditingController();

    iniciarSesion(String nombreUsuario, String contra) async {
      List<Usuarios> listaUsuarios = await DB.obtenerUsuarioIniciarSesion(nombreUsuario, contra);
      
      if(listaUsuarios.isNotEmpty){
        //Se recorre los usuarios para mostrar en consolo, solo deberia mostrar uno
        listaUsuarios.forEach((element) { print(element.toMap());});

        //se obtiene el usuario del indice 0
        Usuarios usuario = listaUsuarios[0];

        //se crea un objeto de tipo sesion
        Sesion sesionUsuario = Sesion(id: null, idUsuario: usuario.idUsuario! , sesionActiva: 1);

        //se inserta la sesión en la tabla sesion
        await DB.insertSesion(sesionUsuario);

        //se redirecciona a la pagina del home
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
    }else{
      //si la lista está vacia, se muestra mensaje de datosincorrectos
      //porque no se econtró usuario registrado con los datos ingresados
      showDialog(context: context, 
                  builder: (BuildContext context){
        return AlertDialog(
          title: Text(titleDialog),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(mssgDialog),
              ],
            ),
          ),
        );
      }
      );
    }
    
}

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(             
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: Image.asset(
                "assets/images/avatar.jpg",
                width: 250,
                height: 250,
              ),
          ),
              
              TextFormField(
                controller: txtUsuario,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9a-zA-Z]+|\s'),
                  ),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Favor de ingresar nombre de usuario';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle),
                    label: Text("Nombre de Usuario")),
              ),
              TextFormField(
                controller: txtContra,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Favor de ingresar la contraseña';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    label: Text("Contraseña")),
              ),
              Container(             
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Procesando datos...')),
                      );
                      iniciarSesion(txtUsuario.text, txtContra.text);

                      // Navigator.push(context,
                      //    MaterialPageRoute(builder: (context) => MyHome()));
                    }
                  },
                  child: const Text('Iniciar sesión'),
                ),
          ),
          Container(             
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => CapturaUsuario()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0.0,
                    onPrimary: Colors.black
                    ),
                  child: const Text('Registrarse'),
                ),
          ),
            ],
          ),
        )),
      ),
    );
  }
}
