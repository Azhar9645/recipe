import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:recipe_app1/screens/Hive/data_model.dart';

import 'package:recipe_app1/screens/adminscreen/adminaddrecipe.dart';
import 'package:recipe_app1/screens/adminscreen/adminprofile.dart';
import 'package:recipe_app1/screens/adminscreen/categoryadd.dart';
import 'package:recipe_app1/screens/splash.dart';
import 'package:recipe_app1/screens/userscreen/addrecipe.dart';
import 'package:recipe_app1/screens/userscreen/cart.dart';
import 'package:recipe_app1/screens/userscreen/home.dart';
import 'package:recipe_app1/screens/userscreen/profile.dart';
import 'package:recipe_app1/screens/userscreen/wishlist.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
   final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);


  Hive.registerAdapter(UserRecipeAdapter());
    await Hive.openBox<UserRecipe>('recipe_db');

  Hive.registerAdapter(FavRecipeAdapter());
  

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Rover',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      routes: {
        '/': (context) => Splash(),
        '/home': (context) => Home(),
        '/wishlist': (context) => Wishlist(),
        '/addrecipe': (context) => AddRecipe(),
        '/cart': (context) => Cart(),
        '/profile': (context) => Profile(),
        '/CategoryAdd': (context) => CategoryAdd(),
        '/AdminProfile': (context) => AdminProfile(),
        '/AdminRecipeAdd': (context) => AdminRecipeAdd()
      },
    );
  }
}
