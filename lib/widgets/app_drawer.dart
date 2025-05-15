import 'package:flutter/material.dart';

import '../page/favorites_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF032541),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo FlashMovie
                SizedBox(
                  height: 130,
                  child: Image.asset(
                    'assets/images/flashmovie_logo.png', // <-- Assure-toi que le chemin est correct
                    fit: BoxFit.contain,
                  ),
                ),

              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Color(0xFF032541)),
            title: const Text('Favoris'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF032541)),
            title: const Text('Historique'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Color(0xFF032541)),
            title: const Text('Supprimer tous'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF032541)),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}