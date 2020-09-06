import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:academind_shop/pages/cart_page.dart';
import 'package:academind_shop/providers/cart.dart';
import 'package:academind_shop/widgets/app_drawer.dart';
import 'package:academind_shop/widgets/badge.dart';
import 'package:academind_shop/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  @override
  _ProductsOverviewPageState createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  var _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.Favorites),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartPage.routeName);
              },
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showFavorites),
      drawer: AppDrawer(),
    );
  }
}
