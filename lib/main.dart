import 'package:cashmate/model/Transaction.dart';
import 'package:cashmate/operations.dart';
import 'package:cashmate/home.dart';
import 'package:cashmate/theme/dark.dart';
import 'package:cashmate/theme/light.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp(transactions: [],));
}

// TODO : clavier number ne permet de cliquer sur "entrée" pour passer à la prochaine "slide"
// TODO : Finaliser le piechart pour voir clairement les catégories

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.transactions});
  final List<Transaction> transactions; // Ajoute cette ligne


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Mate',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
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
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
