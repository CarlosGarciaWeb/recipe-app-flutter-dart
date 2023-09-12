class Ingredient {
  final String name;
  final String quantity;
  final String unit;

  Ingredient({required this.name, required this.quantity, required this.unit});
}

class RecipeStep {
  final String name;
  final String duration;
  final String unit;

  RecipeStep({required this.name, required this.duration, required this.unit});
}

class Recipe {
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
  });
}

List<Recipe> sampleRecipes = []; //Empty list to add recipes dynamically

