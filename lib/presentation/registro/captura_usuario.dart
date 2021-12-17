import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/usuarios.dart';
import 'package:control_gastos/presentation/login/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CapturaUsuario extends StatelessWidget {
  const CapturaUsuario({Key? key}) : super(key: key);

  listarUsuarios() async {
    //obtenemos la lista de usuarios de la BD
    //List<Usuarios> listaUsuarios = await DB.obtenerUsuarios();
    List<Usuarios> listaUsuarios = await DB.obtenerUsuarios();

    //recorremos la lista obtenida con ayuda del foreach
    listaUsuarios.forEach((element) {
      print(element.toMap());
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final txtNombreUsuario = TextEditingController();
    final txtCorreo = TextEditingController();
    final txtContra1 = TextEditingController();
    final txtContra2 = TextEditingController();
    const titleDialog = 'APP Gastos';
    const mssgDialog =
        'Nombre de Usuario ya existente. Favor de ingresar otro nombre de Usuario';

    registrarUsuarios(
        String _txtNombreUsuario, String _txtCorreo, String _txtContra) async {
      List<Usuarios> listaUsuarios =
          await DB.obtenerUsuarioPorNombreUsuario(_txtNombreUsuario);
      if (listaUsuarios.isEmpty) {
        Usuarios usuario = Usuarios(
            idUsuario: null,
            nombreUsuario: _txtNombreUsuario,
            contra: _txtContra,
            correo: _txtCorreo);

        DB.insertUsuario(usuario);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Usuario registrado! OwO")));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
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
            });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrate!'),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 15, bottom: 0),
                          child: Image.asset(
                            "assets/images/usuario2.png",
                            width: 500,
                            height: 180,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,),
                        TextFormField(
                          controller: txtNombreUsuario,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(
                                  r'[0-9A-Za-zäÄëËïÏöÖüÜáéíóúáéíóúÁÉÍÓÚÂÊÎÔÛâêîôûàèìòùÀÈÌÒÙ\u00f1]+|\s'),
                            ),
                          ],
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Favor de ingresar un Nombre de Usuario';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Nombre de Usuario',
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                          ),
                        ),
                        TextFormField(
                          controller: txtCorreo,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese un correo';
                            }
                            if (!StringAdm.validateEmail(value)) {
                              return 'Ingrese un correo válido';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Correo',
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                          ),
                        ),
                        TextFormField(
                          controller: txtContra1,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(
                                  r'[0-9A-Za-zäÄëËïÏöÖüÜáéíóúáéíóúÁÉÍÓÚÂÊÎÔÛâêîôûàèìòùÀÈÌÒÙ\u00f1]+|\s'),
                            ),
                          ],
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Favor de ingresar Contraseña';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                          ),
                        ),
                        TextFormField(
                          controller: txtContra2,
                          obscureText: true,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese una contraseña';
                            }
                            if (value != txtContra1.text) {
                              return "Las contraseñas no coinciden";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Confirmar Contraseña',
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Valida que las cajas de texto tengan valor
                            if (_formKey.currentState!.validate()) {
                              //obtener lo que se capturó en la caja de texto de nombre Usuario
                              String _txtNombreUsuario = txtNombreUsuario.text;

                              //obtener lo que se capturó en la caja de texto de correo
                              String _txtCorreo = txtCorreo.text;

                              //obtener lo que se capturó en la caja de texto de contraseña ya verificada
                              String _txtContra2 = txtContra2.text;

                              registrarUsuarios(
                                  _txtNombreUsuario, _txtCorreo, _txtContra2);
                            }
                          },
                          
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xFF00E676),
                                  Color(0xFF69F0AE),
                                  Color(0xFF00B0FF),
                                  Color(0xFF0091EA),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Center(
                              child: Text(
                                'Registrarse',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        

                        /* Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed:listarUsuarios
                   ,
                  child: const Text('Listar'),
                ),
              )*/
                      ]
                      ),
                      ),
            ),
          )
        ],
      ),
    );
  }
}

class StringAdm {
  static bool validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return (!regex.hasMatch(email)) ? false : true;
  }
}
