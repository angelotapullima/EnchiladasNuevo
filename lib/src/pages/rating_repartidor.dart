import 'package:enchiladasapp/src/api/ordenes_api.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class RatingRepartidor extends StatefulWidget {

  final String idPedido;

  const RatingRepartidor({Key key,@required this.idPedido}) : super(key: key);
  @override
  _RatingRepartidorState createState() => _RatingRepartidorState();
}

class _RatingRepartidorState extends State<RatingRepartidor> {
  final _toque = ValueNotifier<bool>(false);
  TextEditingController _comentarioController = TextEditingController();
  FocusNode focusImput = FocusNode();

  double ratingValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Califica al repartidor'),
      ),
      body: Stack(
        children: [
          KeyboardActions(
            config: KeyboardActionsConfig(
                keyboardBarColor: Colors.red,
                nextFocus: false,
                actions: [
                  KeyboardActionsItem(focusNode: focusImput),
                ]),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(5),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Container(
                      height: responsive.hp(25),
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(7),
                      ),
                      child: Image(
                        image: AssetImage('assets/logo_enchilada.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Text(
                      'Por favor califique a nuestro repartidor',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);

                        ratingValue = rating;
                      },
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        decoration:
                            InputDecoration(hintText: 'Ingrese lo comentarios'),
                        focusNode: focusImput,
                        controller: _comentarioController,
                        maxLines: 5,
                      ),
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    SizedBox(
                      width: responsive.wp(90),
                      child: MaterialButton(
                        onPressed: () async {
                          if (ratingValue > 0) {
                            if (_comentarioController.text.isEmpty) {
                              showToast('Por favor ingrese los comentarios', 2,
                                  ToastGravity.TOP);
                            } else {
                              _toque.value = true;
                              final ordenesApi = OrdenesApi();

                              final res = await ordenesApi.valorarPedido(
                                  widget.idPedido,
                                  ratingValue.toString(),
                                  _comentarioController.text);

                              if (res == 1) {
                                showToast(
                                    'Calificación registrada correctamente',
                                    2,
                                    ToastGravity.TOP);

                                    Navigator.pushNamed(context, '/');
                              } else {
                                showToast(
                                    'Por favor reintente nuevamente en unos momentos',
                                    2,
                                    ToastGravity.TOP);
                              }

                              _toque.value = false;
                            }
                          } else {
                            showToast(
                                'Por favor califique a nuestro repartidor',
                                2,
                                ToastGravity.TOP);
                          }
                        },
                        child: Text('Enviar'),
                        color: Colors.red,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _toque,
              builder: (BuildContext context, bool dataToque, Widget child) {
                return (dataToque)
                    ? Stack(
                        children: [
                          Container(
                            color: Colors.black.withOpacity(.3),
                            height: double.infinity,
                            width: double.infinity,
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5),
                                vertical: responsive.wp(2),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: responsive.wp(5),
                              ),
                              height: responsive.hp(13),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 60.0,
                                    child: Image.asset(
                                      'assets/loading.gif',
                                    ),
                                  ),
                                  SizedBox(
                                    width: responsive.wp(5),
                                  ),
                                  Text(
                                    'Enviando calificación',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Container();
              }),
        ],
      ),
    );
  }
}
