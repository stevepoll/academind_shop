import 'dart:math';

import 'package:academind_shop/widgets/order_item_tile.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:academind_shop/providers/orders.dart';

class OrderCard extends StatefulWidget {
  final Order order;

  OrderCard(this.order);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    var _height = min(widget.order.cartItems.length * 50.0 + 50, 250);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('MMMM d, yyyy, hh:mm a')
                .format(widget.order.dateTime)),
            trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          // if (_expanded)
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _expanded
                ? min(widget.order.cartItems.length * 50.0 + 50, 250)
                : 0,
            child: ListView(
              children: widget.order.cartItems
                  .map((item) => OrderItemTile(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
