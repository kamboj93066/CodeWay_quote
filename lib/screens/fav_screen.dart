import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quote_of_the_day/database/database.dart';
import 'package:quote_of_the_day/utils/quote_tile.dart';

class FavPage extends StatefulWidget {
  // final String? favQuote;

  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final _myBox = Hive.box('mybox');
  FavDatabase db = FavDatabase();
  // List<String> quoteList = ["This is a quote", "This is a second quote"];
  // late List<String> quoteList;
  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      // creating initial data
      db.createInitialData();
    }
    // else there is already data present
    else {
      db.loadData();
    }
    super.initState();
    // if (widget.favQuote != null) {
    //   addNewFavorite(widget.favQuote!);
    // }
  }

  // void addNewFavorite(String quote) {
  //   setState(() {
  //     db.favList.add(quote);
  //   });
  // }

  void deleteQuote(int index) {
    setState(() {
      db.favList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 250, 224),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Favorite quotes",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: db.favList.length,
        itemBuilder: (context, index) {
          return QuoteTile(
            quote: db.favList[index][0],
            deleteFunction: (context) => deleteQuote(index),
          );
        },
      ),
    );
  }
}
