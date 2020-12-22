class Carrito {
    Carrito({
        this.idProducto, 
        this.productoNombre,
        this.productoFoto,
        this.productoCantidad,
        this.productoPrecio, 
        this.productoTipo, 
        this.productoObservacion, 
        this.idCategoria, 
    });

    int idProducto; 
    String productoNombre;
    String productoFoto;
    String productoCantidad;
    String productoPrecio;
    String productoTipo; 
    String productoObservacion; 
    String idCategoria; 

    factory Carrito.fromJson(Map<String, dynamic> json) => Carrito(
        idProducto: json["id_producto"], 
        productoNombre: json["producto_nombre"],
        productoFoto: json["producto_foto"],
        productoCantidad: json["producto_cantidad"],
        productoPrecio: json["producto_precio"], 
        productoTipo: json["producto_tipo"], 
        productoObservacion: json["producto_observacion"], 
        idCategoria: json["idCategoria"], 
    );

    Map<String, dynamic> toJson() => {
        "id_producto": idProducto, 
        "producto_nombre": productoNombre,
        "producto_foto": productoFoto,
        "producto_cantidad": productoCantidad,
        "producto_precio": productoPrecio, 
        "producto_tipo": productoTipo, 
        "producto_observacion": productoObservacion, 
    };
}
