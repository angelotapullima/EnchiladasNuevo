class Observaciones {
  Observaciones({
    this.fijas,
    this.variables,
  });
  List<ObservacionesFijas> fijas;
  List<ObservacionesVariables> variables;
}

class ObservacionesFijas {
  ObservacionesFijas({
    this.idProducto,
    this.mostrar,
    this.productosFijos,
    this.sabores,
    this.acompanhamientos,
  });

  String idProducto;
  String mostrar;
  List<ProductosFijos> productosFijos;
  List<Sabores> sabores;
  List<Acompanhamientos> acompanhamientos;
  List<Sabores> especialesA;
  List<Sabores> especialesB;
  List<Sabores> especialesC;
  List<Sabores> especialesD;

  factory ObservacionesFijas.fromJson(Map<String, dynamic> json) =>
      ObservacionesFijas(
        idProducto: json["idProducto"],
        mostrar: json["mostrar"],
      );
}

class ProductosFijos {
  ProductosFijos({
    this.idProducto,
    this.idRelacionado,
    this.nombreProducto,
  });

  String idProducto;
  String idRelacionado;
  String nombreProducto;

  factory ProductosFijos.fromJson(Map<String, dynamic> json) => ProductosFijos(
        idProducto: json["idProducto"],
        idRelacionado: json["idRelacionado"],
        nombreProducto: json["nombreProducto"],
      );
}

class Sabores {
  String idProducto;
  String tituloTextos;
  String maximo;

  List<String> nombrecitos;
  List<OpcionesSabores> opciones;

  Sabores({
    this.idProducto,
    this.tituloTextos,
    this.maximo,
    this.nombrecitos,
  });

  factory Sabores.fromJson(Map<String, dynamic> json) => Sabores(
        idProducto: json["idProducto"],
        tituloTextos: json["tituloTextos"],
        maximo: json["maximo"],
      );
}

class OpcionesSabores {
  String idProducto;
  String tituloTextos;
  String nombreTexto;

  OpcionesSabores({
    this.idProducto,
    this.tituloTextos,
    this.nombreTexto,
  });

  factory OpcionesSabores.fromJson(Map<String, dynamic> json) =>
      OpcionesSabores(
        idProducto: json["idProducto"],
        tituloTextos: json["tituloTextos"],
        nombreTexto: json["nombreTexto"],
      );
}

class Acompanhamientos {
  String idProducto;
  String tituloTextos;

  List<String> nombrecitos;
  List<OpcionesAcompanhamientos> acompanhamientos;

  Acompanhamientos({
    this.idProducto,
    this.tituloTextos,
    this.nombrecitos,
  });

  factory Acompanhamientos.fromJson(Map<String, dynamic> json) =>
      Acompanhamientos(
        idProducto: json["idProducto"],
        tituloTextos: json["tituloTextos"],
      );
}

class OpcionesAcompanhamientos {
  String idProducto;
  String tituloTextos;
  String nombreTexto;

  OpcionesAcompanhamientos({
    this.idProducto,
    this.tituloTextos,
    this.nombreTexto,
  });

  factory OpcionesAcompanhamientos.fromJson(Map<String, dynamic> json) =>
      OpcionesAcompanhamientos(
        idProducto: json["idProducto"],
        tituloTextos: json["tituloTextos"],
        nombreTexto: json["nombreTexto"],
      );
}

//=====================================================================

class ObservacionesVariables {
  String idProducto;
  String nombreVariable;

  ObservacionesVariables({
    this.idProducto,
    this.nombreVariable,
  });

  factory ObservacionesVariables.fromJson(Map<String, dynamic> json) =>
      ObservacionesVariables(
        idProducto: json["idProducto"],
        nombreVariable: json["nombreVariable"],
      );
}
