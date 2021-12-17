import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/data/model/gastos.dart';
import 'package:control_gastos/data/model/ingresos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:control_gastos/presentation/home/my_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CapturaGasto extends StatefulWidget {
  const CapturaGasto({Key? key}) : super(key: key);

  @override
  _CapturaGastoState createState() => _CapturaGastoState();
}

class _CapturaGastoState extends State<CapturaGasto> {
  final titleDialog = 'APP Gastos';
  final mssgDialog = 'Saldo insuficiente';

  listarGastos() async {
    List<Gastos> listaGastos = await DB.obtenerGastos();

    listaGastos.forEach((element) {
      print(element.toMap());
    });
  }

  insertarGasto(double _gasto, String _concepto) async {
    List<Sesion> sesion = await DB.obtenerSesion();

    Sesion sesionActual = sesion[0];
    int _idUsuario = sesionActual.idUsuario;

    List<Ingresos> ingresos = await DB.obtenerIngresosPorIdUsuario(_idUsuario);

    List<Gastos> gastos = await DB.obtenerGastosPorIdUsuario(_idUsuario);

    if (ingresos.isEmpty) {
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

      //el saldo es igual a a los ingresos menos los gastos
      double _saldo = sumaIngresos - sumaGastos;

      if (_gasto > _saldo) {
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
      } else {
        Gastos gastos = Gastos(
            id: null,
            idUsuario: _idUsuario,
            gasto: _gasto,
            concepto: _concepto);

        print('Guardando tu Gasto...');
        DB.insertGasto(gastos);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardando Gasto...')),
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHome()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final txtGasto = TextEditingController();
    final txtConcepto = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/fondo_gastos.jpg"),
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
                              "Registre un Gasto",
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
                              "assets/images/gastos.png",
                              width: 500,
                              height: 200,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: txtGasto,
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
                                return 'Favor de ingresar un Gasto';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Ingrese un gasto',
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.monetization_on_sharp,
                                    color: Colors.yellowAccent),
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                          TextFormField(
                            controller: txtConcepto,

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
                                return 'Favor de ingresar Concepto del gasto';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Concepto',
                                contentPadding: EdgeInsets.all(20),
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.shopping_bag_outlined,
                                    color: Colors.pinkAccent),
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
                                double _txtGasto = double.parse(txtGasto.text);

                                //obtener lo que se capturó en la caja de texto de concepto
                                String _txtConcepto = txtConcepto.text;

                                insertarGasto(_txtGasto, _txtConcepto);
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
                                  'Guardar Gasto',
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
