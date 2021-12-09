class Sesion{
  
  int? id;
  int idUsuario;
  int sesionActiva;

  Sesion({this.id,required this.idUsuario, required this.sesionActiva});
  

  Map<String, dynamic> toMap(){
    return{ 'id': id,'idUsuario': idUsuario, 'sesionActiva': sesionActiva,};
  }
}