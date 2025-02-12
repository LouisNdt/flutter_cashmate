import 'package:cashmate/model/Transaction.dart';
import 'package:cashmate/operations.dart';
import 'package:cashmate/home.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp(transactions: [],));
}

// TODO : Remplacer la liste de transactions par deux classes model, une dépense et une revenu
// TODO : Revoir couleur background
// TODO : clavier number ne permet de cliquer sur "entrée" pour passer à la prochaine "slide"
// TODO : Progress bar ne se met pas à jour avec le swipe
// TODO : Finaliser le piechart pour voir clairement les catégories

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.transactions});
  final List<Transaction> transactions; // Ajoute cette ligne


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Mate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Cash Mate', transactions: transactions),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.transactions});
  final List<Transaction> transactions; // Ajoute cette ligne


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Index de la page actuelle
  late List<Transaction> transactions;

  void _addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
    });
  }

  @override
  void initState() {
    super.initState();
    transactions = List.from(widget.transactions); // ✅ Initialisation ici
  }

  // Changer l'index lorsqu'on clique sur un onglet
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Home(transactions: transactions),
      Operations(transactions: transactions),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      backgroundColor: const Color.fromRGBO(59, 15, 82, 1.0),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromRGBO(59, 15, 82, 1.0),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Operations",
            )
          ],
      ),
    );
  }
}
