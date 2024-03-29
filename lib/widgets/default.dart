import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NoTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/empty1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'No Tasks Available',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              AutoSizeText(
                'Add your tasks to get started!',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      );
    });
  }
}
