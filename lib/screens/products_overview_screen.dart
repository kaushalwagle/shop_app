import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import './cart_screen.dart';

enum FilterOptions {
  favourites,
  all,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showFavouritesOnly = false;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Widget _shoppingCartBadge() {
    return Consumer<Cart>(
      builder: (_, cart, child) => Badge(
          position: BadgePosition.topRight(top: 0, right: 3),
          badgeContent: Text(
            cart.itemCount.toString(),
            style: TextStyle(color: Colors.white),
          ),
          child: child),
      child: IconButton(
        icon: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.of(context).pushNamed(CartScreen.routeName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: <Widget>[
          _shoppingCartBadge(),
          PopupMenuButton(
            onSelected: (FilterOptions selectedOption) {
              setState(() {
                if (selectedOption == FilterOptions.favourites) {
                  _showFavouritesOnly = true;
                } else {
                  _showFavouritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavouritesOnly),
    );
  }
}
