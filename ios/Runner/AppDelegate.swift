import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var widgetChannel: FlutterMethodChannel?
  private var pendingTripId: String?
  private var dartReady = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "com.surlequai.app/widget",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    widgetChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { result(nil); return }
      guard call.method == "takeInitialTrip" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self.dartReady = true
      result(self.pendingTripId)
      self.pendingTripId = nil
    }
  }

  func openWidgetURL(_ url: URL) {
    guard url.scheme == "surlequai", url.host == "trip",
          let tripId = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?.first(where: { $0.name == "tripId" })?.value else { return }
    if dartReady {
      widgetChannel?.invokeMethod("switchToTrip", arguments: tripId)
    } else {
      pendingTripId = tripId
    }
  }
}

// home_widget 0.9 handles UIApplication URLs; current iOS delivers them to scenes.
class SceneDelegate: FlutterSceneDelegate {
  override func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
                      options connectionOptions: UIScene.ConnectionOptions) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    for context in connectionOptions.urlContexts {
      (UIApplication.shared.delegate as? AppDelegate)?.openWidgetURL(context.url)
    }
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    super.scene(scene, openURLContexts: URLContexts)
    for context in URLContexts {
      (UIApplication.shared.delegate as? AppDelegate)?.openWidgetURL(context.url)
    }
  }
}
