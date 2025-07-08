enum Flavor {dev}

class AppConfig {
  String appName = "";
  Flavor flavor = Flavor.dev;

  static AppConfig shared = AppConfig.create();

  factory AppConfig.create(
      {String appName = "",
      Flavor flavor = Flavor.dev}) {
    return shared = AppConfig(appName, flavor);
  }

  AppConfig(this.appName, this.flavor);
}
