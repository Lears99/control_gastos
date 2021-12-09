class Gastos{
  
  int? id;
  int idUsuario;
  double gasto;
  String concepto;

  Gastos({this.id,required this.idUsuario, required this.gasto,required this.concepto});
  

  Map<String, dynamic> toMap(){
    return{ 'id': id,'idUsuario': idUsuario, 'gasto': gasto, 'concepto': concepto};
  }
}