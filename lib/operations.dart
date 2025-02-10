import 'package:cashmate/home.dart';
import 'package:flutter/material.dart';

class Operations extends StatefulWidget {
  const Operations({super.key, required this.transactions});
  final List<Map<String, dynamic>> transactions; // Ajoute cette ligne

  @override
  State<StatefulWidget> createState() => _Operations();
}

class _Operations extends State<Operations> {
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
    int index = widget.transactions.length;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: const Color.fromRGBO(59, 15, 82, 1.0),
        ),
        backgroundColor: const Color.fromRGBO(59, 15, 82, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Liste des Transactions",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: widget.transactions.isEmpty
                  ? const Center(
                child: Text(
                  "Aucune transaction enregistrée",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: widget.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = widget.transactions[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            transaction["description"],
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          Text(
                            "${transaction["amount"]} €",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: transaction["isRevenue"]
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          IconButton(onPressed: (){
                            setState(() {
                              widget.transactions.removeAt(index);
                            });
                            }, icon: Icon(Icons.delete))
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                        indent: 40,
                        endIndent: 40,
                        color: Colors.white,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}