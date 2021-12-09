import 'dart:ffi';

class Ingresos{
  
  int? id;
  int idUsuario;
  double ingreso;
  String referencia;

  Ingresos({this.id,required this.idUsuario, required this.ingreso,required this.referencia});
  

  Map<String, dynamic> toMap(){
    return{ 'id': id,'idUsuario': idUsuario, 'ingreso': ingreso, 'referencia': referencia};
  }
}