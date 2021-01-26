import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let configuration = MonyboxSession.configuration
        
        let products = ProductsRouter(sessionConfig: configuration).view
        window?.rootViewController = products

        return true
    }
}

protocol PresentationProtocol: AnyObject {
    func onDismiss()
}
