import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_mobile/helper/request_with_retry.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';

class GetAllProduct with AccessTokenProvider {
  final bool status;
  final String message;
  final List<Product> data;
  static const String cacheKey = 'all_products_cache';

  GetAllProduct({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllProduct.fromJson(Map<String, dynamic> object) {
    List<Product> products = [];

    if (object['data'] != null) {
      for (var productData in object['data']) {
        List<CategoryProduct> categories = [];

        if (productData['category'] != null) {
          categories = (productData['category'] as List)
              .map((categoryData) => CategoryProduct(
                    id: categoryData['id'],
                    uuid: categoryData['uuid'],
                    name: categoryData['name'],
                    createdAt: categoryData['created_at'],
                    updatedAt: categoryData['updated_at'],
                  ))
              .toList();
        }

        products.add(Product(
          id: productData['id'],
          link: productData['link'],
          uuid: productData['uuid'],
          name: productData['name'],
          barcode: productData['barcode'],
          stock: productData['stock'],
          price: double.tryParse(productData['selling_price'] ?? '0') ?? 0,
          purchasePrice:
              double.tryParse(productData['purchase_price'] ?? '0') ?? 0,
          image: productData['image'],
          createdAt: DateTime.tryParse(productData['created_at'] ?? '') ??
              DateTime.now(),
          updatedAt: DateTime.tryParse(productData['updated_at'] ?? '') ??
              DateTime.now(),
          category: categories,
        ));
      }
    }

    return GetAllProduct(
      status: object['status'] ?? false,
      message: object['message'] ?? '',
      data: products,
    );
  }

  static Future<GetAllProduct> getAllProduct() async {
    try {
      final domain = dotenv.env["BASE_URL"];
      if (domain == null) {
        throw Exception("BASE_URL not found in environment variables");
      }

      final token = await AccessTokenProvider.token();
      if (token == null) {
        throw Exception("Failed to retrieve access token");
      }

      // Try to get data from API first
      debugPrint("Fetching data from API");
      final apiData = await _fetchFromAPI(domain, token);

      // If API fetch is successful, update cache and return data
      if (apiData != null) {
        await _updateCache(apiData);
        return apiData;
      }

      // If API fetch fails, try to get data from cache
      debugPrint("API fetch failed, trying cache");
      final cachedData = await _fetchFromCache();

      if (cachedData != null) {
        debugPrint("Returning data from cache");
        return cachedData;
      }

      // If both API and cache fail, return empty data
      debugPrint("Both API and cache failed, returning empty data");
      return GetAllProduct(
          status: false, message: "Failed to fetch data", data: []);
    } catch (e, stacktrace) {
      debugPrint("Error in getAllProduct: $e\n$stacktrace");
      return GetAllProduct(status: false, message: e.toString(), data: []);
    }
  }

  static Future<GetAllProduct?> _fetchFromAPI(
      String domain, String token) async {
    try {
      final response = await requestWithRetry(
        "$domain/api/products/",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      debugPrint("response body: ${response.body}");
      debugPrint("token: $token");

      if (response.statusCode != 200) {
        debugPrint("API request failed with status: ${response.statusCode}");
        return null;
      }

      final body = json.decode(response.body);
      return GetAllProduct.fromJson(body);
    } catch (e) {
      debugPrint("Error fetching from API: $e");
      return null;
    }
  }

  static Future<GetAllProduct?> _fetchFromCache() async {
    try {
      final cacheFile = await DefaultCacheManager().getFileFromCache(cacheKey);
      if (cacheFile != null) {
        final cachedData = await cacheFile.file.readAsString();
        final body = json.decode(cachedData);
        return GetAllProduct.fromJson(body);
      }
    } catch (e) {
      debugPrint("Error fetching from cache: $e");
    }
    return null;
  }

  static Future<void> _updateCache(GetAllProduct data) async {
    try {
      await DefaultCacheManager().putFile(
        cacheKey,
        utf8.encode(json.encode(data.toJson())),
        maxAge: const Duration(hours: 1),
        fileExtension: 'json',
      );
    } catch (e) {
      debugPrint("Error updating cache: $e");
    }
  }

  static Future<bool> isImageAvailable(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error checking image availability: $e");
      return false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((product) => product.toJson()).toList(),
    };
  }

  static Future<void> clearCache() async {
    await DefaultCacheManager().removeFile(cacheKey);
  }
}

// Extend the Product class to include a toJson method
extension ProductJson on Product {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'link': link,
      'uuid': uuid,
      'name': name,
      'barcode': barcode,
      'stock': stock,
      'selling_price': price.toString(),
      'purchase_price': purchasePrice.toString(),
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'category': category?.map((cat) => cat.toJson()).toList(),
    };
  }
}

// Extend the CategoryProduct class to include a toJson method
extension CategoryProductJson on CategoryProduct {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
