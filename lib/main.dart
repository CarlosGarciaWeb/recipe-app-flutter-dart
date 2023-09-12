import 'recipe.dart';
import 'package:flutter/material.dart';

void main() => runApp(RecipeApp());

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: RecipeList(),
    );
  }
}

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes')),
      body: ListView.builder(
        itemCount: sampleRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sampleRecipes[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RecipeDetail(recipe: sampleRecipes[index])),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipe()),
          );
          setState(() {}); // Refresh the list after coming back
        },
      ),
    );
  }
}

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;

  RecipeDetail({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${recipe.description}"),
            SizedBox(height: 16),
            ...recipe.ingredients.map((ingredient) => Text(
                "${ingredient.name} - ${ingredient.quantity} ${ingredient.unit}")),
            SizedBox(height: 16),
            ...recipe.steps
                .map((step) => Text("${step.name} - ${step.duration} ${step.unit}")),
          ],
        ),
      ),
    );
  }
}

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();
  String title = '', description = '';
  List<Ingredient> ingredients = [];
  List<RecipeStep> steps = [];

  // Dynamic form controllers
  List<List<TextEditingController>> ingredientControllers = [];
  List<List<TextEditingController>> stepControllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  description = value;
                },
              ),
              ..._buildIngredientsForm(),
              ElevatedButton(
                onPressed: _addIngredientField,
                child: Text('Add Ingredient'),
              ),
              ..._buildStepsForm(), // Include steps dynamic fields
              ElevatedButton(
                onPressed: _addStepsField,
                child: Text('Add Step'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createRecipe();
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIngredientsForm() {
    List<Widget> ingredientTextFields = [];
    for (int i = 0; i < ingredientControllers.length; i++) {
      ingredientTextFields.add(
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ingredientControllers[i][0],
                decoration: InputDecoration(labelText: 'Ingredient'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: ingredientControllers[i][1],
                decoration: InputDecoration(labelText: 'Qty'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField(
                items: ['g', 'tsp', 'tbs', 'L', 'mL']
                    .map((unit) =>
                        DropdownMenuItem(child: Text(unit), value: unit))
                    .toList(),
                onChanged: (value) {
                  // handle the dropdown's value (optional for this simple example)
                },
                decoration: InputDecoration(labelText: 'Unit'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  ingredientControllers.removeAt(i);
                });
              },
            )
          ],
        ),
      );
    }
    return ingredientTextFields;
  }

  void _addIngredientField() {
    setState(() {
      ingredientControllers.add([
        TextEditingController(), // ingredient name
        TextEditingController(), // quantity
        TextEditingController() // unit (optional based on our example)
      ]);
    });
  }

  List<Widget> _buildStepsForm() {
    List<Widget> stepTextFields = [];
    for (int i = 0; i < stepControllers.length; i++) {
      stepTextFields.add(
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: stepControllers[i][0],
                decoration: InputDecoration(labelText: 'Step'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: stepControllers[i][1],
                decoration: InputDecoration(labelText: 'Duration'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField(
                items: ['hr', 'min']
                    .map((unit) =>
                        DropdownMenuItem(child: Text(unit), value: unit))
                    .toList(),
                onChanged: (value) {
                  // handle the dropdown's value (optional for this simple example)
                },
                decoration: InputDecoration(labelText: 'Unit'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  stepControllers.removeAt(i);
                });
              },
            )
          ],
        ),
      );
    }
    return stepTextFields;
  }

  void _addStepsField() {
    setState(() {
      stepControllers.add([
        TextEditingController(), // ingredient name
        TextEditingController(), // quantity
        TextEditingController() // unit (optional based on our example)
      ]);
    });
  }

  void _createRecipe() {
    List<Ingredient> newIngredients = [];
    for (int i = 0; i < ingredientControllers.length; i++) {
      newIngredients.add(Ingredient(
          name: ingredientControllers[i][0].text,
          quantity: ingredientControllers[i][1].text,
          unit: ingredientControllers[i][2].text));
    }

    List<RecipeStep> newSteps = [];
    for (int i = 0; i < stepControllers.length; i++) {
      newSteps.add(RecipeStep(
          name: stepControllers[i][0].text,
          duration: stepControllers[i][1].text,
          unit: stepControllers[i][2].text));
    }

    setState(() {
      sampleRecipes.add(Recipe(
        title: title,
        description: description,
        ingredients: newIngredients,
        steps: newSteps,
      ));
    });
  }
}

