import 'package:cashmate/home.dart';
import 'package:cashmate/main.dart';
import 'package:flutter/material.dart';

class BudgetCreation extends StatefulWidget {
  const BudgetCreation({super.key});

  @override
  State<StatefulWidget> createState() => _BudgetCreationState();
}


class _BudgetCreationState extends State<BudgetCreation> {

  final List<String> categories = ["Salaire", "Autres revenus","Logement", "Alimentation", "Transport", "Esthétique", "Abonnements", "Loisirs", "Recap"];
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> transactions = [];
  double totalRevenus =  0;
  double totalDepenses = 0;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color.fromRGBO(59, 15, 82, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(59, 15, 82, 1.0),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_currentPage + 1) / categories.length),
          Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryPage(categories[index], totalRevenus, totalDepenses);
                  }
              )
          ),
          Text("Dépenses totales : $totalDepenses", style: const TextStyle(color: Colors.white, fontSize: 14),),
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
      return _buildRecapPage(totalRevenus); // Affiche la page de résumé
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category, style: TextStyle(color: Colors.white, fontSize: 18),),
          SizedBox(
            width: 200,
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
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
        Text("Total des dépenses : $totalDepenses", style: TextStyle(color: Colors.white, fontSize: 20),),
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

  void _updateTransaction(String category, double amount, bool isRevenue) {
    // Vérifier si la catégorie existe déjà
    final existingIndex = transactions.indexWhere((t) => t['category'] == category);

    if (existingIndex != -1) {
      // Mise à jour de la valeur existante
      transactions[existingIndex]['amount'] = amount;
    } else {
      if(isRevenue==false){
        totalDepenses += amount;
      } else {
        totalRevenus += amount;
      }
      // Ajout d'une nouvelle transaction
      transactions.add({'category': category, 'amount': amount, 'isRevenue': isRevenue});
    }
  }
  

}