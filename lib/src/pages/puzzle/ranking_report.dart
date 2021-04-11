import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/bloc/puzzle_bloc.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart';
import 'package:enchiladasapp/src/widgets/customCacheManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankingReport extends StatefulWidget {
  @override
  _RankingReportState createState() => _RankingReportState();
}

class _RankingReportState extends State<RankingReport> {
  DatePickerController _controller = DatePickerController();

  DateTime today;
  DateTime firstDate;
  DateTime lastDate;
  String fechaBusqueda;
  int cant = 0;
  //String diaDeLaSemana;
  String dateFormat = 'dd';
  String monthFormat = 'MMM';
  String weekDayFormat = 'EEE';
  List<DateTime> initialSelectedDates;
  List<DateTime> feedInitialSelectedDates(DateTime algo) {
    List<DateTime> selectedDates = List();

    selectedDates.add(algo);

    return selectedDates;
  }

  void initState() {
    const int days = 30;
    today = toDateMonthYear(DateTime.now());
    firstDate = toDateMonthYear(today.subtract(Duration(days: days - 15)));
    fechaBusqueda = today.toString();
    //diaDeLaSemana = today.weekday.toString();
    initialSelectedDates = feedInitialSelectedDates(today);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final puzzleBloc = ProviderBloc.puzzle(context);

    var horafotmat = fechaBusqueda.toString().split(' ');
    var horaformat1 = horafotmat[0];

    puzzleBloc.obtenerTiempos(horaformat1);

    Future.delayed(Duration(milliseconds:500), () {
      _controller.animateToDate(today);
    });

    //_controller.animateToDate(firstDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ranking',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: _calendar(responsive, puzzleBloc, _controller),
    );
  }

  Widget _calendar(Responsive responsive, PuzzleBloc puzzleBloc,
      DatePickerController controller) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: DatePicker(
            firstDate,
            initialSelectedDate: today,
            selectionColor: Colors.green,
            locale: 'es_Es',
            selectedTextColor: Colors.white,
            controller: controller,
            daysCount: 16,
            onDateChange: (date) {
              print(date);
              var horafotmat = date.toString().split(' ');
              var horaformat1 = horafotmat[0];

              puzzleBloc.obtenerTiempos(horaformat1);
              controller.animateToDate(date);
              /* setState(() {
                fechaBusqueda = date.toString();
                cant++;
                //diaDeLaSemana = date.weekday.toString();
                //canchasBloc.obtenerReservasPorIDCancha(canchas.canchaId,canchas.idEmpresa,fechaBusqueda);
              }); */
            },
          ),

          /* HorizontalCalendar(
            height: 80,
            selectedDateTextStyle: TextStyle(color: Colors.white),
            selectedMonthTextStyle: TextStyle(color: Colors.white),
            selectedWeekDayTextStyle: TextStyle(color: Colors.white),
            maxSelectedDateCount: 1,
            initialSelectedDates: initialSelectedDates,
            firstDate: firstDate,
            scrollController: _scrollController,
            lastDate: lastDate,
            weekDayFormat: weekDayFormat,
            monthFormat: monthFormat,
            padding: EdgeInsets.symmetric(horizontal: 12),
            defaultDecoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            selectedDecoration: BoxDecoration(
                color: Color(0xff239f23),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8)),
            disabledDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8)),
            onDateSelected: (date) {
              

              setState(() {
                fechaBusqueda = date.toString();
                cant++;
                //diaDeLaSemana = date.weekday.toString();
                //canchasBloc.obtenerReservasPorIDCancha(canchas.canchaId,canchas.idEmpresa,fechaBusqueda);
              });
            },
          ),*/
        ),
        Expanded(
          child: StreamBuilder(
              stream: puzzleBloc.puzzleTiempoStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<RankingPuzzle>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return contenidoRanking(context, responsive, snapshot.data);
                  } else {
                    return Center(child: Text('No hay datos'));
                  }
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              }),
        ),
      ],
    );
  }

  Widget contenidoRanking(
      BuildContext context, Responsive responsive, List<RankingPuzzle> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, i) {
        return _cardRanking(responsive, data[i], i + 1);
      },
    );
  }

  Widget _cardRanking(Responsive responsive, RankingPuzzle ranking, int index) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(2), vertical: responsive.hp(.8)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(responsive.ip(1)),
        child: Row(children: <Widget>[
          Text(
            '$index',
            style: TextStyle(
                fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          Container(
            height: responsive.wp(10),
            width: responsive.wp(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: CachedNetworkImage(
                cacheManager: CustomCacheManager(),
                progressIndicatorBuilder: (_, url, downloadProgress) {
                  return Stack(
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          backgroundColor: Colors.green,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                      Center(
                        child: (downloadProgress.progress != null)
                            ? Text(
                                '${(downloadProgress.progress * 100).toInt().toString()}%')
                            : Container(),
                      )
                    ],
                  );
                },
                errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/carga_fallida.jpg'),
                    fit: BoxFit.cover),
                imageUrl: '${ranking.userImage}',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          Expanded(
            child: Text('${ranking.personName}',
                style: TextStyle(fontSize: responsive.ip(1.8))),
            //child: Text('Angelo Tapullima Del Aguila',style: TextStyle(fontSize: responsive.ip(1.8)),),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          Text('${ranking.puzzleTiempo}',
              style: TextStyle(fontSize: responsive.ip(1.8))),
          //Text('00:00:00'),
        ]),
      ),
    );
  }
}
