import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperController extends GetxController {
  var isLoading = false.obs;

  // Selected wallpaper index
  var selectedIndex = (-1).obs;

  final List<String> wallpapers = [
    'https://images.unsplash.com/photo-1540206395-68808572332f?w=800&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1527515234283-d93c5f8486a0?w=800&auto=format&fit=crop&q=60',
    'https://images.unsplash.com/photo-1504681869696-d977211a5f4c?w=800&auto=format&fit=crop&q=60',
    'https://tse4.mm.bing.net/th/id/OIP.9DKymb8P00v_dwBdUg6zpgHaNK?rs=1&pid=ImgDetMain&o=7&rm=3',
    'https://i.pinimg.com/originals/bd/35/ca/bd35caa1d66da3a15ed952b4ac1010f7.jpg',
    "https://images.pexels.com/photos/355465/pexels-photo-355465.jpeg",
    "https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg",
    "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg",
    "https://images.pexels.com/photos/302743/pexels-photo-302743.jpeg",
    "https://images.pexels.com/photos/356378/pexels-photo-356378.jpeg",

    "https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg",
    "https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg",
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",

    "https://cdn.pixabay.com/photo/2014/04/14/20/11/japanese-cherry-trees-324175_1280.jpg",

    "https://images.pexels.com/photos/34950/pexels-photo.jpg",
    "https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg",
    "https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=450",
    "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=450",
    "https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=450",
    "https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=450",
  ];

  final WallpaperManagerFlutter _wallpaperManager = WallpaperManagerFlutter();

  /// Set wallpaper at selected index
  Future<void> setWallpaper(int index, int location) async {
    isLoading.value = true;
    try {
      File file = await DefaultCacheManager().getSingleFile(wallpapers[index]);
      bool success = await _wallpaperManager.setWallpaper(file, location);

      Get.snackbar(
        success ? 'Success' : 'Failed',
        success ? 'Wallpaper set successfully!' : 'Failed to set wallpaper',
        backgroundColor: success ? Colors.green : Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a wallpaper (for showing border/highlight)
  void selectWallpaper(int index) {
    selectedIndex.value = index;
  }
}
