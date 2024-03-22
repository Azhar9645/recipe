import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

class RecipeSearchResultItem extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const RecipeSearchResultItem({Key? key, required this.recipeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeName = recipeData['name'] ?? 'Unknown';
    final time = recipeData['time'] ?? 'N/A';
    final base64Image = recipeData['image'] ?? ''; 

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: base64Image.isNotEmpty
                  ? Image.memory(
                      base64Decode(base64Image),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.image,
                      size: 50,
                      color: Color(0xFFC1C1C1),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  recipeName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 18),
                Text(
                  'Time: $time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}