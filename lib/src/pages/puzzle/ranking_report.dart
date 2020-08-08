import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/bloc/puzzle_bloc.dart';
import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
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
  String diaDeLaSemana;
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
    diaDeLaSemana = today.weekday.toString();
    initialSelectedDates = feedInitialSelectedDates(today);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final puzzleBloc = ProviderBloc.puzzle(context);

    var horafotmat = today.toString().split(' ');
    var horaformat1 = horafotmat[0];
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
                diaDeLaSemana = date.weekday.toString();
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
                    return contenidoRanking(
                        context, '0', responsive, snapshot.data);
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

  Widget contenidoRanking(BuildContext context, String time,
      Responsive responsive, List<RankingPuzzle> data) {
    return CustomScrollView(slivers: <Widget>[
      _crearAppbar(context, time),
      SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
          return _cardRanking(responsive, data[i]);
        }, childCount: data.length),
      )
    ]);
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final circulo = Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FadeInImage(
            height: size.width * 0.25,
            width: size.width * 0.25,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(
                'https://ep01.epimg.net/elpais/imagenes/2019/06/24/icon/1561369019_449523_1561456608_noticia_normal.jpg')),
      ),
    );
    return Container(
      height: size.height * 0.35,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              color: Colors.black12,
              image: new DecorationImage(
                image: new ExactAssetImage('assets/ladrillos.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.28,
                      padding: EdgeInsets.only(top: size.height * 0.13),
                      child: Column(
                        children: <Widget>[
                          circulo,
                          Text(
                            'Angelo Tapullima Del Aguila',

                            textAlign: TextAlign.center,
                            //overflow:TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.28,
                      padding: EdgeInsets.only(top: size.height * 0.05),
                      child: Column(
                        children: <Widget>[
                          circulo,
                          Text(
                            'Angelo Tapullima Del Aguila',
                            textAlign: TextAlign.center,
                            //overflow:TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.28,
                      padding: EdgeInsets.only(top: size.height * 0.18),
                      child: Column(
                        children: <Widget>[
                          circulo,
                          Text(
                            'Angelo Tapullima Del Aguila',
                            textAlign: TextAlign.center,
                            //overflow:TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearAppbar(BuildContext context, String time) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
      elevation: 2.0,
      backgroundColor: Colors.red,
      expandedHeight: size.height * 0.4,
      floating: true,
      pinned: true,
      leading: Icon(
        Icons.add,
        color: Colors.transparent,
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          time,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: _crearFondo(context),
      ),
    );
  }

  Widget _cardRanking(Responsive responsive, RankingPuzzle ranking) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(children: <Widget>[
          Text(
            '4',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            width: 5.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: FadeInImage(
                height: responsive.wp(10),
                width: responsive.wp(10),
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(
                    'https://delivery.lacasadelasenchiladas.pe/${ranking.userImage}')),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text('${ranking.personName}'),
          ),
          Text('${ranking.puzzleTiempo}'),
        ]),
      ),
    );
  }
}
