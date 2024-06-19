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
    setState(() {
      _highScores = DatabaseHelper().getHighScores();
    });
  }

  Future<void> _clearHighScores() async {
    await DatabaseHelper().clearHighScores();
    setState(() {
      _highScores = DatabaseHelper().getHighScores();
  });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete all high scores?\n This action is permanent and cannot be reversed!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _clearHighScores();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
         actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _showConfirmationDialog,
            tooltip: 'Clear All Scores',
            color: const Color.fromARGB(200, 240, 20, 20),
            iconSize: 40,
          ),
          Container(width: 20.0,)
        ],
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
