import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  ShimmerGrid({required this.itemCount, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.9,
          ),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius:
                    BorderRadius.circular(15.0), // Adjust the radius as needed
              ),
            );
          },
        ),
      ),
    );
  }
}
