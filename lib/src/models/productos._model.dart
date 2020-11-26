// To parse this JSON data, do
//
//     final productos = productosFromJson(jsonString);

import 'dart:convert';

Productos productosFromJson(String str) => Productos.fromJson(json.decode(str));

String productosToJson(Productos data) => json.encode(data.toJson());

class Productos {
    Productos({
        this.result,
    });

    Result result;

    factory Productos.fromJson(Map<String, dynamic> json) => Productos(
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
    List<ProductosData> data;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        code: json["code"],
        data: List<ProductosData>.from(json["data"].map((x) => ProductosData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ProductosData {
    ProductosData({
        this.idProducto,
        this.idCategoria,
        this.productoNombre,
        this.productoFoto,
        this.productoPrecio,
        this.productoUnidad,
        this.productoEstado,
        this.productoDescripcion,
        this.productoComentario,
        this.productoFavorito,
    });

    String idProducto;
    String idCategoria;
    String productoNombre;
    String productoFoto;
    String productoPrecio;
    String productoUnidad;
    String productoEstado;
    String productoDescripcion;
    String productoComentario;
    int productoFavorito; 

    factory ProductosData.fromJson(Map<String, dynamic> json) => ProductosData(
        idProducto: json["id_producto"],
        idCategoria: json["id_categoria"],
        productoNombre: json["producto_nombre"],
        productoFoto: json["producto_foto"],
        productoPrecio: json["producto_precio"],
        productoUnidad: json["producto_unidad"],
        productoEstado: json["producto_estado"],
        productoDescripcion: json["producto_descripcion"],
        productoComentario: json["producto_comentario"],
        productoFavorito: json["producto_favorito"],
    );

    Map<String, dynamic> toJson() => {
        "id_producto": idProducto,
        "id_categoria": idCategoria,
        "producto_nombre": productoNombre,
        "producto_foto": productoFoto,
        "producto_precio": productoPrecio,
        "producto_unidad": productoUnidad,
        "producto_estado": productoEstado,
        "producto_descripcion": productoDescripcion,
        "producto_favorito": productoFavorito,
    };
}
