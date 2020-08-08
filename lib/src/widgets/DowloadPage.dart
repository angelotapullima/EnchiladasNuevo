import 'package:enchiladasapp/src/models/puzzle_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/zona_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DowloadImagen extends StatefulWidget {
  final String foto;
  final String idImagen;
  final Widget devolucion;
  final Widget cargando;

  DowloadImagen({Key key, @required this.foto,@required this.devolucion,this.cargando, @required this.idImagen}) : super(key: key);

  @override
  _DescargaImagenState createState() => _DescargaImagenState();
}

class _DescargaImagenState extends State<DowloadImagen> {
  Stream<FileResponse> fileStream;

  _downloadFile() {
    setState(() {
      fileStream = CustomCacheManager()
          .getFileStream(widget.foto, withProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (fileStream == null) {
      _downloadFile();
    }

    return DownloadPage(
      fileStream: fileStream,
      foto: widget.foto,
      idImagen: widget.idImagen,
      devolucion: widget.devolucion,
    );
  }
}


class DownloadPage extends StatelessWidget {
  final Stream<FileResponse> fileStream;
  final String foto;
  final String idImagen;
  final Widget devolucion;
  final Widget cargando;

  const DownloadPage({Key key, this.fileStream, this.foto,@required this.devolucion,this.cargando, this.idImagen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FileResponse>(
      stream: DefaultCacheManager()
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

          body = ProgressIndicator(progress: snapshot.data as DownloadProgress);/* (this.cargando == null)?ProgressIndicator(progress: snapshot.data as DownloadProgress)
                                        :this.cargando; */



        } else {
          body = FileInfoWidget(
            fileInfo: snapshot.data as FileInfo,
            foto: foto,
            idImagen:this.idImagen ,
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
  final String  foto;
  final String  idImagen;
  final Widget devolucion;

  const FileInfoWidget({Key key, this.fileInfo, this.foto,this.devolucion, this.idImagen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    String path = fileInfo.originalUrl;
    return Column(
      children: <Widget>[


        GestureDetector(


          child: this.devolucion,
          onTap: () {
            RankingPuzzle puzzle= RankingPuzzle();
            puzzle.path = path;
            puzzle.idImagen = idImagen;

            //Navigator.pushNamed(context, 'puzzle', arguments: puzzle);
          },
        ),
      ],
    );
    //Text(title)
  }
}
