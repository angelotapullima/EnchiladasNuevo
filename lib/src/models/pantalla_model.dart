

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
    String id;
    String nombreItem;  
    String fotoItem; 

  ItemPantalla({
        this.id,
        this.nombreItem,
        this.fotoItem, 
    });

     factory ItemPantalla.fromJson(Map<dynamic, dynamic> json) => ItemPantalla(
        id: json["id"],
        nombreItem: json["nombreItem"],
        fotoItem: json["fotoItem"], 
    );
}