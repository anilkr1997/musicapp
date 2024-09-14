import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/MusicController.dart';
import 'DetailView.dart';






// class HomePlayerView extends StatelessWidget {
//   final MusicController controller = Get.put(MusicController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         final currentSong = controller.playlist[controller.currentIndex.value];
//         return Stack(
//           fit: StackFit.expand,
//           children: [
//             // Background image
//             CachedNetworkImage(
//               imageUrl: currentSong.imageUrl,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//             // Gradient overlay
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
//                 ),
//               ),
//             ),
//             // Content
//             SafeArea(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Music Player',
//                       style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () => Get.to(() => DetailView()),
//                     child: Hero(
//                       tag: 'albumArt',
//                       child: Container(
//                         width: 250,
//                         height: 250,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(125),
//                           boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 20), blurRadius: 32)],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(125),
//                           child: CachedNetworkImage(
//                             imageUrl: currentSong.imageUrl,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//                             errorWidget: (context, url, error) => const Icon(Icons.error),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   Text(
//                     currentSong.title,
//                     style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Artist Name',
//                     style: TextStyle(color: Colors.white70, fontSize: 18),
//                   ),
//                   const SizedBox(height: 32),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.skip_previous, color: Colors.white),
//                         onPressed: controller.previous,
//                         iconSize: 36,
//                       ),
//                       const SizedBox(width: 16),
//                       Container(
//                         width: 72,
//                         height: 72,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white,
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
//                             color: Colors.black,
//                           ),
//                           onPressed: controller.play,
//                           iconSize: 42,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       IconButton(
//                         icon: const Icon(Icons.skip_next, color: Colors.white),
//                         onPressed: controller.next,
//                         iconSize: 36,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 32),
//                   ElevatedButton(
//                     onPressed: () => Get.to(() => DetailView()),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.black,
//                       backgroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                     ),
//                     child: const Text('Detail View'),
//                   ),
//                   const SizedBox(height: 32),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }



class HomePlayerView extends StatelessWidget {
  final MusicController controller = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
                  colors: [Colors.transparent, Colors.black.withOpacity(1)],
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.playlist.length,
                      itemBuilder: (context, index) {
                        final song = controller.playlist[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(song.imageUrl),
                          ),
                          title: Text(
                            song.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            controller.playSelectedSong(index);
                          },
                          trailing: index == controller.currentIndex.value
                              ?  Icon( controller.isPlaying.value ? Icons.pause : Icons.play_arrow, color: Colors.white)
                              : null,
                        );
                      },
                    ),
                  ),
                  // Mini player at the bottom
                  Container(
                    color: Colors.black.withOpacity(0.8),
                    child: ListTile(
                      leading: Hero(
                        tag: 'albumArt',
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(currentSong.imageUrl),
                        ),
                      ),
                      title: Text(
                        currentSong.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous, color: Colors.white),
                            onPressed: controller.previous,
                          ),
                          IconButton(
                            icon: Icon(
                              controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: controller.play,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next, color: Colors.white),
                            onPressed: controller.next,
                          ),
                        ],
                      ),
                      onTap: () => Get.to(() => DetailView()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

