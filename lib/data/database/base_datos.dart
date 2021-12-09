import 'package:control_gastos/data/model/gastos.dart';
import 'package:control_gastos/data/model/ingresos.dart';
import 'package:control_gastos/data/model/sesion.dart';
import 'package:control_gastos/data/model/usuarios.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DB {

  
  static Future<Database> _openDB() async {

    const queryCreacionTablaGastos = "CREATE TABLE gastos (id INTEGER PRIMARY KEY, idUsuario INTEGER, gasto real, concepto TEXT);";
    const queryCreacionTablaUsuarios = "CREATE TABLE usuarios (idUsuario INTEGER PRIMARY KEY, nombreUsuario TEXT, contra TEXT, correo TEXT);";
    const queryCreacionTablaIngresos = "CREATE TABLE ingresos (id INTEGER PRIMARY KEY, idUsuario INTEGER, ingreso real, referencia TEXT);";
    const queryCreacionTablaSesion = "CREATE TABLE sesion (id INTEGER PRIMARY KEY, idUsuario INTEGER, sesionActiva INTEGER);";

    return openDatabase(join(await getDatabasesPath(), 'control_gastos.db'),
        onCreate: (db, version) {
          db.execute(queryCreacionTablaGastos,);
          db.execute(queryCreacionTablaIngresos,);
          db.execute(queryCreacionTablaSesion,);
          return db.execute(queryCreacionTablaUsuarios,);
    }, version: 1);
  }

  static Future<int> insertGasto(Gastos gasto) async {
    Database database = await _openDB();

    return database.insert("gastos", gasto.toMap());
  }

  static Future<int> insertUsuario(Usuarios usuarios) async {
    Database database = await _openDB();

    return database.insert("usuarios", usuarios.toMap());
  }
  static Future<int> insertIngreso(Ingresos ingresos) async {
    Database database = await _openDB();

    return database.insert("ingresos", ingresos.toMap());
  }
  static Future<int> insertSesion(Sesion sesion) async {
    Database database = await _openDB();

    return database.insert("sesion", sesion.toMap());
  }


  static Future<List<Gastos>> obtenerGastos() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> gastosMap =
        await database.query("gastos");
    return List.generate(
        gastosMap.length,
        (i) => Gastos(
            id: gastosMap[i]['id'],
            idUsuario: gastosMap[i]['idUsuario'],
            gasto: gastosMap[i]['gasto'],
            concepto: gastosMap[i]['concepto']
            )
            );
  }
  static Future<List<Usuarios>> obtenerUsuarios() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> usuariosMap =
        await database.query("usuarios");
    return List.generate(
        usuariosMap.length,
        (i) => Usuarios(
            idUsuario: usuariosMap[i]['idUsuario'],
            nombreUsuario: usuariosMap[i]['nombreUsuario'],
            contra: usuariosMap[i]['contra'],
            correo: usuariosMap[i]['correo'],
            )
            );
  }
  static Future<List<Sesion>> obtenerSesion() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> sesionMap =
        await database.query("sesion");
    return List.generate(
        sesionMap.length,
        (i) => Sesion(
            id: sesionMap [i]['id'],
            idUsuario: sesionMap [i]['idUsuario'],
            sesionActiva: sesionMap[i]['sesionActiva'],
            )
            );
  }

  static Future<List<Ingresos>> obtenerIngreso() async {
    //obtener una conexión/instancia a la base de datos
    Database database = await _openDB();
    
    //obtener los registro de la tabla ingresos
    final List<Map<String, dynamic>> ingresoMap = await database.query("ingresos");

    return List.generate(ingresoMap.length,
        (i) => Ingresos(
                id: ingresoMap[i]['id'], 
                idUsuario: ingresoMap[i]['idUsuario'], 
                ingreso: ingresoMap[i]['ingreso'], 
                referencia: ingresoMap[i]['referencia'],
                )
                );
  }
  
  static Future<List<Usuarios>> obtenerUsuarioIniciarSesion(String nombreUsuario, String contra) async {
   
    Database database = await _openDB();

    //final List<Map<String, dynamic>> usuariosMap = await database.query("usuarios");
    final List<Map<String, dynamic>> usuarioMap = await database.query('usuarios', 
                                                                      columns: ['idUsuario', 'nombreUsuario',
                                                                                 'contra', 'correo'], 
                                                                      where: ' nombreUsuario = ? and contra = ? ',
                                                                      whereArgs: [nombreUsuario, contra]
                                                                      );

    return List.generate(
        usuarioMap.length,
        (i) => Usuarios(
            idUsuario: usuarioMap[i]['idUsuario'],
            nombreUsuario: usuarioMap[i]['nombreUsuario'],
            contra: usuarioMap[i]['contra'],
            correo: usuarioMap[i]['correo'],
            )
            );
  }

   static Future<List<Usuarios>> obtenerUsuarioPorIdUsuario(int idUsuario) async {
   
    Database database = await _openDB();

    //final List<Map<String, dynamic>> usuariosMap = await database.query("usuarios");
    final List<Map<String, dynamic>> usuarioMap = await database.query('usuarios', 
                                                                      columns: ['idUsuario', 'nombreUsuario',
                                                                                 'contra', 'correo'], 
                                                                      where: ' idUsuario = ? ',
                                                                      whereArgs: [idUsuario]
                                                                      );

    return List.generate(
        usuarioMap.length,
        (i) => Usuarios(
            idUsuario: usuarioMap[i]['idUsuario'],
            nombreUsuario: usuarioMap[i]['nombreUsuario'],
            contra: usuarioMap[i]['contra'],
            correo: usuarioMap[i]['correo'],
            )
            );
  }

  static Future<List<Ingresos>> obtenerIngresosPorIdUsuario(int idUsuario) async {
   
    Database database = await _openDB();

    //final List<Map<String, dynamic>> usuariosMap = await database.query("usuarios");
    final List<Map<String, dynamic>> ingresosMap = await database.query('ingresos', 
                                                                      columns: ['id', 'idUsuario',
                                                                                 'ingreso', 'referencia'], 
                                                                      where: ' idUsuario = ? ',
                                                                      whereArgs: [idUsuario]
                                                                      );

    return List.generate(
        ingresosMap.length,
        (i) => Ingresos(
            id: ingresosMap[i]['id'],
            idUsuario: ingresosMap[i]['idUsuario'],
            ingreso: ingresosMap[i]['ingreso'],
            referencia: ingresosMap[i]['referencia'],
            )
            );
  }

  //-tipo    -lo que regresa       -nombre del método      -parametros      -asincrono
  static Future<List<Gastos>> obtenerGastosPorIdUsuario(int idUsuario) async {
   
    Database database = await _openDB();

    //final List<Map<String, dynamic>> usuariosMap = await database.query("usuarios");
    final List<Map<String, dynamic>> gastoMap = await database.query('gastos', 
                                                                      columns: ['id', 'idUsuario',
                                                                                 'gasto', 'concepto'], 
                                                                      where: ' idUsuario = ? ',
                                                                      whereArgs: [idUsuario]
                                                                      );

    return List.generate(
        gastoMap.length,
        (i) => Gastos(
            id: gastoMap[i]['id'],
            idUsuario: gastoMap[i]['idUsuario'],
            gasto: gastoMap[i]['gasto'],
            concepto: gastoMap[i]['concepto'],
            )
            );
  }

  static Future<void> limpiarTablaSesion() async {
    Database database = await _openDB();
    await database.rawQuery('DELETE FROM sesion');
  }

  static Future<List<Usuarios>> obtenerUsuarioPorNombreUsuario(String nombreUsuario) async {
   
    Database database = await _openDB();

    //final List<Map<String, dynamic>> usuariosMap = await database.query("usuarios");
    final List<Map<String, dynamic>> usuarioMap = await database.query('usuarios', 
                                                                      columns: ['idUsuario', 'nombreUsuario',
                                                                                 'contra', 'correo'], 
                                                                      where: ' nombreUsuario = ? ',
                                                                      whereArgs: [nombreUsuario]
                                                                      );

    return List.generate(
        usuarioMap.length,
        (i) => Usuarios(
            idUsuario: usuarioMap[i]['idUsuario'],
            nombreUsuario: usuarioMap[i]['nombreUsuario'],
            contra: usuarioMap[i]['contra'],
            correo: usuarioMap[i]['correo'],
            )
            );
  }


}
