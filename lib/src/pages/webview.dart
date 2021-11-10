import 'dart:async';
import 'package:enchiladasapp/src/bloc/nuevo_metodo_pago.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/argumentDetallePedido.dart';
import 'package:enchiladasapp/src/models/argumentsWebview.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    final ArgumentsDetallePago args = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);

    final nuevoMetodoPagoBloc = ProviderBloc.npago(context);

    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (c) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ), //this right here
          child: Container(
            height: responsive.hp(35),
            width: responsive.wp(70),
            child: Padding(
              padding: EdgeInsets.all(
                responsive.ip(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: responsive.ip(5),
                        width: responsive.ip(5),
                        child: Image.asset('assets/logo_enchilada.png'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Text(
                    'El pago está en proceso',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: responsive.ip(1.8),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  Text(
                    'Está seguro de salir ?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                      fontSize: responsive.ip(1.8),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        child: Text('Si'),
                        onPressed: () => Navigator.pop(c, true),
                      ),
                      MaterialButton(
                        child: Text('No'),
                        onPressed: () => Navigator.pop(c, false),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pago Online'),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
          /* actions: <Widget>[
            NavigationControls(_controller.future),
            //SampleMenu(_controller.future),
          ], */
        ),
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: StreamBuilder(
          stream: nuevoMetodoPagoBloc.estadoWebview,
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                _contenidoWebview(args, nuevoMetodoPagoBloc),

                (snapshot.hasData)?
                (nuevoMetodoPagoBloc.valorEstadoWe == true)
                    ? Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : Container(): Container()
              ],
            );
          },
        ),
      ),
    );
  }

  Builder _contenidoWebview(ArgumentsDetallePago args, NuevoMetodoPagoBloc nuevoMetodoPagoBloc) {
    return Builder(
      builder: (BuildContext context) {
        return WebView(
          initialUrl: args.link,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // elimine esto cuando los literales de colección se establezcan.
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          /* navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('www.google.com')) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  }, */
          onPageStarted: (String url) {
            print('Page started loading: $url');
            nuevoMetodoPagoBloc.changeEstadoWebview(true);

            if (url == 'https://delivery.lacasadelasenchiladas.pe/respuesta/index.php?respuesta=CORRECTO') {
              ArgumentsWebview argumentsWebview = ArgumentsWebview();
              argumentsWebview.idPedido = args.idPedido;
              argumentsWebview.codigo = '1';

              Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
            } else if (url == 'https://delivery.lacasadelasenchiladas.pe/respuesta/index.php?respuesta=CANCELADO') {
              ArgumentsWebview argumentsWebview = ArgumentsWebview();
              argumentsWebview.idPedido = args.idPedido;
              argumentsWebview.codigo = '2';

              Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
            } else if (url == 'https://delivery.lacasadelasenchiladas.pe/respuesta/index.php?respuesta=RECHAZADO') {
              ArgumentsWebview argumentsWebview = ArgumentsWebview();
              argumentsWebview.idPedido = args.idPedido;
              argumentsWebview.codigo = '3';

              Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
            } else if (url == 'https://delivery.lacasadelasenchiladas.pe/respuesta/index.php?respuesta=ERROR') {
              ArgumentsWebview argumentsWebview = ArgumentsWebview();
              argumentsWebview.idPedido = args.idPedido;
              argumentsWebview.codigo = '4';

              Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
            }
          },
          onPageFinished: (String url) {
            nuevoMetodoPagoBloc.changeEstadoWebview(false);
            print('Page finished loading: $url');

            if (url == 'https://delivery.lacasadelasenchiladas.pe/respuesta/index.php?respuesta=CORRECTO') {
              ArgumentsWebview argumentsWebview = ArgumentsWebview();
              argumentsWebview.idPedido = args.idPedido;
              argumentsWebview.codigo = '1';

              Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
            } else if (url == 'https://delivery.lacasadelasenchiladas.pe/respuesta/index.php?respuesta=CANCELADO') {
              ArgumentsWebview argumentsWebview = ArgumentsWebview();
              argumentsWebview.idPedido = args.idPedido;
              argumentsWebview.codigo = '2';

              Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
            } else if (url == 'https://delivery.lacasadelasenchiladas.pe/respuesta/index.php?respuesta=RECHAZADO') {
              ArgumentsWebview argumentsWebview = ArgumentsWebview();
              argumentsWebview.idPedido = args.idPedido;
              argumentsWebview.codigo = '3';

              Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
            } else if (url == 'https://delivery.lacasadelasenchiladas.pe/respuesta/index.php?respuesta=ERROR') {
              ArgumentsWebview argumentsWebview = ArgumentsWebview();
              argumentsWebview.idPedido = args.idPedido;
              argumentsWebview.codigo = '4';

              Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
            }
          },
          gestureNavigationEnabled: true,
        );
      },
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture) : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No back history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No forward history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
