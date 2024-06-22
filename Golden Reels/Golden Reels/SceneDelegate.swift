import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let key = "NeedShowOnboarding1"
    var needShowOnboarding: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        } get {
            let value = (UserDefaults.standard.value(forKey: key) as? Bool) ?? true
            return value
        }
    }
 
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
            if self.needShowOnboarding {
                let views = Constans.Onboarding.items.map {
                    OnboardingItemView(viewModel: $0)
                }
                let onboardingViewController = OnboardingViewController(views: views)
                onboardingViewController.finishHandler = { [weak self] in
                    self?.needShowOnboarding = false
                    self?.window?.rootViewController = TabBarViewController()
                }
                self.window?.rootViewController = onboardingViewController
            } else {
                self.window?.rootViewController = TabBarViewController()
            }
        }
        
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
    }
}
