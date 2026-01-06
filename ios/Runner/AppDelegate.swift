import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var eventChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        eventChannel = FlutterMethodChannel(name: "com.academixstore.app/security", binaryMessenger: controller.binaryMessenger)
        
        // Listen for screen capture (recording/mirroring)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenCaptureChanged),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        
        sendCaptureStatus() // Initial check
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @objc func screenCaptureChanged() {
        sendCaptureStatus()
    }

    private func sendCaptureStatus() {
        let captured = UIScreen.main.isCaptured
        eventChannel?.invokeMethod("captureChanged", arguments: captured)
    }
}
