import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:control_gastos/presentation/home/my_home.dart';
import 'package:control_gastos/presentation/login/login.dart';
import 'package:flutter/material.dart';


class Inicio extends StatefulWidget{
  const Inicio({Key? key}) : super(key: key);
  
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio>{

  String nombreUsuario ="";
  
   @override
  void initState(){
    super.initState();
    sesionActivada();

  }

  sesionActivada() async {
    //se recuperan los reistro de la tabla sesión
    List<Sesion> sesion = await DB.obtenerSesion();

    if(sesion.isEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
    }

  }

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    
    return MaterialApp(
      title: 'App Gastos',
       home: Scaffold(
         appBar: AppBar(
          title: const Text('Cargando...'),
        ),
        body: SingleChildScrollView(
           child: Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text(""),
               ]
             )
           )
        )
       )
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