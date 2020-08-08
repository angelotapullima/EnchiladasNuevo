
 


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
        this.categoriaCod,
        this.idAlmacen,
        this.categoriaEstado,
        this.categoriaMostrarApp,
        this.categoriaTipo,
    });

    String idCategoria;
    String categoriaNombre;
    String categoriaCod;
    String idAlmacen;
    String categoriaEstado;
    String categoriaMostrarApp;
    String categoriaTipo;

    factory CategoriaData.fromJson(Map<String, dynamic> json) => CategoriaData(
        idCategoria: json["id_categoria"],
        categoriaNombre: json["categoria_nombre"],
        categoriaCod: json["categoria_cod"],
        idAlmacen: json["id_almacen"],
        categoriaEstado: json["categoria_estado"],
        categoriaMostrarApp: json["categoria_mostrar_app"],
        categoriaTipo: json["categoria_tipo"],
    );

    Map<String, dynamic> toJson() => {
        "id_categoria": idCategoria,
        "categoria_nombre": categoriaNombre,
        "categoria_cod": categoriaCod,
        "id_almacen": idAlmacen,
        "categoria_estado": categoriaEstado,
        "categoria_mostrar_app": categoriaMostrarApp,
        "categoria_tipo": categoriaTipo,
    };
}