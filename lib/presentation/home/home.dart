import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/gastos.dart';
import 'package:control_gastos/data/model/ingresos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:control_gastos/data/model/usuarios.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String nombreUsuario = "";
  int idUsuario = 0;
  String saldo = "";

  @override
  void initState() {
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
      nombreUsuario = usuarioActual.nombreUsuario;
      idUsuario = sesionActual.idUsuario;
    });
  }

  obtenerSaldo() async {
    List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    int _idUsuario = sesionActual.idUsuario;

    List<Ingresos> ingresos = await DB.obtenerIngresosPorIdUsuario(_idUsuario);

    List<Gastos> gastos = await DB.obtenerGastosPorIdUsuario(_idUsuario);

    if (ingresos.isEmpty) {
      setState(() {
        saldo = "0.0";
      });
    } else {
      //definir variable para almacenar la suma de los ingresos del usuario en sesion
      double sumaIngresos = 0.0;

      //se recorre la lista de ingresos del usuario en sesión, para sumar los ingresos
      ingresos.forEach((element) {
        sumaIngresos = sumaIngresos + element.ingreso;
      });

      //definir variable para almacenar la suma de los gastos del usuario en sesion
      double sumaGastos = 0.0;

      //se recorre la lista de gastos del usuario en sesión, para sumar los gastos
      gastos.forEach((element) {
        sumaGastos = sumaGastos + element.gasto;
      });

      /*for(int i =0; i <=gastos.length ; i++){
        sumaGastos = sumaGastos+gastos[i].gasto;
      }*/

      //el saldo es iguala a los ingresos menos los gastos
      double _saldo = sumaIngresos - sumaGastos;

      setState(() {
        //se cambia el valor de la variable saldo con el calculo almacenado en la variable  _saldo
        saldo = _saldo.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(children: [
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/fondo_home.png"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                  SizedBox(height: 50.0,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    alignment: Alignment.center ,
                    child: const Text(
                      "Bienvenid@ a la Aplicacion de Control de Gastos",
                       style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                      ),
                  ),

              SizedBox(height: 50.0,),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 300,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color(0xFF00E676),
                                  Color(0xFF69F0AE),
                                  Color(0xFF00B0FF),
                                  Color(0xFF0091EA),
                                ],
                              ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                        spreadRadius: 2.0,
                      )
                    ],
                  ),
                  child: Text(
                    "Hola " +
                        nombreUsuario.toString() +
                        "\nTu saldo es de \$" +
                        saldo.toString(),
                        textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ),
                  SizedBox(height: 500.0,),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
