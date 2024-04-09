import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:quote_of_the_day/database/database.dart';
import 'package:quote_of_the_day/screens/fav_screen.dart';

class RandomQuoteScreen extends StatefulWidget {
  const RandomQuoteScreen({super.key});

  @override
  State<RandomQuoteScreen> createState() => _RandomQuoteScreenState();
}

class _RandomQuoteScreenState extends State<RandomQuoteScreen> {
  // Timer? _updateTimer;

  // @override
  // void initState() {
  //   super.initState();
  //   _updateQuote(); // Initial quote fetch on app launch
  //   _updateTimer = Timer.periodic(Duration(days: 1), (_) => _updateQuote());
  // }

  // void _updateQuote() async {
  //   final db = FavDatabase(); // Create an instance of FavDatabase

  //   // Get the last update date from Hive
  //   final lastUpdateDate = await db.getLastUpdateDate();

  //   // Check if the update is due (no lastUpdateDate or different date)
  //   final today = DateTime.now();
  //   final formattedDate = today.toIso8601String();
  //   if (lastUpdateDate == null || lastUpdateDate != formattedDate) {
  //     await _getRandomQuote(); // Fetch and update the quote
  //     await db.storeLastUpdateDate(formattedDate); // Store the new date
  //   }
  // }

  String _quote = "Tap refresh to get today's quote";
  List<String> quoteList = [];
  final _myBox = Hive.box('mybox');
  FavDatabase db = FavDatabase();

  // // Function to get a random quote from the quotable API
  // Future<void> _getRandomQuote() async {
  //   final response =
  //       await http.get(Uri.parse('https://api.quotable.io/random'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     setState(() {
  //       _quote = data['content'];
  //     });
  //   } else {
  //     setState(() {
  //       _quote = 'Failed to load a quote';
  //     });
  //   }
  // }

  bool isRefreshed = false;

  Future<void> _getRandomQuote() async {
    isRefreshed = true;
    final apiKey =
        'CQUNWa9MXkLpz9BPI8Tn3w==5CYZpuMHHazkx0l6'; // Replace with your actual API Key
    final category = 'happiness';
    final url =
        Uri.parse('https://api.api-ninjas.com/v1/quotes?category=$category');

    final response = await http.get(url, headers: {'X-Api-Key': apiKey});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      if (data.isNotEmpty) {
        final randomQuote = data[Random().nextInt(data.length)];
        setState(() {
          _quote = randomQuote['quote'];
          // _author = randomQuote['author']; // Assuming you also want the author
        });
      } else {
        setState(() {
          _quote = 'No quotes found for "happiness" category.';
        });
      }
    } else {
      setState(() {
        _quote = 'Failed to load a quote (Error: ${response.statusCode})';
      });
    }
  }

  // void changeIsRefreshed() {
  //   isRefreshed = true;
  // }

  // Function to add the current quote to favorites
  void _addToFavorites(String quote) {
    if (isRefreshed == true) {
      db.favList.add([quote]);
      db.updateDataBase();
      isRefreshed = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please refresh'),
        ),
      );
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => FavPage(favQuote: quote)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavPage()),
              );
            },
            icon: Icon(Icons.favorite),
          )
        ],
        title: Text("Quote Generator"),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Quote of the day",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Text(
                                _quote,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(new ClipboardData(text: _quote))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to your clipboard !'),
                            ),
                          );
                        });
                      },
                      child: const Text("Share"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        _addToFavorites(_quote);
                      },
                      child: Text("Add to Fav"),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _getRandomQuote,
                      child: Text("Refresh"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
