import 'package:control_gastos/presentation/home/cerrar_sesion.dart';
import 'package:control_gastos/presentation/home/listar_gastos.dart';
import 'package:control_gastos/presentation/registro/captura_gasto.dart';
import 'package:control_gastos/presentation/registro/captura_ingreso.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'listar_ingresos.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _currentIndex = 0;

  final _pages = const [
   Home(),
   CapturaGasto(),
   CapturaIngreso(),
   ListaGastos(),
   ListaIngresos(),
   CerrarSesion(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0XFF000000),
        selectedItemColor: const Color(0xFFE040FB),
        unselectedItemColor: const Color(0xFF64FFDA),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on_outlined), label: "Saldo"),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_circle_down_sharp), label: "Gasto"),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_circle_up_sharp), label: "Ingreso"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lista G"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lista I"),
          BottomNavigationBarItem(icon: Icon(Icons.power_settings_new), label: "Salir"),
        ],
      ),
    ), 
      onWillPop: () async => false,
      );
  }
}