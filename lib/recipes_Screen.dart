import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_detail_screen.dart';
import 'db.dart';
import 'favorits_screen.dart';
import 'data_recipe.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  late Future<List<Recipe>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = loadRecipes();
  }

  Future<List<Recipe>> loadRecipes() async {
    return recipesList;
  }

  void toggleFavorite(Recipe recipe) async {
    final newValue = !recipe.isFavorite;

    setState(() {
      recipe.isFavorite = newValue;
    });

    try {
      if (newValue) {
        await DBHelper.insertFavorite(recipe);
      } else {
        if (recipe.id != null) {
          await DBHelper.deleteFavorite(recipe.id!);
        } else {
          print('⚠️ المعرف (id) غير موجود، لا يمكن حذف الوصفة من المفضلة');
        }
      }
    } catch (e) {
      print('❌ خطأ أثناء تعديل حالة المفضلة: $e');

      // ترجيع الحالة السابقة في حال فشل العملية
      setState(() {
        recipe.isFavorite = !newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text(
          'وصفات الطعام',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'ScheherazadeNew',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFFF7043),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('حدث خطأ أثناء تحميل الوصفات'));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('لا توجد وصفات'));

          final recipes = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: recipes.length,
            itemBuilder: (ctx, i) {
              final recipe = recipes[i];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          recipe.image,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stack) =>
                                  Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF7043),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  recipe.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ScheherazadeNew',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  recipe.isFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () => toggleFavorite(recipe),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF7043),
        child: Icon(Icons.star, color: Colors.amber),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FavoritesScreen()),
          );
          setState(() {});
        },
      ),
    );
  }
}
