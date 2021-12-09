import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/gastos.dart';
import 'package:control_gastos/data/model/ingresos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:control_gastos/data/model/usuarios.dart';
import 'package:flutter/material.dart';


class HomeGasto extends StatefulWidget{
  const HomeGasto({Key? key}) : super(key: key);
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeGasto>{

  String nombreUsuario ="";
  int idUsuario = 0;
  String saldo = "";
  
   @override
  void initState(){
    super.initState();
    obtenerNombreUsuario();
    obtenerSaldo();

  }

  obtenerNombreUsuario() async {
    List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    idUsuario = sesionActual.idUsuario;

    List<Usuarios> usuario = await DB.obtenerUsuarioPorIdUsuario(idUsuario);
    Usuarios usuarioActual = usuario[0];
   // nombreUsuario = usuarioActual.nombreUsuario;

    setState(() {
      nombreUsuario =  usuarioActual.nombreUsuario;
      idUsuario = sesionActual.idUsuario;
    });

  }

  obtenerSaldo() async {
    List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    int _idUsuario = sesionActual.idUsuario;

    List<Ingresos> ingresos = await DB.obtenerIngresosPorIdUsuario(_idUsuario);

    List<Gastos> gastos = await DB.obtenerGastosPorIdUsuario(_idUsuario);
    
    if(ingresos.isEmpty){
      setState(() {
        saldo = "0.0";
      });
    }else{
      //definir variable para almacenar la suma de los ingresos del usuario en sesion
      double sumaIngresos = 0.0;

      //se recorre la lista de ingresos del usuario en sesión, para sumar los ingresos
      ingresos.forEach((element) { sumaIngresos = sumaIngresos + element.ingreso; });

      //definir variable para almacenar la suma de los gastos del usuario en sesion
      double sumaGastos = 0.0;

      //se recorre la lista de gastos del usuario en sesión, para sumar los gastos
      gastos.forEach((element) {sumaGastos = sumaGastos + element.gasto; });

      /*for(int i =0; i <=gastos.length ; i++){
        sumaGastos = sumaGastos+gastos[i].gasto;
      }*/
      
      //el saldo es iguala a los ingresos menos los gastos
      double _saldo= sumaIngresos-sumaGastos;

      setState(() {
        //se cambia el valor de la variable saldo con el calculo almacenado en la variable  _saldo
        saldo = _saldo.toString();
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();

    return MaterialApp(
      title: 'App Gastos',
       home: Scaffold(
         appBar: AppBar(
          title: const Text('My Home.'),
        ),
        body: SingleChildScrollView(
           child: Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text("Hola "+nombreUsuario),
                  Text("Tu saldo es de: "+saldo),
               ]
             )
           )
        )
       )
    );
  }

}
