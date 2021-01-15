


class AdicionalesModel{



  String idAdicional;
  String idProducto;
  String idProductoAdicional;
  String adicionalesNombre;
  String adicionalesPrecio;
  String adicionalSeleccionado;

  AdicionalesModel({
        this.idAdicional, 
        this.idProducto,
        this.idProductoAdicional,
        this.adicionalesNombre,
        this.adicionalesPrecio,
        this.adicionalSeleccionado,
    });

    factory AdicionalesModel.fromJson(Map<String, dynamic> json) => AdicionalesModel(
        //idAdicional: json["id_adicional"], 
        idProducto: json["id_producto"], 
        idProductoAdicional: json["id_producto_adicional"],
        adicionalSeleccionado: json["adicional_seleccionado"],
    );

}