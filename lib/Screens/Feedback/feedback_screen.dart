import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<String> items = ["pdf to jpg", "jpg to pdf", "pdf to doc", "doc to pdf"
  ];
    return Scaffold(
      appBar: AppBar(
      title: const Text('Feedback form'),
      ),
      body: Center(
      child: ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {try {
            final _auth = FirebaseAuth.instance;
            final user = await _auth.currentUser;
            final email = await _auth.currentUser?.email;
            if (user != null) {
              if(user.isAnonymous){
              showDialog(
              context: context, builder: (context) =>TextFieldWidget(),
            );
            } else {
            showDialog(
            context: context, builder: (context) => RatingWidget(index: '${items[index]}', user: '$email'),
            );
            }
            }
          } catch (e) {
            print(e);
          }
        },

          child: Text('${items[index]}'),
        );
      }
      ),
      ),
      );
  }

}
class TextFieldWidget extends StatefulWidget {
 
  const TextFieldWidget({Key? key}) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: TextField(
        decoration: InputDecoration(
        hintText: "Enter your name",
        )
        )
    );
  }
}
  




class RatingWidget extends StatefulWidget {
  final String index;
  final String user;

  const RatingWidget({Key? key, required this.index, required this.user }) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState(index,user);
}

class _RatingWidgetState extends State<RatingWidget> {
  final String index;
  final String user;
  double rating=0;
  final TextEditingController _controller = TextEditingController();
  //final GlobalKey<FormState> _formKey = GlobalKey();

  _RatingWidgetState(this.index, this.user);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 30,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
      Icons.star,
      color: Colors.amber,
      ),
      onRatingUpdate: (rating) async {
        var c;
        final r;
        double previusFeedback= 0;

        //collegamento con datrabase dei task con relativo feedback
        var documentSnapshot = await FirebaseFirestore.instance
            .collection("task")
            .doc(index)
            .get();

        //recupero somma di feedback e numero totale
        final fieldValue = documentSnapshot.data()as Map<String, dynamic>;
        c = fieldValue['num_feed'];
        r = fieldValue['sum'];

        //collegamento a user con relativo feedback dato se presente
        final DocumentReference ratingRef = FirebaseFirestore.instance.collection("ratings").doc(user).collection(index).doc('ratings');
        DocumentSnapshot ratingSnapshot = await ratingRef.get();
        if (ratingSnapshot.exists && ratingSnapshot.data()!=null) {
          final data = ratingSnapshot.data()as Map<String, dynamic>;
          previusFeedback=data['ratings'] ;
          ratingRef.set({'ratings': rating});
        }else{
          previusFeedback=0;
          ratingRef.set({'ratings': rating});
          c= c+1;
        }

      //   var documentSnapshotUser = await FirebaseFirestore.instance
      //       .collection('utente_feedback')
      //       .doc(index)
      //       .get();
      //
      // if (documentSnapshotUser != null){
      //    final fieldValueUser = documentSnapshotUser.data()as Map<String, dynamic>;
      //     previusFeedback = fieldValueUser['feedback'];
      //     await collectionUser.doc(index).set({
      //       'feedback': rating,
      //     });
      //   } else {
      //     await collectionUser.doc(index).set({
      //       'feedback': rating,
      //     });
      //     previusFeedback = 0;
      //   }

        var rating1 = ( r + rating - previusFeedback) / (c);

        final collection =
        FirebaseFirestore.instance.collection('task');
          // Write the server's timestamp and the user's feedback
        await collection.doc(index).set({
        'num_feed': c,
        'feedback_tot': rating1,
          'sum': r + rating - previusFeedback,
        });
        Navigator.pop(context);
    },
      ),
    );
  }
}

// key: _formKey,
// child: TextFormField(
// controller: _controller,
// keyboardType: TextInputType.multiline,
// decoration: const InputDecoration(
// hintText: 'Enter your feedback here',
// filled: true,
// ),
// maxLines: 5,
// maxLength: 4096,
// textInputAction: TextInputAction.done,
// validator: (String? text) {
// if (text == null || text.isEmpty) {
// return 'Please enter a value';
// }
// return null;
// },
// ),
// ),
// actions: [
// TextButton(
// child: const Text('Cancel'),
// onPressed: () => Navigator.pop(context),
// ),
// TextButton(
// child: const Text('Send'),
// onPressed: () async {
// // Only if the input form is valid (the user has entered text)
// if (_formKey.currentState!.validate()) {
// // We will use this var to show the result
// // of this operation to the user
// String message;
//
// try {
// // Get a reference to the `feedback` collection
// final collection =
// await FirebaseFirestore.instance.collection('feedback');
//
// // Write the server's timestamp and the user's feedback
// await collection.doc().set({
// 'timestamp': FieldValue.serverTimestamp(),
// 'feedback': _controller.text,
// });
//
// message = 'Feedback sent successfully';
// } catch (e) {
// message = 'Error when sending feedback';
// //print (e);
// }
//
// // Show a snackbar with the result
// ScaffoldMessenger.of(context)
//     .showSnackBar(SnackBar(content: Text(message)));
// Navigator.pop(context);
// }
// },
// )
// ],
// );