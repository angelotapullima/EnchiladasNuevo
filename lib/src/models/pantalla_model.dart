

class PantallaModel{

  PantallaModel({
        this.idPantalla,
        this.pantallaNombre, 
        this.pantallaOrden,
        this.pantallaFoto,
        this.pantallaEstado,
        this.pantallCategoria,
        this.pantallaTipo,
        this.altoList,
        this.altoCard,
        this.anchoCard,
        this.items,
    });

    String idPantalla;
    String pantallaNombre; 
    String pantallaOrden; 
    String pantallaFoto; 
    String pantallaEstado; 
    String pantallCategoria; 
    String pantallaTipo; 
    List<ItemPantalla> items;


    String altoList;
    String altoCard;
    String anchoCard;

    factory PantallaModel.fromJson(Map<dynamic, dynamic> json) => PantallaModel(
        idPantalla: json["id_pantalla"],
        pantallaNombre: json["pantalla_nombre"], 
        pantallaOrden: json["pantalla_orden"], 
        pantallaFoto: json["pantalla_foto"], 
        pantallaEstado: json["pantalla_estado"], 
        pantallCategoria: json["pantalla_categorias"],
        pantallaTipo: json["pantallaTipo"],
        altoList: json["altoList"],
        altoCard: json["altoCard"],
        anchoCard: json["anchoCard"],
    );

}


class ItemPantalla{
    String idProducto;
    String idCategoria;
    String nombreItem;  
    String fotoItem; 
    String numeroItem; 
    String cantidadItems; 
    String productoNuevo; 
    String productoDestacado; 

  ItemPantalla({
        this.idProducto,
        this.idCategoria,
        this.nombreItem,
        this.fotoItem, 
        this.numeroItem, 
        this.cantidadItems, 
        this.productoNuevo, 
        this.productoDestacado, 
    });

     factory ItemPantalla.fromJson(Map<dynamic, dynamic> json) => ItemPantalla(
        idProducto: json["idProducto"],
        idCategoria: json["idCategoria"],
        nombreItem: json["nombreItem"],
        fotoItem: json["fotoItem"], 
        numeroItem: json["numeroItem"], 
        cantidadItems: json["cantidadItems"], 
        productoNuevo: json["productoNuevo"], 
        productoDestacado: json["productoDestacado"], 
    );
}