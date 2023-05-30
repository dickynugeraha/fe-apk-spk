import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bobot.dart';
import '../../widgets/app_drawer.dart';
import './bobot_edit_screen.dart';
import '../../widgets/bobot_table.dart';

class BobotScreen extends StatefulWidget {
  static const routeName = "/bobot";

  const BobotScreen({Key key}) : super(key: key);

  @override
  State<BobotScreen> createState() => _BobotScreenState();
}

class _BobotScreenState extends State<BobotScreen> {
  var _isInit = true;
  var _isLoading = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<BobotProvider>(context)
          .fetchAndSetBobot()
          .then((_) => _isLoading = false);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/bg1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Bobot"),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        drawer: const AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).splashColor),
              )
            : SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: const Card(
                    child: BobotTable(),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(BobotEditScreen.routeName);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
