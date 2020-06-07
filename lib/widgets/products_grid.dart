import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavsOnly;

  ProductsGrid(this.showFavsOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavsOnly ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            //create: (c) => products[index],
            value: products[i],
          ),
        ],
        child: ProductItem(
          products[i].id,
          products[i].title,
          products[i].price,
          products[i].imageUrl,
        ),
      ),
    );
  }
}
