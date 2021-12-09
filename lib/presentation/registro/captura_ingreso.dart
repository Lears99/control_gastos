import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/ingresos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:control_gastos/presentation/home/my_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CapturaIngreso extends StatefulWidget{
  const CapturaIngreso({Key? key}) : super(key: key);
  
  @override
  _CapturaIngresoState createState() => _CapturaIngresoState();
}

class _CapturaIngresoState extends State <CapturaIngreso>{

  int idUsuario = 0;
  @override
  void initState(){
    super.initState();

  }

  obtenerNombreUsuario() async {
    List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    idUsuario = sesionActual.idUsuario;

    setState(() {
      idUsuario = sesionActual.idUsuario;
    });

  }


listarIngresos() async {
List<Ingresos> listaIngresos = await DB.obtenerIngreso();

listaIngresos.forEach((element){
print(element.toMap());
});

}

insertarIngreso (double _ingreso, String _referencia) async {
   List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    int _idUsuario = sesionActual.idUsuario;

  Ingresos ingreso = Ingresos(id: null, idUsuario: _idUsuario, ingreso: _ingreso , referencia: _referencia);
                      
                      print('guardando Ingreso...');
                      DB.insertIngreso(ingreso);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('guardando...')),
                      );

                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));

}

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    final txtIngreso = TextEditingController();
    final txtReferencia = TextEditingController();

    return MaterialApp(
      title: 'captura de ingreso.',
       home: Scaffold(
         appBar: AppBar(
          title: const Text('captura de ingreso.'),
        ),
        body: SingleChildScrollView(
           child: Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 TextFormField(
                   controller: txtIngreso,
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
                    label: Text("Ingreso:")),
              ),
              TextFormField(
                controller: txtReferencia,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z]+|\s'),
                  ),
                ],
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Favor de ingresar Referencia';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle_sharp), label: Text("Referencia:")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Valida que las cajas de texto tengan valor
                    if (_formKey.currentState!.validate()) {
                      //obtener lo que se capturó en la caja de texto de gasto
                      double _txtIngreso = double.parse(txtIngreso.text);

                      //obtener lo que se capturó en la caja de texto de concepto
                      String _txtReferencia = txtReferencia.text;

                      insertarIngreso(_txtIngreso, _txtReferencia);

                    }
                  },
                  child: const Text('Guardar Ingreso'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed:listarIngresos
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