import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DataModel/SongList.dart';

class MusicController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxList<SongList> playlist = <SongList>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxBool isPlaying = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxBool isShuffleOn = false.obs;
  final RxInt repeatMode = 0.obs; // 0: off, 1: all, 2: one

  @override
  void onInit() {
    super.onInit();
    _initializePlaylist();
    _loadLastPlayedSong();
    _setupAudioPlayer();
  }

    void _initializePlaylist() {
      playlist.addAll([
        SongList(
          url: "https://app.konnectus.live/audify/public/uploads/audio_files/2_Square_compressed.mp3",
          title: "Square Compressed",
          imageUrl: "https://app.konnectus.live/audify/public/uploads/posters/Surprise_270x390.jpg.jpg",
        ),
        SongList(
          url: 'https://app.konnectus.live/audify/public/uploads/audio_files/【English_Dubbed】Since_I_Met_U_EP01___She_mistook_him_for_her_crush_and_kissed_him___Fresh_Drama_Pro_(1).mp3',
          title: 'Since I Met U',
          imageUrl: 'https://app.konnectus.live/audify/public/uploads/posters/TheCursedNecklace_270x390.jpg.jpg',
        ),
        SongList(
          url: 'https://app.konnectus.live/audify/public/uploads/audio_files/Sanjay_Goradia_&_Siddharth_Randeria_-_Superhit_Gujarati_Comedy_Natako___@gujaraticomedy5787_(1).mp3',
          title: 'Comedy Audio',
          imageUrl: 'https://app.konnectus.live/audify/public/uploads/posters/Dubki_270x390.jpg.jpg',
        ),
        SongList(
          url: 'https://app.konnectus.live/audify/public/uploads/audio_files/Drama_Juniors_UNSEEN_EPISODE___Zee_Marathi_(1).mp3',
          title: 'Drama Juniors',
          imageUrl: 'https://app.konnectus.live/audify/public/uploads/posters/ThankYouSimran_270x390.jpg.jpg',
        ),
        SongList(
          url: 'https://cdn-preview-3.dzcdn.net/stream/c-3e0ecd7752409cb4ea6e14951d0a1d78-3.mp3',
          title: 'Meri Mehbooba',
          imageUrl: 'https://e-cdns-images.dzcdn.net/images/cover/1ee8f8f0da25fd2d1f2d076b29481e10/500x500-000000-80-0-0.jpg',
        ),
      ]);

    }

  void _loadLastPlayedSong() async {
    final prefs = await SharedPreferences.getInstance();
    currentIndex.value = prefs.getInt('lastPlayedIndex') ?? 0;
    final lastPosition = prefs.getInt('lastPosition') ?? 0;
    await _loadCurrentSong();
    await _audioPlayer.seek(Duration(milliseconds: lastPosition));
  }

  void _setupAudioPlayer() {
    _audioPlayer.positionStream.listen((p) {
      position.value = p;
      _savePosition();
    });
    _audioPlayer.durationStream.listen((d) {
      duration.value = d ?? Duration.zero;
    });
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
    _audioPlayer.shuffleModeEnabledStream.listen((enabled) {
      isShuffleOn.value = enabled;
    });
    _audioPlayer.loopModeStream.listen((LoopMode mode) {
      switch (mode) {
        case LoopMode.off:
          repeatMode.value = 0;
          break;
        case LoopMode.one:
          repeatMode.value = 2;
          break;
        case LoopMode.all:
          repeatMode.value = 1;
          break;
      }
    });
  }

  Future<void> _loadCurrentSong() async {
    await _audioPlayer.setUrl(playlist[currentIndex.value].url);
  }

  void play() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    _saveLastPlayedSong();
  }

  void next() async {
    if (currentIndex.value < playlist.length - 1) {
      currentIndex.value++;
    } else {
      currentIndex.value = 0; // Loop back to the first song
    }
    await _loadCurrentSong();
    await _audioPlayer.play();
    _saveLastPlayedSong();
  }

  void previous() async {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    } else {
      currentIndex.value = playlist.length - 1; // Loop to the last song
    }
    await _loadCurrentSong();
    await _audioPlayer.play();
    _saveLastPlayedSong();
  }

  void playSelectedSong(int index) async {
    currentIndex.value = index;
    await _loadCurrentSong();
    await _audioPlayer.play();
    _saveLastPlayedSong();
  }

  void seekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  void seekForward() {
    _audioPlayer.seek(position.value + Duration(seconds: 10));
  }

  void seekBackward() {
    _audioPlayer.seek(position.value - Duration(seconds: 10));
  }

  void toggleShuffle() {
    isShuffleOn.value = !isShuffleOn.value;
    _audioPlayer.setShuffleModeEnabled(isShuffleOn.value);
    _saveShuffleMode();
  }

  void toggleRepeat() {
    repeatMode.value = (repeatMode.value + 1) % 3;
    switch (repeatMode.value) {
      case 0:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
      case 1:
        _audioPlayer.setLoopMode(LoopMode.all);
        break;
      case 2:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
    }
    _saveRepeatMode();
  }

  void _saveLastPlayedSong() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastPlayedIndex', currentIndex.value);
  }

  void _savePosition() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastPosition', position.value.inMilliseconds);
  }

  void _saveShuffleMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('shuffleMode', isShuffleOn.value);
  }

  void _saveRepeatMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('repeatMode', repeatMode.value);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}


