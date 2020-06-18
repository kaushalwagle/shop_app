import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final double price;
  final String title;

  ProductItem(
    this.id,
    this.title,
    this.price,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    final authData = Provider.of<Auth>(
      context,
      listen: false,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: id,
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: GridTileBar(
          leading: Chip(
            label: Text(
              '\$$price',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () async{
                try{
                  product.toggleFavouriteStatus(authData.token, authData.userId);
                }catch(error){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(error)));
                }
              },
            ),
            child: Text('Never Changes'),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(id, price, title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Added item to Cart!',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleQuantity(id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
