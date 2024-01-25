import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    // required this.onToggleFavorite,
    required this.availableMeals,
  });
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // If we have more than 1 animation controller then instead of using
  // SingleTickerProviderStateMixin we will use TickerProviderStateMixin
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 300),
      lowerBound: 0,
      upperBound: 1,
      // lowerbound 0 and upperbound 1 are the default values
      // so it is not necessary to set them
    );
    _animationController.forward();   // starting the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // final void Function(Meal meal) onToggleFavorite;
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          // onToggleFavorite: onToggleFavorite,
        ),
      ),
    );

    // Alternate method
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (ctx) => const MealsScreen(
    //       title: "Hello",
    //       meals: [],
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   appBar: AppBar(
        //     title: const Text("Pick your category"),
        //   ),
        // body:
        AnimatedBuilder(
            animation: _animationController,
            child: GridView(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              children: [
                // availableCategories.map((category) => CategoryGridItem(category: category)).toList(),
                for (final category in availableCategories)
                  CategoryGridItem(
                    category: category,
                    onSelectCategory: () {
                      _selectCategory(context, category);
                    },
                  ),
              ],
              // ),
            ),
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
                child: child,
              );
            });
  }
}
