import 'package:cashmate/budget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.transactions});
  final List<Map<String, dynamic>> transactions; // Ajoute cette ligne


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
      if (transaction["isRevenue"] == true) {
        return sum + transaction["amount"];
      } else {
        return sum;
      }
    });

    double totalAmountDepenses = widget.transactions.fold(0.0, (sum, transaction) {
      if (transaction["isRevenue"] == false) {
        return sum + transaction["amount"];
      } else {
        return sum;
      }
    });

    double difference = totalAmountRevenus - totalAmountDepenses;

    if(totalAmountRevenus > totalAmountDepenses) {
      symbolColor = Colors.green;
    } else if (totalAmountRevenus < totalAmountDepenses) {
      symbolColor = Colors.red;
    } else {
      symbolColor  = Colors.white;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      backgroundColor: const Color.fromRGBO(59, 15, 82, 1.0),
      body: Stack(
          children: [
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Cash Mate", style: TextStyle(color: Colors.white, fontSize: 28),),
                    SizedBox(
                        height: 250, // Définir une hauteur pour le PieChart
                        child: Stack(
                          children: [
                            PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    color: Theme.of(context).primaryColor,
                                    value: totalAmountRevenus,
                                    title: '$totalAmountRevenus',
                                    radius: 50,
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    color: Theme.of(context).primaryColorDark,
                                    value: totalAmountDepenses,
                                    title: '$totalAmountDepenses',
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                                centerSpaceRadius: 80,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(onPressed: () {
                          _showAddTransactionDialog(context, true);
                        },
                          child: const Text(
                              "Ajouter mes revenus"
                          ),
                        ),
                        FilledButton(onPressed: () {
                          _showAddTransactionDialog(context, false);
                        },
                          child: const Text(
                              "Ajouter mes dépenses"
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const BudgetCreation()));
                        },
                        child: Text("Créer mon budget")),
                    const Text("Estime rapidement ta capacité d'épargne mensuelle !", style: TextStyle(color: Colors.white),)
                  ],
                )
            ),
          ]
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, bool isRevenue) {
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une opération"),
          backgroundColor: Theme.of(context).primaryColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Montant",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Libellé",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                if (descriptionController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  setState(() {
                    widget.transactions.add({
                      "amount": double.parse(amountController.text),
                      "description": descriptionController.text,
                      "isRevenue": isRevenue,
                    });
                  });
                }
                Navigator.pop(context); // Ferme la boîte
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

}