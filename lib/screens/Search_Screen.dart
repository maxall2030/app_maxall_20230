// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:app_maxall2/constants/colors.dart';
import 'package:app_maxall2/model/products_data.dart';
import 'package:app_maxall2/components/product_card.dart';
import 'package:app_maxall2/services/api_link.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _results = [];
  List<Map<String, dynamic>> _searchHistory = [];
  bool _loading = false;
  int? userId;

  bool showAllHistory = false;
  bool sortDescending = true;

  @override
  void initState() {
    super.initState();
    _loadUserAndHistory();
  }

  Future<void> _loadUserAndHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("user_id");

    if (userId != null) {
      final List<String> raw = prefs.getStringList('search_history_user_$userId') ?? [];
      _searchHistory = raw.map<Map<String, dynamic>>((e) {
        try {
          return json.decode(e) as Map<String, dynamic>;
        } catch (_) {
          return {};
        }
      }).where((map) => map.isNotEmpty).toList();

      _sortHistory();
      setState(() {});
    }
  }

  void _sortHistory() {
    _searchHistory.sort((a, b) {
      DateTime timeA = DateTime.tryParse(a['time'] ?? '') ?? DateTime.now();
      DateTime timeB = DateTime.tryParse(b['time'] ?? '') ?? DateTime.now();
      return sortDescending ? timeB.compareTo(timeA) : timeA.compareTo(timeB);
    });
  }

  Future<void> _saveSearchHistory() async {
    if (userId == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encoded = _searchHistory.map((e) => json.encode(e)).toList();
    await prefs.setStringList('search_history_user_$userId', encoded);
  }

  void _clearSearchHistory() async {
    if (userId == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _searchHistory.clear());
    await prefs.remove('search_history_user_$userId');
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty || userId == null) return;

    final exists = _searchHistory.indexWhere((e) => e['keyword'] == query);
    if (exists != -1) {
      _searchHistory.removeAt(exists);
    }

    _searchHistory.insert(0, {
      'keyword': query,
      'time': DateTime.now().toIso8601String(),
    });

    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    await _saveSearchHistory();
    _sortHistory();

    setState(() {
      _loading = true;
      _results.clear();
    });

    try {
      final response = await http.get(Uri.parse('$linkSearch$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = data.map<Product>((item) => Product.fromJson(item)).toList();
        setState(() {
          _results = products;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  String _formatTime(String iso) {
    final dateTime = DateTime.tryParse(iso);
    if (dateTime == null) return '';
    return DateFormat('yyyy/MM/dd - HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("بحث المنتجات"),
        backgroundColor: AppColors.primary,
        actions: [
          if (_searchHistory.isNotEmpty && showAllHistory)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: "مسح الكل",
              onPressed: _clearSearchHistory,
            ),
          if (_searchHistory.isNotEmpty)
            IconButton(
              icon: Icon(sortDescending ? Icons.arrow_downward : Icons.arrow_upward),
              tooltip: sortDescending ? "الأحدث أولًا" : "الأقدم أولًا",
              onPressed: () {
                setState(() {
                  sortDescending = !sortDescending;
                  _sortHistory();
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),

          // عنوان سجل البحث + أزرار
          if (_searchHistory.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "سجل البحث",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Row(
                    children: [
                      if (showAllHistory)
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: _clearSearchHistory,
                        ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showAllHistory = !showAllHistory;
                          });
                        },
                        child: Text(
                          showAllHistory ? "إخفاء" : "عرض الكل",
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // عرض عناصر السجل
          if (_searchHistory.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: showAllHistory ? _searchHistory.length : (_searchHistory.length >= 3 ? 3 : _searchHistory.length),
              itemBuilder: (context, index) {
                final item = _searchHistory[index];
                return ListTile(
                  title: Text(item['keyword']),
                  subtitle: Text(_formatTime(item['time'])),
                  leading: const Icon(Icons.history),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _searchHistory.removeAt(index);
                      });
                      _saveSearchHistory();
                    },
                  ),
                  onTap: () {
                    _searchController.text = item['keyword'];
                    _search(item['keyword']);
                  },
                );
              },
            ),

          // عرض النتائج
          _loading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: _results.isEmpty
                      ? const Center(child: Text("لا توجد نتائج"))
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final product = _results[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                              child: ProductCard(product: product),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
