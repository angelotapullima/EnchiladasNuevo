 

class Ruc {
    Ruc({
        this.ruc,
        this.razonSocial, 
        this.contribuyenteEstado, 
    });

    String ruc;
    String razonSocial; 
    String contribuyenteEstado; 
    factory Ruc.fromJson(Map<dynamic, dynamic> json) => Ruc(
        ruc: json["ruc"],
        razonSocial: json["razon_social"], 
        contribuyenteEstado: json["contribuyente_estado"], 
    );

    Map<dynamic, dynamic> toJson() => {
        "ruc": ruc,
        "razon_social": razonSocial, 
        "contribuyente_estado": contribuyenteEstado,
    };
}
