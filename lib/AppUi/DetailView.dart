import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Controller/MusicController.dart';


class DetailView extends StatelessWidget {
  final MusicController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final currentSong = controller.playlist[controller.currentIndex.value];
        return Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            CachedNetworkImage(
              imageUrl: currentSong.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),

                    child:


                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                        const Text(
                          'Playing',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Hero(
                    tag: 'albumArt',
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(125),
                        boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 20), blurRadius: 32)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(125),
                        child: CachedNetworkImage(
                          imageUrl: currentSong.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    currentSong.title,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),


                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.position.value.toString().split('.').first,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          controller.duration.value.toString().split('.').first,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: controller.position.value.inSeconds.toDouble(),
                    max: controller.duration.value.inSeconds.toDouble(),
                    onChanged: (value) => controller.seekTo(Duration(seconds: value.toInt())),
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            color: controller.isShuffleOn.value ? Colors.blue : Colors.white,
                          ),
                          onPressed: controller.toggleShuffle,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white),
                          onPressed: controller.previous,
                          iconSize: 36,
                        ),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: Icon(
                              controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                              color: Colors.black,
                            ),
                            onPressed: controller.play,
                            iconSize: 42,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                          onPressed: controller.next,
                          iconSize: 36,
                        ),
                        IconButton(
                          icon: Icon(
                            controller.repeatMode.value == 0
                                ? Icons.repeat
                                : controller.repeatMode.value == 1
                                ? Icons.repeat
                                : Icons.repeat_one,
                            color: controller.repeatMode.value == 0 ? Colors.white : Colors.blue,
                          ),
                          onPressed: controller.toggleRepeat,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
