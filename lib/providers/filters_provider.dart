import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> choosenFilters) {
    state = choosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    }; // ...(spread operator) spreads all the values of map
    // then we overwrite the value of the filter that is changed
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      // filter is set to gluten free and the meal is not gluten free
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      // filter is set to vegetarian and the meal is not vegetarian
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      // filter is set to vegan and the meal is not vegan
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      // filter is set to lactose free and the meal is not lactose free
      return false;
    }
    //else
    return true;
  }).toList();
});
