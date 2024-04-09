import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:todo/utils/priority.dart';
// import 'package:todo/utils/priority.dart';

class QuoteTile extends StatelessWidget {
  final String quote;
  final Function(BuildContext)? deleteFunction;

  QuoteTile({
    super.key,
    required this.quote,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0, left: 25, right: 25),
        child: Slidable(
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteFunction,
                icon: Icons.delete,
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color.fromARGB(200, 221, 161, 94),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      width: 200,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(width: 0.5, color: Colors.black),
                      // ),
                      child: Text(quote,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.heart_broken),
                      onSelected: (value) {
                        if (value == 'Delete') {
                          deleteFunction!(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'Delete',
                          child: Text('Remove From Favourites?'),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
