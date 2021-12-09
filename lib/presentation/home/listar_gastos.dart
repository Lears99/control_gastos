import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/gastos.dart';
import 'package:control_gastos/data/model/ingresos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:flutter/material.dart';


class ListaGastos extends StatefulWidget{
  const ListaGastos({Key? key}) : super(key: key);
  
  @override
  ListaGastosState createState() => ListaGastosState();
}

class ListaGastosState extends State<ListaGastos>{

 List<Gastos> listaGastos = [];
  
   @override
  void initState(){
    super.initState();
    obtenerListaGastos();
  }

  obtenerListaGastos() async {
    List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    int _idUsuario = sesionActual.idUsuario;

    List<Gastos> _listaGastos = await DB.obtenerGastosPorIdUsuario(_idUsuario);

    setState(() {
      listaGastos = _listaGastos;
    });

  }

  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Lista de Gastos"),
            ),
            body: ListView.builder(
              itemCount: listaGastos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text((index+1).toString()+") gasto: "+listaGastos[index].gasto.toString()+"      concepto: "+listaGastos[index].concepto),
                );
              },
            )
        )
    );
  }

}
