// import 'package:big_cart/views/products/categories.dart';
import 'package:flutter/material.dart';

import '../screens/search_results.dart';
import 'list_data.dart';
// import '../../viewmodels/home_viewmodel.dart';

class CategoryContainers extends StatelessWidget {
  const CategoryContainers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            ...[const SizedBox(width: 10)],
            ...List.generate(
              categories.length,
              (index) => GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchResults(category: categories[index]['title']);
                  }));
                },
                child: SizedBox(
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        margin: const EdgeInsets.only(
                          left: 10,
                          top: 17,
                          bottom: 29,
                          right: 10,
                        ),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child:
                            Icon(categories[index]['icon'] ?? Icons.category),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Text(
                          categories[index]['title'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...[const SizedBox(width: 10)],
          ],
        ),
      ),
    );
  }
}
