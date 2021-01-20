


class AdicionalesModel{



  String idAdicional;
  String idProducto;
  String idProductoAdicional;
  String adicionalesNombre;
  String adicionalesPrecio;
  String adicionalItem;
  String adicionalSeleccionado;
  String titulo;

  AdicionalesModel({
        this.idAdicional, 
        this.idProducto,
        this.idProductoAdicional,
        this.adicionalItem,
        this.adicionalesNombre,
        this.adicionalesPrecio,
        this.titulo,
        this.adicionalSeleccionado,
    });

    factory AdicionalesModel.fromJson(Map<String, dynamic> json) => AdicionalesModel(
        //idAdicional: json["id_adicional"], 
        idProducto: json["id_producto"], 
        idProductoAdicional: json["id_producto_adicional"],
        adicionalItem: json["adicional_item"],
        titulo: json["titulo"],
        adicionalSeleccionado: json["adicional_seleccionado"],
    );

}