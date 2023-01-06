class MeditationSvgAssets {
  static final MeditationSvgAssets _instance = MeditationSvgAssets._internal();

  factory MeditationSvgAssets() {
    return _instance;
  }

  MeditationSvgAssets._internal();

  Map<AssetName, String> assets = {
    AssetName.vectorBottom: "assets/icons/Vector.svg",
    AssetName.vectorTop: "assets/icons/Vector-1.svg",
    AssetName.headphone: "assets/icons/headphone.svg",
    AssetName.sensor: "assets/icons/headphone.svg",
  };
}

enum AssetName {
  // search,
  vectorBottom,
  vectorTop,
  headphone,
  // tape,
  // vectorSmallBottom,
  // vectorSmallTop,
  // back,
  // heart,
  // chart,
  // discover,
  // profile,
  sensor,
  //cctv,
}
