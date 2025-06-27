import 'recipe.dart';

final List<Recipe> recipesList = [
  Recipe(
    id: 1,
    name: 'كبسة الدجاج',
    image: 'images/kp.jpg.',
    description:
        'المكونات: دجاجة مقطعة، 2 كوب أرز بسمتي، بصلة، طماطم، بهارات كبسة. الطريقة: يُحمر البصل ثم يُضاف الدجاج ويُقلب حتى يتحمر. تُضاف الطماطم ومعجونها والبهارات وتُغطى بالماء وتُطهى حتى ينضج الدجاج. يُضاف الأرز ويُطهى حتى النضج.',
    isFavorite: false,
    url: 'https://www.youtube.com/watch?v=pWWANTxS6qU.',
  ),
  Recipe(
    id: 2,
    name: 'المقلوبة',
    image: 'images/mg.jpg',
    description:
        'المكونات: لحم أو دجاج، أرز بسمتي، باذنجان، بطاطس، زهرة. الطريقة: تُقلى الخضار وتُرتب في القدر، يُوضع اللحم أو الدجاج فوقها، ثم الأرز والمرق. تُطهى على نار هادئة ثم تُقلب في طبق التقديم.',
    isFavorite: false,
    url: 'https://www.youtube.com/watch?v=cVUaevjYRj4.',
  ),
  Recipe(
    id: 3,
    name: 'الشاورما',
    image: 'images/sht.png',
    description:
        'المكونات: صدور دجاج مقطعة، لبن، خل، عصير ليمون، ثوم، بهارات شاورما. الطريقة: يُتبل الدجاج ويُترك لساعات، ثم يُطهى في مقلاة حتى يتحمر. يُقدم في خبز عربي مع صوص الثوم والسلطة.',
    isFavorite: false,
    url: 'https://www.youtube.com/shorts/dUI3NDBRmBU.',
  ),
];
