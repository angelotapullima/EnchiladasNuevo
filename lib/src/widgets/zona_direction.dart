
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DowloadZona extends StatefulWidget {
  final Zona zona;
  final Widget devolucion;
  final Widget cargando;

  DowloadZona({Key key, @required this.zona,@required this.devolucion,this.cargando,  }) : super(key: key);

  @override
  _DescargaImagenState createState() => _DescargaImagenState();
}

class _DescargaImagenState extends State<DowloadZona> {
  Stream<FileResponse> fileStream;

  _downloadFile() {
    setState(() {
      fileStream = CustomCacheManager()
          .getFileStream(widget.zona.zonaImagen, withProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (fileStream == null) {
      _downloadFile();
    }

    return DownloadZonaPage(
      fileStream: fileStream,
      foto: widget.zona.zonaImagen,
      devolucion: widget.devolucion,
    );
  }
}


class DownloadZonaPage extends StatelessWidget {
  final Stream<FileResponse> fileStream;
  final String foto;
  final String nombre;
  final String pedidoMinimo;
  final String descripcion;
  final String idZona;
  final Widget devolucion;
  final Widget cargando;
  final String route;

  const DownloadZonaPage({Key key, this.fileStream, this.foto,@required this.devolucion,this.cargando, this.nombre, this.pedidoMinimo, this.descripcion, this.idZona, this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FileResponse>(
      stream: CustomCacheManager()
          .getFileStream(foto, withProgress: true),
      builder: (context, snapshot) { 
        Widget body;

        var loading = !snapshot.hasData || snapshot.data is DownloadProgress;

        if (snapshot.hasError) {
          body = ListTile(
            title: const Text('Error'),
            subtitle: Text(snapshot.error.toString()),
          );
        } else if (loading) {

          body = ProgressIndicator(progress: snapshot.data as DownloadProgress);
        } else {
          body = FileInfoWidget(
            fileInfo: snapshot.data as FileInfo,
            nombre: nombre,
            pedidoMinimo: pedidoMinimo,
            descripcion: descripcion,
            idZona: idZona,
            route: route,
            devolucion: this.devolucion,
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          //appBar: _appBar(),
          body: body,
        );
      },
    );
  }
}


class ProgressIndicator extends StatelessWidget {
  final DownloadProgress progress;
  const ProgressIndicator({Key key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            child: Center(
              child: CircularProgressIndicator(
                value: progress?.progress,
              ),
            ),
          ),
          SizedBox(width: responsive.wp(5)),
          Text(
            'Obteniendo Imágen',
            style: TextStyle(fontSize: responsive.ip(2)),
          ),
        ],
      ),
    );
  }
}

class FileInfoWidget extends StatelessWidget {
  final FileInfo fileInfo;
  final Widget devolucion;
  final String nombre;
  final String pedidoMinimo;
  final String descripcion;
  final String idZona;
  final String route;

  const FileInfoWidget({Key key, this.fileInfo,this.devolucion, this.nombre, this.pedidoMinimo, this.descripcion, this.idZona, this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    String path = fileInfo.originalUrl;
    return Column(
      children: <Widget>[


        GestureDetector( 


          child: this.devolucion,
          onTap: () {
            Zona zona = Zona();
            zona.zonaImagen = path;
            zona.idZona = idZona;
            zona.zonaNombre = nombre;
            zona.zonaPedidoMinimo=pedidoMinimo;
            zona.zonaDescripcion=descripcion;
            zona.route=route;

            Navigator.pushNamed(context, 'zoomDireccion', arguments: zona);
          },
        ),
      ],
    );
    //Text(title)
  }
}

//clase para mantener en cache las Imagenes del servidor
class CustomCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    //creación del Singleton
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(key,
      maxAgeCacheObject: Duration(days:30), //duración del cache en dias
      maxNrOfCacheObjects: 200); //maximo de elementos en cache

  Future<String> getFilePath() async {
    //método para obtener el archivo del cache
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}
