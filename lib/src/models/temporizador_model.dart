

class TemporizadorModel{


   TemporizadorModel({
        this.idTemporizador,
        this.temporizadorTipo, 
        this.temporizadorFechainicio,
        this.temporizadorFechafin,
        this.temporizadorHorainicio,
        this.temporizadorHorafin,
        this.temporizadorLunes,
        this.temporizadorMartes,
        this.temporizadorMiercoles,
        this.temporizadorJueves,
        this.temporizadorViernes,
        this.temporizadorSabado,
        this.temporizadorDomingo,
    });

    String idTemporizador;
    String temporizadorTipo; 
    String temporizadorFechainicio; 
    String temporizadorFechafin; 
    String temporizadorHorainicio; 
    String temporizadorHorafin; 
    String temporizadorLunes; 
    String temporizadorMartes; 
    String temporizadorMiercoles; 
    String temporizadorJueves; 
    String temporizadorViernes; 
    String temporizadorSabado; 
    String temporizadorDomingo; 

    factory TemporizadorModel.fromJson(Map<dynamic, dynamic> json) => TemporizadorModel(
        idTemporizador: json["idTemporizador"],
        temporizadorTipo: json["temporizador_tipo"], 
        temporizadorFechainicio: json["temporizador_fechainicio"], 
        temporizadorFechafin: json["temporizador_fechafin"], 
        temporizadorHorainicio: json["temporizador_horainicio"], 
        temporizadorHorafin: json["temporizador_horafin"], 
        temporizadorLunes: json["temporizador_lunes"], 
        temporizadorMartes: json["temporizador_martes"], 
        temporizadorMiercoles: json["temporizador_miercoles"], 
        temporizadorJueves: json["temporizador_jueves"], 
        temporizadorViernes: json["temporizador_viernes"], 
        temporizadorSabado: json["temporizador_sabado"], 
        temporizadorDomingo: json["temporizador_domingo"], 
    );

    Map<dynamic, dynamic> toJson() => {
        "idTemporizador": idTemporizador,
        "temporizador_tipo": temporizadorTipo, 
        "temporizador_fechainicio": temporizadorFechainicio, 
        "temporizador_fechafin": temporizadorFechafin, 
        "temporizador_horainicio": temporizadorHorainicio, 
        "temporizador_horafin": temporizadorHorafin, 
        "temporizador_lunes": temporizadorLunes, 
        "temporizador_martes": temporizadorMartes, 
        "temporizador_miercoles": temporizadorMiercoles, 
        "temporizador_jueves": temporizadorJueves, 
        "temporizador_viernes": temporizadorViernes, 
        "temporizador_sabado": temporizadorSabado, 
        "temporizador_domingo": temporizadorDomingo,
    };


}