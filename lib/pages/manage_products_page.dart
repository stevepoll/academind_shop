import 'package:academind_shop/pages/edit_product_page.dart';
import 'package:academind_shop/widgets/manage_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:academind_shop/providers/products.dart';

import '../widgets/app_drawer.dart';

class ManageProductsPage extends StatelessWidget {
  static const routeName = '/user_products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, prodData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) {
                            final item = prodData.items[i];
                            return Column(
                              children: [
                                ManageProductTile(
                                  item.id,
                                  item.title,
                                  item.imageUrl,
                                ),
                                Divider(),
                              ],
                            );
                          },
                          itemCount: prodData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
