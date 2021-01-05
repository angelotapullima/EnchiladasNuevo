import 'package:flutter/material.dart';

class PrincipalChangeBloc extends ChangeNotifier {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  ValueNotifier<bool> get cargando => this._cargando;

  void setIndex(bool value) => this._cargando.value = value;
}
