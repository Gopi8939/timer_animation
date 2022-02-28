import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_animation/clock_view.dart';

class HomePage extends StatefulWidget {
  final int animiTime;
  const HomePage({Key? key, required this.animiTime}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  final maxProgress = 60.0;

  bool isAnimi = false;
  bool timerstoped = false;

  static const maxSeconds = 0;
  int minutes = maxSeconds;
  Timer? timer;
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (minutes < 3600) {
        setState(() {
          minutes++;
        });
      } else {
        stopTimer(reset:false);
      }
    });
  }
   void resetTimer() {
     setState(() {
       minutes=maxSeconds;
     });
   }

  void stopTimer({bool reset=true}) {
    print("Stop Timer Called");
    if(reset){
      resetTimer();
    }
    timer?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(seconds: 10), (_) {});

    super.initState();
    startTimer();

    _animationController = AnimationController(
        vsync: this, duration: Duration(minutes: widget.animiTime));
    _animationController?.forward();
    var gg = _animationController?.status;
    print(gg);
    _animation =
        Tween<double>(begin: 0, end: maxProgress).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
  }

  void showCustomDialog(BuildContext context) => showDialog(
      context: context,
      builder: (
        BuildContext ctxt,
      ) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/shock_icon.png"),
                  Text("Are you sure want to STOP ?"),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              timerstoped = true;
                              print("gopi $timerstoped");
                              stopTimer(reset:false);
                            });
                            _animationController?.stop(canceled: false);
                            Navigator.of(context).pop();
                          },
                          child: Text("Yes")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No")),
                    ],
                  )
                ],
              ),
            ));
      });

  Widget buildStopButtons() {
    final isRunning = timer == null ? false : timer?.isActive;
    return ElevatedButton(
      style:ButtonStyle(
        
        backgroundColor:  MaterialStateProperty.all<Color>(Colors.red)
      ),
      
      child: Text("stop?"),
      onPressed: () {
        showCustomDialog(context);
      },
    );
  }

   Widget buildResumeButtons() {
    
    return ElevatedButton(
      
      child: Text("Resume?"),
      onPressed: () {
          timerstoped = false;
        startTimer();
        _animationController?.forward();

        
      },
    );
  }

    Widget buildCancelButtons() {
    
    return ElevatedButton(
       style:ButtonStyle(

        backgroundColor:  MaterialStateProperty.all<Color>(Colors.red)
      ),
      child: Text("Cancel?"),
      onPressed: () {
        stopTimer(reset:true);
        _animationController?.reset();
     

        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xff2E2D39),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:  Center(child: Text("Grinding")),
        centerTitle: true,
       
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Container(
                width: 300,
                height: 300,
                //color: Color.fromARGB(255, 255, 255, 255),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                            color: Color(0xffDFDDDD),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 50,
                                spreadRadius: 5,
                                //color: Colors.grey.withOpacity(0.5)
                              )
                            ],
                            shape: BoxShape.circle),
                        child: Stack(
                          children: [
                            ClockView(
                              animation: _animation?.value,
                              stoptime: timerstoped,
                              minutes: minutes,
                            ),
                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Color(0xffDFDDDD),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          spreadRadius: 6,
                                          color: Colors.grey.withOpacity(0.5))
                                    ],
                                    shape: BoxShape.circle),
                              ),
                            ),
                            Center(
                                child: GestureDetector(
                              onTap: () {
                                _animation?.value == maxProgress
                                    ? _animationController?.reverse()
                                    : _animationController?.forward();
                              },
                              child: Text(
                                "${_animation?.value.toInt()}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 50),
                              ),
                            )),
                            Text(
                                "${minutes}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 50),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
         
         Text("Sit back and wait for ",style: TextStyle(
           color: Colors.white,
           letterSpacing:0.5
         ),),
          timerstoped==true?
          Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
              
             Text("Stopped By You "
             ,style: TextStyle(
           color: Colors.white,
           letterSpacing:0.5
         ),
             ),
             SizedBox(width: 10,),
             buildResumeButtons()
           ],
         )
          :
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
              
             Text("Will be ready at 7.00 PM"
             ,style: TextStyle(
           color: Colors.white,
           letterSpacing:0.5
         ),
             ),
             SizedBox(width: 10,),
              buildStopButtons(),
           ],
         ),
         timerstoped==true?Column(
         
           children: [
         
          buildCancelButtons()
           ],
         ):Container()
        

         
        ],
      ),
    ));
  }

 
}
