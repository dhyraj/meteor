import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Meteor App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var myFavourites = <WordPair>[];
  void toggleFavourite() {
    if(myFavourites.contains(current)) {
      myFavourites.remove(current);
    } else {
      myFavourites.add(current);
    }
    notifyListeners();
  }

  bool isFavourite() {
    return myFavourites.contains(current);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState()  => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget window;
    switch(selectedIndex) {
      case 0:
        window = NetworkWindow();
        break;
      case 1:
        window = Placeholder();
        break;
      case 2:
        window = Placeholder();
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");

    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(IconData(0xe5e0, fontFamily: 'MaterialIcons')),
                      label: Text('network speed')),
                  NavigationRailDestination(
                      icon: Icon(IconData(0xf8b3, fontFamily: 'MaterialIcons')),
                      label: Text('CPU')),
                  NavigationRailDestination(
                      icon: Icon(IconData( 0xf6a5, fontFamily: 'MaterialIcons')),
                      label: Text('temperature'))
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                }),
          ),
          Expanded(
              child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: window,
          ))
        ],
      ),
    );
  }

}

class NetworkWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.isFavourite()) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavourite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
            pair.asCamelCase,
            style: style,
            semanticsLabel: pair.asPascalCase,),
      ),
    );
  }
}

