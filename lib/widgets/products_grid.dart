import 'package:academind_shop/providers/products.dart';
import 'package:flutter/material.dart';

import 'package:academind_shop/widgets/product_tile.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavorites;

  ProductsGrid(this._showFavorites);

  @override
  Widget build(BuildContext context) {
    final pData = Provider.of<Products>(context);
    final products = _showFavorites ? pData.favoriteItems : pData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductTile(),
      ),
      itemCount: products.length,
    );
  }
}
