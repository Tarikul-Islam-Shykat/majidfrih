// lib/controllers/product_controller.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/feature/home/model/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var nearbyProducts = <Product>[].obs;
  var isLoading = false.obs;
  var favorites = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      // Simulating API call with dummy data
      await Future.delayed(Duration(milliseconds: 800));

      // Loading dummy JSON data
      final List<Product> loadedProducts = dummyProductsData
          .map((productData) => Product.fromJson(productData))
          .toList();

      products.value = loadedProducts;
      nearbyProducts.value =
          loadedProducts.where((p) => p.id % 2 == 0).toList(); // Just for demo
    } catch (e) {
      print('Error while fetching products: $e');
    } finally {
      isLoading(false);
    }
  }

  void toggleFavorite(int id) {
    final index = products.indexWhere((product) => product.id == id);
    if (index != -1) {
      final product = products[index];
      products[index] = product.copyWith(isFavorite: !product.isFavorite);

      if (products[index].isFavorite) {
        favorites.add(products[index]);
      } else {
        favorites.removeWhere((p) => p.id == id);
      }
    }
  }

  List<Map<String, dynamic>> get dummyProductsData => [
        {
          'id': 1,
          'name': 'CBD Oil Drops',
          'price': 21.0,
          'image': ImagePath.product_img_1,
          'description':
              'Scopri il nostro nuovo prodotto CBD! Realizzato con ingredienti naturali, offre un\'esperienza rilassante e benefica. Perfetto per chi cerca un modo per alleviare lo stress e migliorare il benessere generale.',
          'categories': ['Medicine', 'Natural'],
          'isFavorite': false
        },
        {
          'id': 2,
          'name': 'Guitar Pick',
          'price': 50.0,
          'image': ImagePath.product_img_2,
          'description':
              'Premium quality guitar pick made from durable materials. Perfect for professional musicians and beginners alike.',
          'categories': ['Music', 'Accessories'],
          'isFavorite': false
        },
        {
          'id': 3,
          'name': 'CBD Wellness Pack',
          'price': 35.0,
          'image': ImagePath.product_img_1,
          'description':
              'Complete wellness pack featuring our premium CBD formula. Helps reduce anxiety and promotes better sleep.',
          'categories': ['Medicine', 'Natural', 'Wellness'],
          'isFavorite': false
        },
        {
          'id': 4,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_2,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        },
        {
          'id': 5,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_2,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        },
        {
          'id': 6,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_2,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        },
        {
          'id': 7,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_1,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        },
        {
          'id': 8,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_1,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        },
        {
          'id': 9,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_2,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        },
        {
          'id': 10,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_1,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        },
        {
          'id': 11,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_2,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        },
        {
          'id': 12,
          'name': 'Electric Guitar Pick',
          'price': 65.0,
          'image': ImagePath.product_img_1,
          'description':
              'Specially designed pick for electric guitars. Provides superior grip and control for your performances.',
          'categories': ['Music', 'Professional'],
          'isFavorite': false
        }
      ];
}
