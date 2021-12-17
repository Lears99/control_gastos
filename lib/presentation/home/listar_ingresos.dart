import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/ingresos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:flutter/material.dart';


class ListaIngresos extends StatefulWidget{
  const ListaIngresos({Key? key}) : super(key: key);
  
  @override
  ListaIngresosState createState() => ListaIngresosState();
}

class ListaIngresosState extends State<ListaIngresos>{

 List<Ingresos> listaIngresos = [];
  
   @override
  void initState(){
    super.initState();
    obtenerListaIngresos();
  }

  obtenerListaIngresos() async {
    List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    int _idUsuario = sesionActual.idUsuario;

    List<Ingresos> _listaIngresos = await DB.obtenerIngresosPorIdUsuario(_idUsuario);

    setState(() {
      listaIngresos = _listaIngresos;
    });

  }

  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.greenAccent,
              title: const Center(child: Text("Lista de Ingresos",
              style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                    ),
              
                    ),
            ),
            body: ListView.builder(
              itemCount: listaIngresos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(radius: 23, backgroundColor: Colors.blue,  child: Icon(Icons.attach_money_sharp, color: Colors.white, ),),
                  title: Text((index+1).toString()+". Ingreso: \$"+listaIngresos[index].ingreso.toString()+"\nReferencia: "+listaIngresos[index].referencia,
                   style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            )
        )
    );
  }

}
