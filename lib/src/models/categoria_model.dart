
 


import 'package:enchiladasapp/src/models/productos_model.dart';

class Categorias {
    Categorias({
        this.result,
    });

    Result result;

    factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
        result: Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result.toJson(),
    };
}

class Result {
    Result({
        this.code,
        this.data,
    });

    int code;
    List<CategoriaData> data;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        code: json["code"],
        data: List<CategoriaData>.from(json["data"].map((x) => CategoriaData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CategoriaData {
    CategoriaData({
        this.idCategoria,
        this.categoriaNombre,
        this.categoriaEstado,
        this.categoriaTipo,
        this.categoriaOrden,
        this.categoriaPromocion,
        this.categoriaSonido,
        this.categoriaFoto,
        this.categoriaIcono,
        this.categoriaMostrarApp,
        this.categoriaBanner,
        this.productos,
    });

    String idCategoria;
    String categoriaNombre;
    String categoriaEstado;
    String categoriaTipo;
    String categoriaOrden;
    String categoriaPromocion;
    String categoriaSonido;
    String categoriaFoto;
    String categoriaIcono;
    String categoriaMostrarApp;
    String categoriaBanner;

    List<ProductosData> productos;

    factory CategoriaData.fromJson(Map<String, dynamic> json) => CategoriaData(
        idCategoria: json["id_categoria"],
        categoriaNombre: json["categoria_nombre"],
        categoriaEstado: json["categoria_estado"],
        categoriaTipo: json["categoria_tipo"],
        categoriaOrden: json["categoria_orden"],
        categoriaPromocion: json["categoria_promocion"],
        categoriaSonido: json["categoria_sonido"],
        categoriaFoto: json["categoria_foto"],
        categoriaIcono: json["categoria_icono"],
        categoriaMostrarApp: json["categoria_mostrar_app"],
        categoriaBanner: json["categoria_banner"],
    );

    Map<String, dynamic> toJson() => {
        "id_categoria": idCategoria,
        "categoria_nombre": categoriaNombre,
        "categoria_estado": categoriaEstado,
        "categoria_tipo": categoriaTipo,
        "categoria_promocion": categoriaPromocion,
        "categoria_foto": categoriaFoto,
        "categoria_icono": categoriaIcono,
        "categoria_mostrar_app": categoriaMostrarApp,
        "categoria_banner": categoriaBanner,
    };
}