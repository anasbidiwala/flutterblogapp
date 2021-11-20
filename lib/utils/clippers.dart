import 'package:flutter/material.dart';

class LoginBottomClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.lineTo(0, size.height*0.50);
    // var endPoint = Offset(size.width,size.height*0.50);
    // var controlPoint = Offset(size.width / 2, size.height);
    // path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
    //     endPoint.dx, endPoint.dy);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);


    //ANSWER
    print("TOTAL Width ${size.width}");
    print("Total Height ${size.height}");

    path.moveTo(0, 0);
    var endPoint = Offset(size.width,0);
    var controlPoint = Offset((size.width * 0.50), (size.height * 0.1));
    print("Control POINT (${controlPoint.dx},${controlPoint.dy})");
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
        endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();




    // path.lineTo(size.width * 0.3, size.height);
    // path.lineTo(size.width * 0.3, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width,0);

    // path.lineTo(size.width, 0);
    // path.lineTo(0, size.width * 0.5);
    return path;
  }

  @override
  bool shouldReclip(LoginBottomClipper oldClipper) =>
      false;
}


class ScaffoldTopBackCurve extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.lineTo(0, size.height*0.50);
    // var endPoint = Offset(size.width,size.height*0.50);
    // var controlPoint = Offset(size.width / 2, size.height);
    // path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
    //     endPoint.dx, endPoint.dy);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);


    //ANSWER
    print("TOTAL Width ${size.width}");
    print("Total Height ${size.height}");

    path.moveTo(0, size.height * 0.35);

    var endPoint = Offset(size.width * 0.5,0);
    var controlPoint = Offset((size.width * 0.35), (size.height * 0.45));
    print("Control POINT (${controlPoint.dx},${controlPoint.dy})");
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
        endPoint.dx, endPoint.dy);
    path.lineTo(0, 0);

    path.close();




    // path.lineTo(size.width * 0.3, size.height);
    // path.lineTo(size.width * 0.3, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width,0);

    // path.lineTo(size.width, 0);
    // path.lineTo(0, size.width * 0.5);
    return path;
  }

  @override
  bool shouldReclip(ScaffoldTopBackCurve oldClipper) =>
      false;
}

class ScaffoldBottomBackCurve extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.lineTo(0, size.height*0.50);
    // var endPoint = Offset(size.width,size.height*0.50);
    // var controlPoint = Offset(size.width / 2, size.height);
    // path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
    //     endPoint.dx, endPoint.dy);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);


    //ANSWER
    print("TOTAL Width ${size.width}");
    print("Total Height ${size.height}");

    path.moveTo(size.width, size.height * 0.65);
    var endPoint = Offset(size.width * 0.5,size.height);
    var controlPoint = Offset((size.width * 0.65), (size.height * 0.55));
    print("Control POINT (${controlPoint.dx},${controlPoint.dy})");
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy,
        endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);

    path.close();




    // path.lineTo(size.width * 0.3, size.height);
    // path.lineTo(size.width * 0.3, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width,0);

    // path.lineTo(size.width, 0);
    // path.lineTo(0, size.width * 0.5);
    return path;
  }

  @override
  bool shouldReclip(ScaffoldBottomBackCurve oldClipper) =>
      false;
}

class ChatBubbleShape extends CustomPainter {
  final Color bgColor;

  ChatBubbleShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}