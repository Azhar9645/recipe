import 'dart:convert';
import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  final Map<String, dynamic> recipeData;
  final VoidCallback onTap;

  RecipeItem({required this.recipeData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String recipeName = recipeData['name'] as String? ?? 'Unnamed Recipe';
    String time = recipeData['time'] as String? ?? 'N/A';
    String? base64Image = recipeData['photo'] as String?;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFFF1F1F1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                  child: base64Image != null && base64Image.isNotEmpty
                      ? Image.memory(
                          base64Decode(base64Image),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
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
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Time: $time',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
