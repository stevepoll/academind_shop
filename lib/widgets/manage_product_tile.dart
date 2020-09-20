import 'package:academind_shop/pages/edit_product_page.dart';
import 'package:academind_shop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageProductTile extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ManageProductTile(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            // Edit
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductPage.routeName,
                  arguments: id,
                );
              },
            ),
            // Delete
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () async {
                try {
                  await products.deleteProduct(id);
                } catch (e) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text('Delete failed', textAlign: TextAlign.center),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
