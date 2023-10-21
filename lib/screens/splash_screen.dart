import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitWave(
              itemBuilder: (context, index) => DecoratedBox(
                decoration: BoxDecoration(
                    color: index.isEven ? Colors.white : Colors.amber),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
