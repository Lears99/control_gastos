import 'package:control_gastos/data/database/base_datos.dart';
import 'package:control_gastos/presentation/login/login.dart';
import 'package:flutter/material.dart';

class CerrarSesion extends StatelessWidget {
  const CerrarSesion({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    const appTitle = 'Cerrar Sesión';

    cerrarSesion() async {
    await DB.limpiarTablaSesion(); 
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
}

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
              width: 420,
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fondo_cerrar.jpg'),
                  fit: BoxFit.cover
                  )
              ),
              child: Stack(
                children: const <Widget>[
                 Positioned(
                   left: 30.0,
                   top: 25.0,
                   child: Text(
                     'Salir',
                     style: TextStyle(
                       fontWeight: FontWeight.w600,
                       fontSize: 35.0,
                       letterSpacing: 1.5,
                       color: Colors.black,
                     ),
                   ),
                 ),  
                ],
              ),
            ),
 
            Container(
              decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/fondo_cerrar2.jpg"),
                  fit: BoxFit.cover),
            ),
           child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [   
              
          SizedBox(height: 50.0,),

            Container( padding: const EdgeInsets.all(8.0),
                  width: 300,
                  height: 100,
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
                    "\"Control de Gastos\" Es una App que te ayuda a manejar y gestionar tus gastos e ingresos personales.",
                        textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  ),

              SizedBox(height: 25.0,),

              Center( 
                child: RawMaterialButton(onPressed:(){
            cerrarSesion();
          },
          elevation: 2.0,
          fillColor: Colors.greenAccent,
          child: const Icon(Icons.logout_rounded, size: 50.0,),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          ),
              ),
            
          SizedBox(height: 100.0,),
          
            ],
          ),
          ),
        ),
            ),
                
              ],
            ),
        ),
       
      ),
    );
  }
}
