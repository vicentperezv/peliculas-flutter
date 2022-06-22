import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
   
  const AlertScreen({Key? key}) : super(key: key);
  
  void displayDialogIOS(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: ( context ){
        return CupertinoAlertDialog(
          title: const Text('Alerta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Alerta!'),
              SizedBox( height: 10),
              
            ]
          )
        );
      });
  }

  void displayDialogAndroid(BuildContext context) {
    showDialog(
      context: context,
      builder: ( context ){
        return AlertDialog(
          elevation: 5,
          title: const Text('Alerta'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const[
              Text('Alerta!'),
              SizedBox( height: 10),
            ]
          )
        );
      });
  }
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: ElevatedButton(
           child: const Padding(
             padding:  EdgeInsets.symmetric(horizontal:20, vertical: 15),
             child:  Text('Monstrar alerta'),
           ),
           onPressed: () => Platform.isAndroid 
           ? displayDialogAndroid(context)
           : displayDialogIOS(context)
           ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.close),
        onPressed: ()=> Navigator.pop(context)
      ),
    );
  }
}