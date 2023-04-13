import 'package:flutter/material.dart';

import 'models/user.dart';

class Home extends StatefulWidget {
  final Function() notifyParent;
  final User selectedUser;
  const Home(this.selectedUser, this.notifyParent, {Key? key})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.selectedUser.bank().getBalances(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Text('${snapshot.data[index].balance}');
                    }));
          }
        });
  }
  /*return Center(
      child: Column(
        children: [
          
          SizedBox(
            child: Column(children: [
              Text("Welcome, ${widget.selectedUser.name}"),
              Text("You're in, ${widget.selectedUser.location}"),
              ElevatedButton(
                onPressed: () async {
                  final bank = widget.selectedUser.bank();
                  await bank.askForLoan(Loan(
                      userId: 0,
                      amount: 50000,
                      interest: 0.1,
                      due: DateTime.now().add(const Duration(days: 30))));

                  widget.notifyParent();
                },
                child: const Text('Ask for loan...'),
              ),
              ElevatedButton(
                child: const Text("Buy tickets to..."),
                onPressed: () async {
                  _showModal(context);
                },
              ),
            ]),
          ),*/
  /*FutureBuilder(
              future: widget.selectedUser.bank().getBalances(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            "${snapshot.data![index].balance.toStringAsFixed(2)} ${snapshot.data![index].concept}"),
                      );
                    },
                  ));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }*/

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Column(children: <Widget>[
          TextField(
            controller: destinationController,
            decoration: const InputDecoration(
              hintText: 'Enter your ICAO destination',
            ),
          ),
          ElevatedButton(
              child: const Text("Buy tickets to..."),
              onPressed: () {
                final trasport = widget.selectedUser.transport();
                trasport.buyTicket(destinationController.text).then((value) {
                  Navigator.pop(context);
                  widget.notifyParent();
                });
              }),
        ]);
      },
    );
  }
}
