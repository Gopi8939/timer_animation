

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {

  final double? animation;
  final bool stoptime;
  final int minutes;
  const ClockView({ Key? key, required this.animation, required this.stoptime, required this.minutes }) : super(key: key);

  
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> with SingleTickerProviderStateMixin{

   @override
  void initState() {
    setState(() {
    
    });
   Timer.periodic(Duration(milliseconds: 500),(timer){
     setState(() {
      print("value of stoptime ${widget.stoptime}");
     
     });
   });
     
    super.initState();
  
     

  
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
     
       Container(
         width: 300,
         height: 300,
         child: Transform.rotate(
           angle: -pi / 2,
           child: CustomPaint(
             painter: ClockPainter(widget.animation,widget.minutes,widget.stoptime),
           ),
         ),
         
       ),
      ],
    );
  }
}

class ClockPainter extends CustomPainter {
 
  var dateTime= DateTime.now();


// -------CALCULATION TO MOVE SECONDS HAND ------
  // 60 sec = 360 degree, 
  // 360/60 = 6, 
  // We should change 6 dregree per second

   final strokeCircle =40.0;
  double? currentProgress;
  final int? minutes;
  final bool? stoptime;
  ClockPainter(this.currentProgress, this.minutes, this.stoptime);

  @override
  void paint(Canvas canvas, Size size) {

   // I am drawing circle here
    Paint outcircle = Paint()
    ..strokeWidth = strokeCircle
    ..color = Colors.white
    ..style = PaintingStyle.stroke;

     Offset circlecenter =Offset(size.width/2,size.height/2);//center of device
    double circleradius =120;
    canvas.drawCircle(circlecenter, circleradius, outcircle);

    // TODO: implement paint

    var centerX=size.width/2;
    var centerY=size.height/2;
    var center =Offset(centerX,centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()
    ..color = Color(0xFF444974);

     var outlineBrush = Paint()
     ..color = Color.fromARGB(255, 0, 0, 0)
     ..style=PaintingStyle.stroke
     ..strokeWidth=16;

      var centerFillBrush = Paint()
      ..color = Color(0xFFEAECFF);


        var secHandBrush = Paint()
    ..color=Colors.orange[300]!
    ..style=PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth=10;

      var minHandBrush = Paint()
    ..color=Color(0xffEB5757)
    ..style=PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
    ..strokeWidth=4;

     var hourHandBrush = Paint()
    ..shader = RadialGradient(colors: [Colors.lightBlue,Colors.pink])
    .createShader(Rect.fromCircle(center: center, radius: radius))
    ..style=PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
    ..strokeWidth=16;

     var dashBrush = Paint()
      ..color = Color(0xFF28ABD8)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.5;
    
  
   // I am drawing animation here
     Paint animationArc = Paint()
     ..strokeWidth = 40
     ..color = stoptime==true?Color(0xffEE4444):Color(0xff19ADBC)
     ..style = PaintingStyle.stroke
     ..strokeCap = StrokeCap.butt;

     double angle =2 * pi *(currentProgress!/60);
     canvas.drawArc(Rect.fromCircle(center: circlecenter, radius: circleradius),
      pi/180, angle, false, animationArc);
    
   // canvas.drawCircle(center, radius-40, fillBrush);
  //  canvas.drawCircle(center, radius-40, outlineBrush);
 var outerCircleRadius = radius-36; 
      var innerCircleRadius = radius -30;
      for(double i = 0; i < 360; i += 6){
        var x1 = centerX + outerCircleRadius  * cos(i * pi/180);
        var y1 = centerX + outerCircleRadius  * sin(i * pi/180);

        var x2 = centerX + innerCircleRadius  * cos(i * pi/180);
        var y2 = centerX + innerCircleRadius  * sin(i * pi/180);
        canvas.drawLine(Offset(x1,y1),Offset(x2,y2),dashBrush);
      }     
    // var  hourHandX = centerX + 60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    // var  hourHandY = centerX + 60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi /180 );
    // canvas.drawLine(center, Offset(hourHandX,hourHandY), hourHandBrush);
  

    var minHandX = centerX + 140 * cos(minutes!*0.1 * pi / 180);
    var minHandY = centerX + 140 * sin(minutes!*0.1 * pi /180 );
    canvas.drawLine(center, Offset(minHandX,minHandY),minHandBrush);

    // var secHandX = centerX + 90 * cos(dateTime.second*6 * pi / 180);
    // var secHandY = centerX + 90 * sin( dateTime.second*6 * pi /180 );
    // canvas.drawLine(center, Offset(secHandX,secHandY), secHandBrush);

     // canvas.drawCircle(center, 55, centerFillBrush,);

     
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
   return true;
  }
}