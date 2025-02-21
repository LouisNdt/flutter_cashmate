import 'package:cashmate/main.dart';
import 'package:cashmate/model/Transaction.dart';
import 'package:flutter/material.dart';

class BudgetCreation extends StatefulWidget {
  const BudgetCreation({super.key});

  @override
  State<StatefulWidget> createState() => _BudgetCreationState();
}


class _BudgetCreationState extends State<BudgetCreation> {
  final List<String> categories = ["Salaire", "Autres revenus","Logement", "Alimentation", "Transport", "Esthétique", "Abonnements", "Loisirs", "Recap"];
  final PageController _pageController = PageController();
  final List<Transaction> transactions = [];
  Map<String, TextEditingController> _controllers = {};
  double totalRevenus =  0;
  double totalDepenses = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_currentPage + 1) / categories.length),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {
                _nextPage();
              }, icon: Icon(Icons.check,size: 30, color: Theme.of(context).primaryColorLight,)),
            ],
          ),
          Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryPage(categories[index], totalRevenus, totalDepenses);
                  }
              )
          ),

          Text("Dépenses totales : $totalDepenses", style: const TextStyle(fontSize: 14),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(_currentPage>0)  IconButton(onPressed: (){
                _previousPage();
              }, icon: const Icon(Icons.navigate_before_rounded)),
              IconButton(onPressed: () {
                _nextPage();
              }, icon: const Icon(Icons.navigate_next),)
            ],
          )
        ],
      )
    );
  }

  Widget _buildCategoryPage(String category, double totalRevenus, double totalDepenses) {
    if (category == "Recap") {
      return _buildRecapPage(totalRevenus);
    }

    if (!_controllers.containsKey(category)) {
      double existingAmount = transactions
          .firstWhere((t) => t.description == category, orElse: () => Transaction(description: category, amount: 0.0, isRevenu: false, icon: Icons.category))
          .amount;

      _controllers[category] = TextEditingController(text: existingAmount > 0 ? existingAmount.toString() : "");
    }
    FocusNode categoryFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentPage == categories.indexOf(category)) {
        FocusScope.of(context).requestFocus(categoryFocusNode);
      }
    });


    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category, style: TextStyle(fontSize: 18),),
          SizedBox(
            width: 200,
            child: TextField(
              controller: _controllers[category],
              focusNode: categoryFocusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onTapOutside: (event) => _nextPage(),
              onSubmitted: (value) => _nextPage(),
              onChanged: (value) {
                setState(() {
                  if(category=="Salaire" || category=="Autres revenus"){
                    _updateTransaction(category, double.tryParse(value) ?? 0.0, true);
                  }
                  _updateTransaction(category, double.tryParse(value) ?? 0.0, false);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecapPage(double totalDepenses){
    return Padding(padding: EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Total des dépenses : $totalDepenses", style: TextStyle(fontSize: 20),),
        ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(transactions: transactions)));
        }, child: Text("Voir le dashboard"))
      ],
    ),
    );
  }
  
  void _nextPage() {
    if(_currentPage < categories.length-1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _updateTransaction(String category, double amount, bool isRevenu) {
    // Vérifier si la catégorie existe déjà
    final existingIndex = transactions.indexWhere((t) => t.description == category);

    if (existingIndex != -1) {
      // Mise à jour de la valeur existante
      transactions[existingIndex].amount = amount;
    } else {
      if(isRevenu==false){
        totalDepenses += amount;
      } else {
        totalRevenus += amount;
      }
      // Ajout d'une nouvelle transaction
      transactions.add(new Transaction(description: category, amount: amount, isRevenu: isRevenu, icon: getIconForCategory(category)));
    }
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case "Salaire":
        return Icons.attach_money;
      case "Autres revenus":
        return Icons.card_giftcard;
      case "Logement":
        return Icons.home;
      case "Alimentation":
        return Icons.fastfood;
      case "Transport":
        return Icons.directions_car;
      case "Esthétique":
        return Icons.brush;
      case "Abonnements":
        return Icons.subscriptions;
      case "Loisirs":
        return Icons.sports_esports;
      default:
        return Icons.category; // Icône générique par défaut
    }
  }

}