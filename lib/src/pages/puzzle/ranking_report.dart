import 'package:cached_network_image/cached_network_image.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/bloc/puzzle_bloc.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_calendar_widget/date_helper.dart';
import 'package:horizontal_calendar_widget/horizontal_calendar.dart';

class RankingReport extends StatefulWidget {
  @override
  _RankingReportState createState() => _RankingReportState();
}

class _RankingReportState extends State<RankingReport> {
  DateTime today;
  DateTime firstDate;
  DateTime lastDate;
  String fechaBusqueda;
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

  final ScrollController _scrollController = new ScrollController();
  void initState() {
    const int days = 30;
    today = toDateMonthYear(DateTime.now());
    firstDate = toDateMonthYear(today.subtract(Duration(days: days - 15)));
    lastDate = toDateMonthYear(today.add(Duration(days: days - 15)));
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
    print('este es  : $horaformat1');
    puzzleBloc.obtenerTiempos(horaformat1);

    Future.delayed(Duration(milliseconds: 1), () {
      _scrollController.animateTo(
        responsive.wp(13.5) * 15,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 100),
      );
    });

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
      body: _calendar(responsive, puzzleBloc),
    );
  }

  Widget _calendar(Responsive responsive, PuzzleBloc puzzleBloc) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: HorizontalCalendar(
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
              print(date.weekday);

              setState(() {
                fechaBusqueda = date.toString();
                //diaDeLaSemana = date.weekday.toString();
                //canchasBloc.obtenerReservasPorIDCancha(canchas.canchaId,canchas.idEmpresa,fechaBusqueda);
              });
            },
          ),
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
                    return Center(child: Text('no hay datos'));
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
        return _cardRanking(responsive, data[i],i+1);
      },
    );
  }

  Widget _cardRanking(Responsive responsive, 
    RankingPuzzle ranking,int index) {
    return Card(
        elevation: 3.0,
        margin: EdgeInsets.symmetric(horizontal: responsive.wp(2), vertical: responsive.hp(.8)),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.all(responsive.ip(1)),
          child: Row(children: <Widget>[
            Text(
              '$index',
              style: TextStyle(fontSize:responsive.ip(2),fontWeight: FontWeight.bold),
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
                  placeholder: (context, url) => Image(
                      image: AssetImage('assets/jar-loading.gif'),
                      fit: BoxFit.cover),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageUrl:'${ranking.userImage}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),),
                  ),
                ),
              ),
            ),
            SizedBox(
              
              width: responsive.wp(2),
            ),
            Expanded(
              child: Text('${ranking.personName}',style: TextStyle(fontSize: responsive.ip(1.8))),
              //child: Text('Angelo Tapullima Del Aguila',style: TextStyle(fontSize: responsive.ip(1.8)),),
            ), SizedBox(
              
              width: responsive.wp(2),
            ),
            Text('${ranking.puzzleTiempo}',style: TextStyle(fontSize: responsive.ip(1.8))),
            //Text('00:00:00'),
          ]),
        ),
    
    );
  }
}
