



 
part of 'custom_markers.dart';

class MarkerDetinoPainter extends CustomPainter {

  final String descripcion;
  final double metros;

  MarkerDetinoPainter(this.descripcion, this.metros);

  @override
  void paint(Canvas canvas, Size size) {
      
    final double circuloNegroR  = 30;
    final double circuloBlancoR = 9;

    Paint paint = new Paint()
      ..color = Colors.red;

    // Dibujar circulo negro
    canvas.drawCircle(
      Offset( circuloNegroR , size.height - circuloNegroR),
      30, 
      paint
    );

    // Circulo Blanco
    paint.color = Colors.white;

    canvas.drawCircle(
      Offset( circuloNegroR, size.height - circuloNegroR ), 
      circuloBlancoR, 
      paint
    );

    // Sombra
    final Path path = new Path();

    path.moveTo( 40, 20 );
    path.lineTo( size.width - 10, 20 );
    path.lineTo( size.width - 10, 100 );
    path.lineTo( 0, 100 );

    canvas.drawShadow(path, Colors.black87, 10, false);

    // Caja Blanca
    final cajaBlanca = Rect.fromLTWH( 40, 20, size.width + 80, 150);
    canvas.drawRect( cajaBlanca, paint);

    // Caja Negra
    paint.color = Colors.red;
    final cajaNegra = Rect.fromLTWH( 40, 20, 180, 150);
    canvas.drawRect( cajaNegra, paint);

    // Dibujar textos
    double kilometros = this.metros / 1000;
    kilometros = ( kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    TextSpan textSpan = new TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 40, fontWeight: FontWeight.w400 ),
      text: '${this.metros}'
    );

    TextPainter textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 160,
      minWidth: 160
    );

    textPainter.paint(canvas, Offset( 50, 50));

    // Minutos
    textSpan = new TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 40, fontWeight: FontWeight.w400 ),
      text: 'Km'
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 120,minWidth:120
    );

    textPainter.paint(canvas, Offset( 50, 90));

    // Mi ubicación
    textSpan = new TextSpan(
      style: TextStyle( color: Colors.black, fontSize: 40, fontWeight: FontWeight.w400 ),
      text: this.descripcion
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 3,
      ellipsis: '...'
    )..layout(
      maxWidth: size.width- 100,
    );

    textPainter.paint(canvas, Offset( 230, 60 ));







  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;


}