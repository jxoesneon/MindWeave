import Cocoa
import FlutterMacOS
import FirebaseCore

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  // Handle URL callbacks for Google Sign-In
  override func application(_ application: NSApplication, open urls: [URL]) {
    for url in urls {
      // Let the Google Sign-In plugin handle the URL
      if url.scheme?.hasPrefix("com.googleusercontent.apps") == true {
        // The google_sign_in plugin will handle this internally
        return
      }
    }
    super.application(application, open: urls)
  }
}
