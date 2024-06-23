import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
 
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.initTheme()
        let vc = LaucnScreen { [weak self] in
            guard let self = self else { return }
            self.window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        }
        
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
    }
}
