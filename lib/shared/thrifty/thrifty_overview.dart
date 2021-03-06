import 'package:bethriftytoday/config/config.dart';
import 'package:bethriftytoday/models/models.dart';
import 'package:bethriftytoday/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ThriftyOverview extends StatelessWidget {
  const ThriftyOverview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var balance = Provider.of<double>(context);
    var expenses = Provider.of<List<Transaction>>(context);

    if (user != null && balance != null && expenses != null) {
      return InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => UpdateBudgetDialog(
              initialValue: user.budget,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(25),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'YOUR BALANCE',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    (balance != null)
                        ? Text(
                            formatAmount(user, balance),
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        : Container(),
                    SizedBox(height: 8),
                    (user.budget != null)
                        ? Text(
                            'You have spent ${user.currency.symbol} ${calculateAbsoluteSum(expenses).toStringAsFixed(2)} of your total budget of ${user.currency.symbol} ${user.budget.toStringAsFixed(2)} in the month of ${DateFormat('MMMM y').format(DateTime.now())}.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            'Tap here to set a monthly budget and manage your expenses efficiently.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(width: 60),
              (user.budget != null)
                  ? buildBudgetMeter(context, expenses, user)
                  : Icon(Icons.category, size: 60, color: Colors.white),
            ],
          ),
        ),
      );
    }

    return Container();
  }

  CircleAvatar buildBudgetMeter(
    BuildContext context,
    List<Transaction> expenses,
    User user,
  ) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: (35 - 6).toDouble(),
        backgroundColor: Theme.of(context).accentColor,
        child: Text(
          ((calculateAbsoluteSum(expenses) / user.budget) * 100)
                  .toStringAsFixed(0) +
              '%',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
