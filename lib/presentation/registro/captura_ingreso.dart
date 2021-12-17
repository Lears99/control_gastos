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
                        const SnackBar(content: Text('Guardando Ingreso...')),
                      );

                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));

}

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    final txtIngreso = TextEditingController();
    final txtReferencia = TextEditingController();

     return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/fondo_ingreso.jpg"),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ListView(
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Añada un Ingreso",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/ingresos.png",
                              width: 500,
                              height: 200,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: txtIngreso,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]+|\s'),
                              ),
                            ],
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Favor de ingresar un valor';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Ingrese un valor',
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.monetization_on_sharp,
                                    color: Colors.yellowAccent),
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                          TextFormField(
                            controller: txtReferencia,

                            autocorrect: true,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(
                                    r'[0-9A-Za-zäÄëËïÏöÖüÜáéíóúáéíóúÁÉÍÓÚÂÊÎÔÛâêîôûàèìòùÀÈÌÒÙ\u00f1]+|\s'),
                              ),
                            ],
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Favor de ingresar una Referencia del ingreso';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Referencia',
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.call_missed_outgoing,
                                    color: Colors.blue),
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Valida que las cajas de texto tengan valor
                              if (_formKey.currentState!.validate()) {
                                //obtener lo que se capturó en la caja de texto de gasto
                                double _txtGasto = double.parse(txtIngreso.text);

                                //obtener lo que se capturó en la caja de texto de concepto
                                String _txtConcepto = txtReferencia.text;

                                insertarIngreso(_txtGasto, _txtConcepto);
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
                                  'Guardar Ingreso',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 300.0,
                          ),

                          /* Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed:listarUsuarios
                   ,
                  child: const Text('Listar'),
                ),
              )*/
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}