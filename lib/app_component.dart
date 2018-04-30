/*
  app_component.dart
  Tristan Van Cise
  Programming Languages - Dart Presentation
  04/29/2018
  Contains all critical WebApp features.
  This is essentially the WebApp's main().
  WebStorm
*/

/**** Dependencies ****/
import 'package:firebase/firebase.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:async';

typedef T UpdateFunction<T>(T value);


// Define a bunch of dependencies for AngularDart to function properly
@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives],
  providers: const [materialProviders],
)

/**** "MAIN" ****/
class AppComponent implements OnInit{
  DatabaseReference counterRef, hedgehogRef, hamsterRef, alpacaRef;
  int count = 0, hedgehogs = 0, hamsters = 0, alpacas = 0;
  String alpaca_pics = "", hamster_pics = "", hedgehog_pics = "", count_pics = "";
  // When the app is first instantiated, load in data from Firebase.
  @override
  ngOnInit() {
    initializeApp(
        apiKey: "AIzaSyAwjzEBowc2zeDaofmSwxCiZR6e6erFlPI",
        authDomain: "dartdemo-b74c4.firebaseapp.com",
        databaseURL: "https://dartdemo-b74c4.firebaseio.com",
        projectId: "dartdemo-b74c4",
        storageBucket: "dartdemo-b74c4.appspot.com",
        messagingSenderId: "858450406809"
    );

    // Get references to each database entry
      counterRef = database().ref('counter');
      hedgehogRef = database().ref('Hedgehogs');
      hamsterRef = database().ref('Hamsters');
      alpacaRef = database().ref('Alpacas');

    // Update values to match what the database holds
    counterRef.onValue.listen((event) {
      count = event.snapshot.val();
    });
    hedgehogRef.onValue.listen((event) {
      hedgehogs = event.snapshot.val();
    });
    hamsterRef.onValue.listen((event) {
      hamsters = event.snapshot.val();
    });
    alpacaRef.onValue.listen((event) {
      alpacas = event.snapshot.val();
    });

    count_pics = loadAnimalImage("alpaca", count);
    hedgehog_pics = loadAnimalImage("hedgehog", hedgehogs);
    hamster_pics = loadAnimalImage("hamster", hamsters);
    alpaca_pics = loadAnimalImage("alpaca", alpacas);

    // Update values to match what the database holds
//    databaseRefs.forEach((ref) {
//      count = 1;
//      ref.onValue.listen((event) {
//        localDatabaseCounters[ref] = event.snapshot.val();
//        count = 2;
//      });
//    });
  }

  String loadAnimalImage(var name, int count) {
    String totalImages = "";

    for (var i = 0; i < count; ++i) {
      totalImages += """<img src="/assets/images/$name.png" width="50%">""";
    }
    return totalImages;
  }

  /** Buttons **/

  decrease(int key) async {
    var decreaseFunc = (c) => c - 1;
    switch(key) {
      case 0:
        count = await updateDatabase(decreaseFunc, counterRef);
        count_pics = loadAnimalImage("alpaca", count);
        break;
      case 1:
        hedgehogs = await updateDatabase(decreaseFunc, hedgehogRef);
        hedgehog_pics = loadAnimalImage("hedgehog", hedgehogs);
        break;
      case 2:
        hamsters = await updateDatabase(decreaseFunc, hamsterRef);
        hamster_pics = loadAnimalImage("hamster", hamsters);
        break;
      case 3:
        alpacas = await updateDatabase(decreaseFunc, alpacaRef);
        alpaca_pics = loadAnimalImage("alpaca", alpacas);
        break;
      default:
        throw new Exception("""Decrease decremented an invalid reference.
                               If you get this, it's all Ryan's fault. Just FYI""");
        break;
    }
  }

  increase(int key) async {
    var increaseFunc = (c) => c + 1;
    switch(key) {
      case 0:
        count = await updateDatabase(increaseFunc, counterRef);
        count_pics = loadAnimalImage("alpaca", count);
        break;
      case 1:
        hedgehogs = await updateDatabase(increaseFunc, hedgehogRef);
        hedgehog_pics = loadAnimalImage("hedgehog", hedgehogs);
        break;
      case 2:
        hamsters = await updateDatabase(increaseFunc, hamsterRef);
        hamster_pics = loadAnimalImage("hamster", hamsters);
        break;
      case 3:
        alpacas = await updateDatabase(increaseFunc, alpacaRef);
        alpaca_pics = loadAnimalImage("alpaca", alpacas);
        break;
      default:
        throw new Exception("""Increase incremented an invalid reference.
                               If you get this, it's all Ryan's fault. Just FYI""");
        break;
    }
  }

  // Make an asynchronous call to update the database and return a snapshot
  // of the new database state after the operation is complete.
  Future<int> updateDatabase(UpdateFunction<int> update, DatabaseReference ref) async {
    var transaction = await ref.transaction((current) {
      if (current != null) {
        current = update(current);
      }
      return current;
    });
    return transaction.snapshot.val();
  }
}
