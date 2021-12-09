
import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/gastos.dart';
import 'package:control_gastos/data/model/ingresos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:control_gastos/presentation/home/my_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CapturaGasto extends StatefulWidget{
  const CapturaGasto({Key? key}) : super(key: key);

   @override
  _CapturaGastoState createState() => _CapturaGastoState();
}

class _CapturaGastoState extends State <CapturaGasto>{
  final titleDialog = 'APP Gastos';
  final mssgDialog = 'Saldo insuficiente';

listarGastos() async {
List<Gastos> listaGastos = await DB.obtenerGastos();

listaGastos.forEach((element) {
print(element.toMap());
});

}

insertarGasto (double _gasto, String _concepto) async {
   List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    int _idUsuario = sesionActual.idUsuario;

    List<Ingresos> ingresos = await DB.obtenerIngresosPorIdUsuario(_idUsuario);

    List<Gastos> gastos = await DB.obtenerGastosPorIdUsuario(_idUsuario);
    
    if(ingresos.isEmpty){
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
      
      if(_gasto > _saldo){
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
      }else{
         Gastos gastos = Gastos(id: null, idUsuario: _idUsuario, gasto: _gasto , concepto: _concepto);
                      
                      print('guardando tu Gasto...');
                      DB.insertGasto(gastos);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('guardando...')),
                      );

                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));

      }
    }
}

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    final txtGasto = TextEditingController();
    final txtConcepto = TextEditingController();

    return MaterialApp(
      title: 'captura de gasto.',
       home: Scaffold(
         appBar: AppBar(
          title: const Text('captura de gasto.'),
        ),
        body: SingleChildScrollView(
           child: Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 TextFormField(
                   controller: txtGasto,
                   inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]+|\s'),
                  ),
                ],
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Favor de ingresar Valor';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    icon: Icon(Icons.money), 
                    label: Text("Gasto:")),
              ),
              TextFormField(
                controller: txtConcepto,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z]+|\s'),
                  ),
                ],
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Favor de ingresar Concepto';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle_sharp), label: Text("Concepto:")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Valida que las cajas de texto tengan valor
                    if (_formKey.currentState!.validate()) {
                      //obtener lo que se capturó en la caja de texto de gasto
                      double _txtGasto =  double.parse(txtGasto.text);

                      //obtener lo que se capturó en la caja de texto de concepto
                      String _txtConcepto = txtConcepto.text;

                      insertarGasto(_txtGasto, _txtConcepto);
                     
                    }
                  },
                  child: const Text('Guardar Gasto'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed:listarGastos
                   ,
                  child: const Text('Listar'),
                ),
              )
               ]
             )
           )
        )
       )
    );
  }

}