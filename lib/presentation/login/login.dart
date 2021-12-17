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
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
              width: 420,
              height: 370,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cochinito.jpg'),
                  fit: BoxFit.cover
                  )
              ),
              child: Stack(
                children: const <Widget>[
                 Positioned(
                   left: 30.0,
                   bottom: 20.0,
                   child: Text(
                     'Inicio de Sesión',
                     style: TextStyle(
                       fontWeight: FontWeight.w600,
                       fontSize: 28.0,
                       letterSpacing: 1.5,
                       color: Colors.white,
                     ),
                   ),
                 ),  
                ],
              ),
            ),
                Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [     
            SizedBox(height: 20.0,),
              
               TextFormField(
                    controller: txtUsuario,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9A-Za-zäÄëËïÏöÖüÜáéíóúáéíóúÁÉÍÓÚÂÊÎÔÛâêîôûàèìòùÀÈÌÒÙ\u00f1]+|\s'),
                            ),
                    ],
                     validator: (value) {
                            if (value!.isEmpty) {
                              return 'Favor de ingresar el nombre de usuario';
                            }
                            return null;
                          },
                    decoration: const InputDecoration(
                      hintText: 'Nombre de Usuario',
                      prefixIcon: Icon(Icons.person, color: Colors.black),
      
                    ),
                    ),
                    SizedBox(height: 20.0,),

               TextFormField(
                    controller: txtContra,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9A-Za-zäÄëËïÏöÖüÜáéíóúáéíóúÁÉÍÓÚÂÊÎÔÛâêîôûàèìòùÀÈÌÒÙ\u00f1]+|\s'),
                            ),
                    ],
                     validator: (value) {
                            if (value!.isEmpty) {
                              return 'Favor de ingresar la contraseña';
                            }
                            return null;
                          },
                    decoration: const InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                    ),
                    ),
                     SizedBox(height: 20.0,),

             GestureDetector(
                      onTap: (){
                        if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Procesando datos...')),
                              );
                              iniciarSesion(txtUsuario.text, txtContra.text);
                            }
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[Color(0xFF00E676), Color(0xFF795578)],
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: const Center(
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ),

           SizedBox(height: 25.0,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CapturaUsuario()));
                    },
                    child: const Center( 
                      child: Text(
                      'Crear una nueva cuenta',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                    ),
                  ),
            ],
          ),
          ),
        ),
              ],
            ),
        ),
      ),
    );
  }
}
