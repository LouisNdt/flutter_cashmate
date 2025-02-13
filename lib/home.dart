import 'package:cashmate/budget.dart';
import 'package:cashmate/model/Transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.transactions});
  final List<Transaction> transactions; // Ajoute cette ligne


  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  final _amountController = TextEditingController();
  final _libelleController = TextEditingController();

  List<Widget> operations = [];

  @override
  void dispose() {
    _amountController.dispose();
    _libelleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color symbolColor;
    double totalAmountRevenus = widget.transactions.fold(0.0, (sum, transaction) {
      if (transaction.isRevenu == true) {
        return sum + transaction.amount;
      } else {
        return sum;
      }
    });

    double totalAmountDepenses = widget.transactions.fold(0.0, (sum, transaction) {
      if (transaction.isRevenu == false) {
        return sum + transaction.amount;
      } else {
        return sum;
      }
    });

    List<PieChartSectionData> pieChartSections = widget.transactions
        .where((transaction) => transaction.isRevenu == false)
        .toList()
        .asMap()
        .entries
        .map((entry) => buildSectionPieChart(entry.value, entry.key))
        .toList();

    double difference = double.parse((totalAmountRevenus - totalAmountDepenses).toStringAsFixed(2));
    String differenceTxt = formatAmount(difference);

    if(totalAmountRevenus > totalAmountDepenses) {
      symbolColor = Color.fromRGBO(102, 187, 106, 1);
    } else if (totalAmountRevenus < totalAmountDepenses) {
      symbolColor = Color.fromRGBO(239, 83, 80, 1);
    } else {
      symbolColor  = Colors.white;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: Stack(
          children: [
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Cash Mate", style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColorLight),),
                    SizedBox(
                        height: 250, // Définir une hauteur pour le PieChart
                        child: Stack(
                          children: [
                            PieChart(
                              PieChartData(
                                sections: pieChartSections,
                                centerSpaceRadius: 100,
                                sectionsSpace: 5,
                              ),
                            ),
                            Center(
                              child: Text(
                                "$differenceTxt €", style: TextStyle(fontSize: 30, color: symbolColor, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )

                    ),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const BudgetCreation()));
                        },
                        child: Text("Créer mon budget")),
                    const Text("Estime rapidement ta capacité d'épargne mensuelle !",)
                  ],
                )
            ),
          ]
      ),
    );
  }

  PieChartSectionData buildSectionPieChart(Transaction transaction, int index){
    return
      PieChartSectionData(
      //color: Theme.of(context).primaryColor,
        color: categoryColors[index % categoryColors.length],
        value: transaction.amount,
        badgeWidget: Transform.translate(
          offset: Offset(0, -20), // Décale l'icône vers le haut
          child: Icon(
            transaction.icon,
            size: 24,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        title: formatAmount(transaction.amount),
      radius: 90,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).cardColor,
      ),
    );
  }

  final List<Color> categoryColors = [
    Color(0xFF6A0DAD), // Violet profond
    Color(0xFF7B1FA2), // Violet foncé
    Color(0xFF8E24AA), // Mauve intense
    Color(0xFF9C27B0), // Violet classique
    Color(0xFFAB47BC), // Violet lumineux mais soutenu
    Color(0xFFBA68C8), // Lavande foncé

  ];

  String formatAmount(double amount) {
    return (amount % 1 == 0)
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2).replaceAll('.', ',');
  }

}