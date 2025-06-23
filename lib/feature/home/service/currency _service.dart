// lib/services/currency_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CurrencyService {
  // Using exchangerate-api.com - free tier allows 1500 requests/month
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';

  static const Map<String, String> countryCurrencyMap = {
    'United States': 'USD',
    'Bangladesh': 'BDT',
    'United Kingdom': 'GBP',
    'France': 'EUR',
    'Germany': 'EUR',
    'Japan': 'JPY',
    'Canada': 'CAD',
    'Australia': 'AUD',
    'India': 'INR',
    'China': 'CNY',
    'Brazil': 'BRL',
    'Russia': 'RUB',
    'South Korea': 'KRW',
    'Mexico': 'MXN',
    'Turkey': 'TRY',
    'Saudi Arabia': 'SAR',
    'United Arab Emirates': 'AED',
    'Switzerland': 'CHF',
    'Norway': 'NOK',
    'Sweden': 'SEK',
  };
  // Fallback exchange rates (in case API fails)
  static const Map<String, double> fallbackRates = {
    'USD': 1.0,
    'BDT': 110.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'CAD': 1.25,
    'AUD': 1.35,
    'JPY': 110.0,
    'INR': 75.0,
    'CHF': 0.92,
    'CNY': 6.45,
    'BRL': 5.20,
    'RUB': 75.0,
    'KRW': 1200.0,
    'MXN': 20.0,
    'TRY': 8.50,
    'SAR': 3.75,
    'AED': 3.67,
    'NOK': 8.50,
    'SEK': 9.20,
  };

  static Future<Map<String, double>> getExchangeRates({
    String baseCurrency = 'USD',
  }) async {
    try {
      // Method 1: exchangerate-api.com (most reliable free option)
      final url = '$_baseUrl/$baseCurrency';

      debugPrint('Fetching exchange rates from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Flutter App',
        },
      ).timeout(const Duration(seconds: 10));

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['rates'] != null) {
          Map<String, double> rates = {};
          final ratesData = data['rates'] as Map<String, dynamic>;

          // Convert all rates to double
          ratesData.forEach((key, value) {
            rates[key] = (value is int) ? value.toDouble() : value.toDouble();
          });

          debugPrint('Successfully fetched ${rates.length} exchange rates');
          return rates;
        }
      }

      // If primary API fails, try backup method
      return await _getBackupExchangeRates();
    } catch (e) {
      debugPrint('Error fetching exchange rates: $e');
      return await _getBackupExchangeRates();
    }
  }

  // Backup method using different API
  static Future<Map<String, double>> _getBackupExchangeRates() async {
    try {
      // Using exchangerate.host as backup
      const backupUrl = 'https://api.exchangerate.host/latest?base=USD';

      final response = await http
          .get(Uri.parse(backupUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['rates'] != null) {
          Map<String, double> rates = {};
          final ratesData = data['rates'] as Map<String, dynamic>;

          ratesData.forEach((key, value) {
            rates[key] = (value is int) ? value.toDouble() : value.toDouble();
          });

          debugPrint('Backup API returned ${rates.length} rates');
          return rates;
        }
      }

      // If all APIs fail, return fallback rates
      debugPrint('Using fallback exchange rates');
      return Map<String, double>.from(fallbackRates);
    } catch (e) {
      debugPrint('Backup API also failed: $e, using fallback rates');
      return Map<String, double>.from(fallbackRates);
    }
  }

  static double convertPrice(double originalPrice, String fromCurrency,
      String toCurrency, Map<String, double> rates) {
    if (fromCurrency == toCurrency) return originalPrice;

    debugPrint('Converting $originalPrice from $fromCurrency to $toCurrency');
    debugPrint('Available rates: ${rates.keys.toList()}');

    // Convert to USD first if needed
    double priceInUsd = originalPrice;
    if (fromCurrency != 'USD') {
      final rate = rates[fromCurrency];
      if (rate != null && rate > 0) {
        priceInUsd = originalPrice / rate;
      } else {
        debugPrint('Warning: No exchange rate found for $fromCurrency');
        return originalPrice;
      }
    }

    // Convert to target currency
    if (toCurrency == 'USD') {
      return priceInUsd;
    }

    final targetRate = rates[toCurrency];
    if (targetRate != null) {
      final convertedPrice = priceInUsd * targetRate;
      debugPrint('Converted price: $convertedPrice $toCurrency');
      return convertedPrice;
    }

    debugPrint('Warning: No exchange rate found for $toCurrency');
    return originalPrice; // Fallback to original price
  }

  static String formatCurrency(double amount, String currencyCode) {
    final currencySymbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'BDT': '৳',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'JPY': '¥',
      'INR': '₹',
      'CHF': 'CHF ',
      'CNY': '¥',
      'BRL': 'R\$',
      'RUB': '₽',
      'KRW': '₩',
      'MXN': '\$',
      'TRY': '₺',
      'SAR': 'SR',
      'AED': 'د.إ',
      'NOK': 'kr',
      'SEK': 'kr',
    };

    final symbol = currencySymbols[currencyCode] ?? '$currencyCode ';

    // Format based on currency (some currencies don't use decimals)
    if ([
      'JPY',
      'KRW',
      'BIF',
      'CLP',
      'DJF',
      'GNF',
      'ISK',
      'KMF',
      'KRW',
      'PYG',
      'RWF',
      'UGX',
      'VND',
      'VUV',
      'XAF',
      'XOF',
      'XPF'
    ].contains(currencyCode)) {
      return '$symbol${amount.toStringAsFixed(0)}';
    }

    return '$symbol${amount.toStringAsFixed(2)}';
  }

  // Test method to verify API is working
  static Future<bool> testConnection() async {
    try {
      final rates = await getExchangeRates();
      return rates.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
