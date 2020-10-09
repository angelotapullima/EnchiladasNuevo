
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
      maxAgeCacheObject: Duration(days:100), //duración del cache en dias
      maxNrOfCacheObjects: 3006054640); //maximo de elementos en cache

  Future<String> getFilePath() async {
    //método para obtener el archivo del cache
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}
