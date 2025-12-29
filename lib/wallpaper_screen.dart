import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpapers/custom_button.dart';
import 'package:wallpapers/custom_text.dart';
import 'package:wallpapers/wallpaper_controller.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperScreen extends StatelessWidget {
  const WallpaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WallpaperController controller = Get.put(WallpaperController());

    void showBottomSheet(int index) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const CustomText(
                color: Colors.black,
                text: 'Set Wallpaper',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              const CustomText(
                text: 'Choose where to set the wallpaper',
                color: Colors.black,

                fontSize: 16,
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Get.back();
                            controller.setWallpaper(
                              index,
                              WallpaperManagerFlutter.homeScreen,
                            );
                          },
                          text: "Home",
                          icon: Icon(Icons.home, color: Colors.white),
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: (15)),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Get.back();
                            controller.setWallpaper(
                              index,
                              WallpaperManagerFlutter.lockScreen,
                            );
                          },

                          text: "Lock",
                          icon: Icon(Icons.lock, color: Colors.white),
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Get.back();
                            controller.setWallpaper(
                              index,
                              WallpaperManagerFlutter.bothScreens,
                            );
                          },
                          text: "Both",
                          textColor: Colors.white,
                          icon: Icon(Icons.phone_android, color: Colors.white),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      SizedBox(width: (15)),
                      Expanded(
                        child: CustomButton(
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            Get.back();
                            Get.to(
                              () => WallpaperPreviewScreen(
                                imageUrl: controller.wallpapers[index],
                              ),
                            );
                          },
                          textColor: Colors.white,
                          text: "Preview",
                          icon: Icon(Icons.visibility, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: CustomText(text: 'Set Your Wallpaper'),
        centerTitle: true,
      ),
      body: Obx(() {
        return Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.wallpapers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                // Wrap only the container that needs to react
                return Obx(() {
                  bool isSelected = controller.selectedIndex.value == index;
                  return GestureDetector(
                    onTap: () {
                      controller.selectWallpaper(index);
                      showBottomSheet(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? Border.all(color: Colors.blueAccent, width: 4)
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: controller.wallpapers[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.cyan,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      }),
    );
  }
}

/// Full screen preview
class WallpaperPreviewScreen extends StatelessWidget {
  final String imageUrl;
  const WallpaperPreviewScreen({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(text: 'Preview Image'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
        ),
      ),
    );
  }
}
