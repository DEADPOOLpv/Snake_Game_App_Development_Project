import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HighScores extends StatelessWidget
{
  final String documentId;
  const HighScores({Key? key, required this.documentId,}) : super(key : key);

  @override
  Widget build(BuildContext context)
  {
    CollectionReference highscores =
      FirebaseFirestore.instance.collection('highscores');
    return FutureBuilder<DocumentSnapshot>(
      future: highscores.doc(documentId).get(),
      builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.done)
        {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Row(
            children: [
              Text(data['Score'].toString()),
              const SizedBox(
                width: 10,
              ),
              Text(data['Name']),
            ],
          );
        }
        else
        {
          return const Text('Waiting');
        }
      }
    );
  }


}