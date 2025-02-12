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

    List<PieChartSectionData> pieChartSections = widget.transactions.where((transaction) => transaction.isRevenu==false).map((transaction) => buildSectionPieChart(transaction))
        .toList();

    double difference = totalAmountRevenus - totalAmountDepenses;

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
                    const Text("Cash Mate", style: TextStyle(fontSize: 28),),
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
                                "$difference", style: TextStyle(fontSize: 30, color: symbolColor, fontWeight: FontWeight.bold),
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

  PieChartSectionData buildSectionPieChart(Transaction transaction){
    return
      PieChartSectionData(
      color: Theme.of(context).primaryColor,
      value: transaction.amount,
      title: transaction.amount.toString(),
      radius: 50,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColorLight,
      ),
    );
  }


}