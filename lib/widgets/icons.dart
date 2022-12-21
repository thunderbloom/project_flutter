class MeditationSvgAssets {
  static final MeditationSvgAssets _instance = MeditationSvgAssets._internal();

  factory MeditationSvgAssets() {
    return _instance;
  }

  MeditationSvgAssets._internal();

  Map<AssetName, String> assets = {
    // AssetName.search: "assets/icons/search.svg",
    AssetName.vectorBottom: "assets/icons/Vector.svg",
    AssetName.vectorTop: "assets/icons/Vector-1.svg",
    AssetName.headphone: "assets/icons/headphone.svg",
    // AssetName.tape: "assets/icons/tape.svg",
    // AssetName.vectorSmallBottom: "assets/pics/VectorSmallBottom.svg",
    // AssetName.vectorSmallTop: "assets/pics/VectorSmallTop.svg",
    // AssetName.back: "assets/icons/back.svg",
    // AssetName.heart: "assets/icons/heart.svg",
    // AssetName.chart: "assets/icons/chart.svg",
    // AssetName.discover: "assets/icons/discover.svg",
    // AssetName.profile: "assets/icons/profile.svg",
    AssetName.sensor: "assets/icons/headphone.svg",
    //AssetName.cctv: "assets/icons/cctv1.png",
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
