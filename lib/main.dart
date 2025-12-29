import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:get/get.dart';
import 'package:wallpapers/wallpaper_screen.dart';

void main() {
  runApp(const WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper Grid App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WallpaperScreen(),
    );
  }
}

class WallpaperGridScreen extends StatefulWidget {
  const WallpaperGridScreen({super.key});

  @override
  State<WallpaperGridScreen> createState() => _WallpaperGridScreenState();
}

class _WallpaperGridScreenState extends State<WallpaperGridScreen> {
  final WallpaperManagerFlutter _wallpaperManager = WallpaperManagerFlutter();
  bool _isLoading = false;

  final List<String> _wallpaperAssets = [
    'https://images.unsplash.com/photo-1540206395-68808572332f?w=800&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1527515234283-d93c5f8486a0?w=800&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1504681869696-d977211a5f4c?w=800&auto=format&fit=crop&q=60',
    'https://tse4.mm.bing.net/th/id/OIP.9DKymb8P00v_dwBdUg6zpgHaNK?rs=1&pid=ImgDetMain&o=7&rm=3',
    'https://i.pinimg.com/originals/bd/35/ca/bd35caa1d66da3a15ed952b4ac1010f7.jpg',
  ];

  Future<void> _setWallpaper(int index, int location) async {
    setState(() => _isLoading = true);
    try {
      File file = await DefaultCacheManager().getSingleFile(
        _wallpaperAssets[index],
      );
      bool success = await _wallpaperManager.setWallpaper(file, location);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Wallpaper set successfully!' : 'Failed to set wallpaper',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSetWallpaperDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Wallpaper'),
        content: const Text('Choose where you want to set the wallpaper:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _setWallpaper(index, WallpaperManagerFlutter.homeScreen);
            },
            child: const Text('Home Screen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _setWallpaper(index, WallpaperManagerFlutter.lockScreen);
            },
            child: const Text('Lock Screen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _setWallpaper(index, WallpaperManagerFlutter.bothScreens);
            },
            child: const Text('Both'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper Grid App'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _wallpaperAssets.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showSetWallpaperDialog(index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: _wallpaperAssets[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.cyan),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black38,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
