import 'package:cashmate/home.dart';
import 'package:cashmate/model/Transaction.dart';
import 'package:flutter/material.dart';

class Operations extends StatefulWidget {
  const Operations({super.key, required this.transactions});
  final List<Transaction> transactions; // Ajoute cette ligne

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
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: widget.transactions.isEmpty
                  ? const Center(
                child: Text(
                  "Aucune transaction enregistrée",
                  style: TextStyle(fontSize: 18),
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
                            transaction.description,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "${transaction.amount} €",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: transaction.isRevenu
                                  ? Color.fromRGBO(102, 187, 106, 1)

                              : Color.fromRGBO(239, 83, 80, 1),
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