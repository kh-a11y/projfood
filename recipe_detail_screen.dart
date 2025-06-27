import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'recipe.dart';
import 'db.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe recipe;
  String? selectedText;

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
  }

  Future<void> _openYoutube() async {
    final Uri url = Uri.parse(recipe.url.trim());
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ الرابط غير صالح للمشاهدة')),
      );
    }
  }

  void toggleFavorite() async {
    final newValue = !recipe.isFavorite;

    setState(() {
      recipe.isFavorite = newValue;
    });

    try {
      if (newValue) {
        final insertedId = await DBHelper.insertFavorite(recipe);
        if (recipe.id == null) {
          setState(() {
            recipe = Recipe(
              id: insertedId,
              name: recipe.name,
              description: recipe.description,
              image: recipe.image,
              url: recipe.url,
              isFavorite: recipe.isFavorite,
            );
          });
        }
      } else {
        if (recipe.id != null) {
          await DBHelper.deleteFavorite(recipe.id!);
        } else {
          print('⚠️ لا يمكن حذف بدون ID');
        }
      }
    } catch (e) {
      print('❌ خطأ أثناء التعديل على المفضلة: $e');
      setState(() {
        recipe.isFavorite = !newValue;
      });
    }
  }

  Widget buildInteractiveText(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedText = (selectedText == text) ? null : text;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(
              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                recipe.image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            buildInteractiveText(recipe.description),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.red,
                  size: 24,
                ),
                label: const Text('مشاهدة على يوتيوب'),
                onPressed: _openYoutube,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: toggleFavorite,
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                label: Text(
                  recipe.isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      recipe.isFavorite ? Colors.red : Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
