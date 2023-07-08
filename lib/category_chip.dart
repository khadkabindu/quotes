import 'package:flutter/material.dart';
import 'package:quotes/database.dart';

class CategoryChip extends StatefulWidget {
  const CategoryChip({Key? key}) : super(key: key);

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6e491),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: databaseHelper.filterCategory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return const Text(" Error occured while loading data");
            } else if (snapshot.hasData) {
              List<String> uniqueCategories = snapshot.data ?? [];

              return GridView.count(
                crossAxisCount: 4,
                children: uniqueCategories.map((category) {
                  return GridTile(
                    child: Container(
                      color: Colors.blue, // Customize the appearance as needed
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
