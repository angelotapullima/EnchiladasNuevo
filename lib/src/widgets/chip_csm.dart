import 'package:chips_choice/chips_choice.dart';
import 'package:enchiladasapp/main.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:flutter/material.dart';

class ChipCsm extends StatelessWidget {
  final String titulo;
  final List<String> list;
  const ChipCsm({Key key, @required this.titulo, @required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chipBloc = ProviderBloc.chip(context);
    return StreamBuilder(
        stream: chipBloc.chipStream,
        builder: (context, tmr) {
          return Content(
            title: '$titulo',
            child: ChipsChoice<int>.single(
              value: chipBloc.chip,
              onChanged: (val) {
                chipBloc.changeChip(val);
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: list,
                value: (i, v) => i,
                label: (i, v) => v,
                tooltip: (i, v) => v,
              ),
              choiceStyle: C2ChoiceStyle(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              wrapped: true,
            ),
          );
        });
  }
}



class Content extends StatefulWidget {

  final String title;
  final Widget child;

  Content({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> with AutomaticKeepAliveClientMixin<Content>  {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: Colors.blueGrey[50],
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: widget.child
          ),
        ],
      ),
    );
  }
}
