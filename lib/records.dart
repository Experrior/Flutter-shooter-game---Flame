import 'package:archerer/db_helper.dart';
import 'package:archerer/home.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HighScoreListPage extends StatefulWidget {
  @override
  _HighScoreListPageState createState() => _HighScoreListPageState();
}

class _HighScoreListPageState extends State<HighScoreListPage> {
  late Future<List<HighScore>> _highScores;
final ScrollController _firstController = ScrollController();
  @override
  void initState() {
    super.initState();
    databaseFactory = databaseFactoryFfi;
    WidgetsFlutterBinding.ensureInitialized();
    _highScores = DatabaseHelper().getHighScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High Scores'),
      ),
      body: FutureBuilder<List<HighScore>>(
        future: _highScores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No high scores found.'));
          } else {
            return Scrollbar(
                thumbVisibility: true,
                controller: _firstController,
                child: ListView.builder(
                    controller: _firstController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final highScore = snapshot.data![index];
                return ListTile(
                  title: Text('Score: ${highScore.score}'),
                  subtitle: Text('Date: ${highScore.dateTime}'),
                );
              },
                ),
            );
          }
        },
      ),
    );
  }
}
