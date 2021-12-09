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
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(             
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: Image.asset(
                "assets/images/cerrarSesion.png",
                width: 250,
                height: 250,
              ),
          ),
              
              Container(             
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: ElevatedButton(
                  onPressed: () {
                      cerrarSesion();
                  },
                  child: const Text('Cerrar Sesión'),
                ),
          ),
            ],
          ),
        )),
      ),
    );
  }
}
