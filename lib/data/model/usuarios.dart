class Usuarios{
  
  int? idUsuario;
  String nombreUsuario;
  String contra;
  String correo;

  Usuarios({this.idUsuario,required this.nombreUsuario,required this.contra, required this.correo});

  Map<String, dynamic> toMap(){
    return{ 'idUsuario': idUsuario, 'nombreUsuario': nombreUsuario, 'contra': contra, 'correo': correo};
  }
}