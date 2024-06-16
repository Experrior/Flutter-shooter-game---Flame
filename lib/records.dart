// import 'package:archerer/db_helper.dart';
// import 'package:archerer/home.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// class HighScoreListPage extends StatefulWidget {
//   const HighScoreListPage({super.key});

//   @override
//   _HighScoreListPageState createState() => _HighScoreListPageState();
// }

// class _HighScoreListPageState extends State<HighScoreListPage> {
//   late Future<List<HighScore>> _highScores;
// final ScrollController _firstController = ScrollController();
//   @override
//   void initState() {
//     super.initState();
//     databaseFactory = databaseFactoryFfi;
//     WidgetsFlutterBinding.ensureInitialized();
//     _highScores = DatabaseHelper().getHighScores();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('High Scores'),
//       ),
//       body: FutureBuilder<List<HighScore>>(
//         future: _highScores,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No high scores found.'));
//           } else {
//             return Scrollbar(
//                 thumbVisibility: true,
//                 controller: _firstController,
//                 child: ListView.builder(
//                     controller: _firstController,
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final highScore = snapshot.data![index];
//                 return ListTile(
//                   title: Text('Score: ${highScore.score}'),
//                   subtitle: Text('Date: ${highScore.dateTime}'),
//                 );
//               },
//                 ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }



import 'package:archerer/db_helper.dart';
import 'package:archerer/home.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HighScoreListPage extends StatefulWidget {
  const HighScoreListPage({super.key});

  @override
  _HighScoreListPageState createState() => _HighScoreListPageState();
}

class _HighScoreListPageState extends State<HighScoreListPage> {
  late Future<List<HighScore>> _highScores;
  final ScrollController _firstController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    databaseFactory = databaseFactoryFfi;
    _highScores = DatabaseHelper().getHighScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
      ),
      body: FutureBuilder<List<HighScore>>(
        future: _highScores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No high scores found.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scrollbar(
                thumbVisibility: true,
                controller: _firstController,
                child: ListView.builder(
                  controller: _firstController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final highScore = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.star,
                          color: Colors.yellow[700],
                          size: 36,
                        ),
                        title: Text(
                          'Score: ${highScore.score}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Date: ${highScore.dateTime}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
