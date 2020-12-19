


/*



import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/pages/detalle_observaciones.dart';
import 'package:enchiladasapp/src/widgets/chip_csm.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:async/async.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderBloc(
      child: MaterialApp(
        title: 'Flutter ChipsChoice',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // single choice value
  int tag = 1;

  // multiple choice value
  List<String> tags = [];

  // list of string options
  List<String> options = [
    'News', 'Entertainment', 'Politics',
    'Automotive', 'Sports', 'Education',
    'Fashion', 'Travel', 'Food', 'Tech',
    'Science',
  ];

  String user;
  final usersMemoizer = AsyncMemoizer<List<C2Choice<String>>>();

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final formKey = GlobalKey<FormState>();
  List<String> formValue;

  /* Future<List<C2Choice<String>>> getUsers() async {
    String url = "https://randomuser.me/api/?inc=gender,name,nat,picture,email&results=25";
    Response res = await Dio().get(url);
    return C2Choice.listFrom<String, dynamic>(
      source: res.data['results'],
      value: (index, item) => item['email'],
      label: (index, item) => item['name']['first'] + ' ' + item['name']['last'],
      meta: (index, item) => item,
    )..insert(0, C2Choice<String>(value: 'all', label: 'All'));
  } */

Route _createRoute(String idProducto) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return DetalleObservaciones(
          idProducto: idProducto,

        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ChipsChoice'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {

              Navigator.of(context).push(_createRoute('84'));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Expanded(
              child: ListView(
                addAutomaticKeepAlives: true,
                children: <Widget>[
                  Content(
                    title: 'Scrollable List Single Choice',
                    child: ChipsChoice<int>.single(
                      value: tag,
                      onChanged: (val) => setState(() => tag = val),
                      choiceItems: C2Choice.listFrom<int, String>(
                        source: options,
                        value: (i, v) => i,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                    ),
                  ),
                  Content(
                    title: 'Scrollable List Multiple Choice',
                    child: ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: options,
                        value: (i, v) => v,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                    ),
                  ),
                  Content(
                    title: 'Wrapped List Single Choice and Custom Border Radius',
                    child: ChipsChoice<int>.single(
                      value: tag,
                      onChanged: (val) => setState(() => tag = val),
                      choiceItems: C2Choice.listFrom<int, String>(
                        source: options,
                        value: (i, v) => i,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                      choiceStyle: C2ChoiceStyle(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      wrapped: true,
                    ),
                  ),
                  Content(
                    title: 'Wrapped List Multiple Choice and Right to Left Text Direction',
                    child: ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: options,
                        value: (i, v) => v,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                      wrapped: true,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Content(
                    title: 'Disabled Choice Item',
                    child: ChipsChoice<int>.single(
                      value: tag,
                      onChanged: (val) => setState(() => tag = val),
                      choiceItems: C2Choice.listFrom<int, String>(
                        source: options,
                        value: (i, v) => i,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                        disabled: (i, v) => [0, 2, 5].contains(i),
                      ),
                      wrapped: true,
                    ),
                  ),
                  Content(
                    title: 'Hidden Choice Item',
                    child: ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: options,
                        value: (i, v) => v,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                        hidden: (i, v) => ['Science', 'Politics', 'News', 'Tech'].contains(v),
                      ),
                      wrapped: true,
                    ),
                  ),
                  Content(
                    title: 'Individual Style Choice Item',
                    child: ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: options,
                        value: (i, v) => v,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                        style: (i, v) {
                          if (['Science', 'Politics', 'News', 'Tech'].contains(v)) {
                            return C2ChoiceStyle(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              showCheckmark: false,
                            );
                          }
                          return null;
                        },
                        activeStyle: (i, v) {
                          if (['Science', 'Politics', 'News', 'Tech'].contains(v)) {
                            return C2ChoiceStyle(
                              brightness: Brightness.dark
                            );
                          }
                          return null;
                        }
                      ),
                      wrapped: true,
                    ),
                  ),
                  Content(
                    title: 'Append an Item to Options',
                    child: ChipsChoice<int>.single(
                      value: tag,
                      onChanged: (val) => setState(() => tag = val),
                      choiceItems: C2Choice.listFrom<int, String>(
                        source: options,
                        value: (i, v) => i,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      )..insert(0, C2Choice<int>(value: -1, label: 'All')),
                    ),
                  ),
                  Content(
                    title: 'Without Checkmark and Custom Border Shape',
                    child: ChipsChoice<int>.single(
                      value: tag,
                      onChanged: (val) => setState(() => tag = val),
                      choiceItems: C2Choice.listFrom<int, String>(
                        source: options,
                        value: (i, v) => i,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      )..insert(0, C2Choice<int>(value: -1, label: 'All')),
                      choiceStyle: C2ChoiceStyle(
                        showCheckmark: false,
                        labelStyle: const TextStyle(
                          fontSize: 20
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        borderColor: Colors.blueGrey.withOpacity(.5),
                      ),
                      choiceActiveStyle: const C2ChoiceStyle(
                        brightness: Brightness.dark,
                        borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          side: BorderSide(color: Colors.red)
                        ),
                      ),
                    ),
                  ),
                  /* Content(
                    title: 'Async Choice Items and Brightness Dark',
                    child: FutureBuilder<List<C2Choice<String>>>(
                      initialData: [],
                      future: usersMemoizer.runOnce(getUsers),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )
                              ),
                            ),
                          );
                        } else {
                          if (!snapshot.hasError) {
                            return ChipsChoice<String>.single(
                              value: user,
                              onChanged: (val) => setState(() => user = val),
                              choiceItems: snapshot.data,
                              choiceStyle: const C2ChoiceStyle(
                                color: Colors.blueGrey,
                                brightness: Brightness.dark,
                                margin: const EdgeInsets.all(5),
                                showCheckmark: false,
                              ),
                              choiceActiveStyle: const C2ChoiceStyle(
                                color: Colors.green,
                                brightness: Brightness.dark,
                              ),
                              choiceAvatarBuilder: (data) {
                                if (data.meta == null) return null;
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(data.meta['picture']['thumbnail']),
                                );
                              },
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(25),
                              child: Text(
                                snapshot.error.toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Content(
                    title: 'Async Choice Items Using choiceLoader',
                    child: ChipsChoice<String>.single(
                      value: user,
                      onChanged: (val) => setState(() => user = val),
                      choiceItems: null,
                      choiceLoader: getUsers,
                      choiceStyle: const C2ChoiceStyle(
                        color: Colors.blueGrey,
                        brightness: Brightness.dark,
                        margin: const EdgeInsets.all(5),
                        showCheckmark: false,
                      ),
                      choiceActiveStyle: const C2ChoiceStyle(
                        color: Colors.green,
                        brightness: Brightness.dark,
                      ),
                      choiceAvatarBuilder: (data) {
                        if (data.meta == null) return null;
                        return CircleAvatar(
                          backgroundImage: NetworkImage(data.meta['picture']['thumbnail']),
                        );
                      },
                    ),
                  ),
                   */Content(
                    title: 'Works with FormField and Validator',
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          FormField<List<String>>(
                            autovalidate: true,
                            initialValue: formValue,
                            onSaved: (val) => setState(() => formValue = val),
                            validator: (value) {
                              if (value?.isEmpty ?? value == null) {
                                return 'Please select some categories';
                              }
                              if (value.length > 5) {
                                return "Can't select more than 5 categories";
                              }
                              return null;
                            },
                            builder: (state) {
                              return Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: ChipsChoice<String>.multiple(
                                      value: state.value,
                                      onChanged: (val) => state.didChange(val),
                                      choiceItems: C2Choice.listFrom<String, String>(
                                        source: options,
                                        value: (i, v) => v.toLowerCase(),
                                        label: (i, v) => v,
                                        tooltip: (i, v) => v,
                                      ),
                                      choiceStyle: const C2ChoiceStyle(
                                        color: Colors.indigo,
                                        borderOpacity: .3,
                                      ),
                                      choiceActiveStyle: const C2ChoiceStyle(
                                        color: Colors.indigo,
                                        brightness: Brightness.dark,
                                      ),
                                      wrapped: true,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.errorText ?? state.value.length.toString() + '/5 selected',
                                      style: TextStyle(
                                        color: state.hasError
                                          ? Colors.redAccent
                                          : Colors.green
                                      ),
                                    )
                                  )
                                ],
                              );
                            },
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text('Selected Value:'),
                                      SizedBox(height: 5),
                                      Text('${formValue.toString()}')
                                    ]
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                RaisedButton(
                                  child: const Text('Submit'),
                                  color: Colors.blueAccent,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (formKey.currentState.validate()) {
                                      // If the form is valid, save the value.
                                      formKey.currentState.save();
                                    }
                                  }
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Content(
                    title: 'Custom Choice Widget',
                    child: ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: options,
                        value: (i, v) => v,
                        label: (i, v) => v,
                      ),
                      choiceBuilder: (item) {
                        return CustomChip(
                          label: item.label,
                          width: 70,
                          height: 100,
                          selected: item.selected,
                          onSelect: item.select
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              child: Content(
                title: 'Vertical Direction',
                child: ChipsChoice<int>.single(
                  value: tag,
                  onChanged: (val) => setState(() => tag = val),
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  choiceBuilder: (item) {
                    return CustomChip(
                      label: item.label,
                      width: double.infinity,
                      height: 90,
                      color: Colors.redAccent,
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      selected: item.selected,
                      onSelect: item.select
                    );
                  },
                  direction: Axis.vertical,
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomChip extends StatelessWidget {

  final String label;
  final Color color;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final bool selected;
  final Function(bool selected) onSelect;

  CustomChip({
    Key key,
    this.label,
    this.color,
    this.width,
    this.height,
    this.margin,
    this.selected,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: this.width,
      height: this.height,
      margin: margin ?? const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 5,
      ),
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: selected ? (color ?? Colors.green) : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
        border: Border.all(
          color: selected ? (color ?? Colors.green) : Colors.grey,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => onSelect(!selected),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Visibility(
              visible: selected,
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 32,
              )
            ),
            Positioned(
              left: 9,
              right: 9,
              bottom: 7,
              child: Container(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _about(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              'chips_choice',
              style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87),
            ),
            subtitle: const Text('by davigmacode'),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Easy way to provide a single or multiple choice chips.',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black54),
                  ),
                  Container(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

*/




import 'package:enchiladasapp/src/models/ReceivedNotification.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/detalle_promociones_local.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/home_local.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/productos_categoria.dart';
import 'package:enchiladasapp/src/pages/blocMapa/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:enchiladasapp/src/pages/detalle_producto_foto.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/pages/gestionar_direcciones.dart';
import 'package:enchiladasapp/src/pages/mapa_cliente.dart';
import 'package:enchiladasapp/src/pages/market_page.dart';
import 'package:enchiladasapp/src/pages/onboarding_page.dart';
import 'package:enchiladasapp/src/pages/ordenes/delivery_timeline.dart';
import 'package:enchiladasapp/src/pages/ordenes/ordenes_pago_page.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking_report.dart';
import 'package:enchiladasapp/src/pages/detalle_promociones.dart';
import 'package:enchiladasapp/src/pages/ticket.dart';
import 'package:enchiladasapp/src/pages/webview.dart';
import 'package:enchiladasapp/src/pages/zoom_foto_direccion.dart';
import 'package:enchiladasapp/src/pushProvider/push_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enchiladasapp/src/pages/categorias_especiales.dart';
import 'package:enchiladasapp/src/pages/detalle_pago.dart';
import 'package:enchiladasapp/src/pages/detalle_pedido.dart';
import 'package:enchiladasapp/src/pages/select_direction.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/pages/login_page.dart';
import 'package:enchiladasapp/src/pages/splash.dart';
import 'package:enchiladasapp/src/pages/home_page.dart';
import 'package:enchiladasapp/src/pages/desicion_page.dart';
import 'package:enchiladasapp/src/pages/ordenes/ordenes_page.dart';
import 'package:enchiladasapp/src/pages/puzzle/home_puzzle.dart';
import 'package:enchiladasapp/src/pages/puzzle/puzzle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'src/pages/blocMapa/mapa/mapa_bloc.dart';


Future<void> showNotificationWithIconBadge(
    ReceivedNotification notification) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'icon badge channel', 'icon badge name', 'icon badge description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(badgeNumber: 1);
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, '${notification.title}',
      '${notification.body}', platformChannelSpecifics,
      payload: notification.payload);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new Preferences();

  await prefs.initPrefs();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('logo');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  final appleSignInAvailable = await AppleSignInAvailable.check();
  initializeDateFormatting('es_MX').then(
    (_) => runApp(
      Provider<AppleSignInAvailable>.value(
        value: appleSignInAvailable,
        child: MyApp(),
      ),
    ),
  );

  //runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorkey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    final pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotification();

    pushNotificationProvider.mensajesPush.listen((event) {
      navigatorkey.currentState.pushNamed('timeline', arguments: event);
    });

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    /* final pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotification();  */
    super.initState();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen(
      (ReceivedNotification receivedNotification) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: receivedNotification.title != null
                ? Text(receivedNotification.title)
                : null,
            content: receivedNotification.body != null
                ? Text(receivedNotification.body)
                : null,
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await navigatorkey.currentState.pushNamed('timeline',
                      arguments: receivedNotification.payload);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        await navigatorkey.currentState
            .pushNamed('timeline', arguments: payload);
      },
    );
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

      providers: [
        BlocProvider(create: ( _ ) => MiUbicacionBloc() ),
        BlocProvider(create: ( _ ) => MapaBloc() ),
        //BlocProvider(create: ( _ ) => BusquedaBloc() ),
      ],
      child: ProviderBloc(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorkey,
          initialRoute: 'splash',
          theme: ThemeData(
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Colors.grey[50],
            canvasColor: Colors.transparent,
          ),

      
          routes: {
            '/': (BuildContext context) => HomePage(),
            'homeLocal': (BuildContext context) => HomeLocal(),
            'HomePuzzle': (BuildContext context) => HomePuzzle(),
            'puzzle': (BuildContext context) => PuzzlePage(),
            'login': (BuildContext context) => LoginPage(),
            'splash': (BuildContext context) => Splash(),
            'desicion': (BuildContext context) => DesicionPage(),
            'detalleP': (BuildContext context) => DetalleProductitos(),
            'detallePago': (BuildContext context) => DetallePago(),
            'sel_Direccion': (BuildContext context) => MapsSample(),
            'combo': (BuildContext context) => CategoriasEspecialesPage(),
            'ordenes': (BuildContext context) => OrdenesPage(),
            'ordenesPago': (BuildContext context) => OrdenesPagoPage(),
            'detallePedido': (BuildContext context) => DetallePedido(),
            /* 'pedidosRepartidor': (BuildContext context) => PedidosRepartidor(),
            'mapaRepartidor': (BuildContext context) => MapaRepartidor(), */
            'mapaCliente': (BuildContext context) => MapaCliente(),
            'ranking': (BuildContext context) => RankingPage(),
            'rankingReport': (BuildContext context) => RankingReport(),
            'zoomDireccion': (BuildContext context) => ZoomFotoDireccion(),
            'market': (BuildContext context) => MarketPage(),
            'timeline': (BuildContext context) => DeliveryTimeline(),
            'webView': (BuildContext context) => WebViewExample(),
            'ticket': (BuildContext context) => Ticket(),
            'gestionarDirecciones': (BuildContext context) => GestionarDirecciones(),
            'detalleProductoFoto': (BuildContext context) => DetalleProductoFoto(),
            'detallePromociones': (BuildContext context) => DetallePromociones(),
            'onboarding': (BuildContext context) => OnboardingPage(),
            'productosCategoria': (BuildContext context) => ProductosCategoria(),
            'detallePromocionesLocal': (BuildContext context) => DetallePromocionesLocal(),
            //'detallePedidoRepartidor': (BuildContext context) => DetallePedidoRepartidor(),

          }, 
        ),
      ),
    );
  }
}

