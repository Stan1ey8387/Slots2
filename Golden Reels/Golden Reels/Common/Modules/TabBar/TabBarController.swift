import UIKit

final class TabBarViewController: UITabBarController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        navigationBarAppearance.backgroundColor = .clear
        UINavigationBar.appearance().tintColor = .clear
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        let navigationBar = navigationController?.navigationBar
        navigationBarAppearance.shadowColor = .clear
        navigationBar?.scrollEdgeAppearance = navigationBarAppearance
        
        // Colors
        
        tabBar.backgroundColor = .init(hex: 0x1E2021)
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.barTintColor = .init(hex: 0x1E2021)
        
        // Setup
        
        setupViewControllers()
        
        additionalSafeAreaInsets.bottom = 20
    }
    
    private func setupViewControllers() {
        let imageInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: -10, right: 0) // .zero
        let titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 4) // .zero
        
        viewControllers = [
            createViewController(
                title: "",
                imageName: "untabbar_1",
                selectedImageName: "",
                viewController: UIViewController(),
                imageInsets: imageInsets,
                titlePositionAdjustment: titlePositionAdjustment
            ),
            createViewController(
                title: "",
                imageName: "untabbar_2",
                selectedImageName: "",
                viewController: UIViewController(),
                imageInsets: imageInsets,
                titlePositionAdjustment: titlePositionAdjustment
            ),
            createViewController(
                title: "",
                imageName: "untabbar_3",
                selectedImageName: "",
                viewController: UIViewController(),
                imageInsets: imageInsets,
                titlePositionAdjustment: titlePositionAdjustment
            ),
            createViewController(
                title: "",
                imageName: "untabbar_4",
                selectedImageName: "",
                viewController: UIViewController(),
                imageInsets: imageInsets,
                titlePositionAdjustment: titlePositionAdjustment
            ),
            createViewController(
                title: "",
                imageName: "untabbar_5",
                selectedImageName: "",
                viewController: UIViewController(),
                imageInsets: imageInsets,
                titlePositionAdjustment: titlePositionAdjustment
            )
        ]
    }
    
    private func createViewController(
        title: String?,
        imageName: String,
        selectedImageName: String,
        viewController: UIViewController,
        imageInsets: UIEdgeInsets = .zero,
        titlePositionAdjustment: UIOffset = .zero
    ) -> UIViewController {
        let viewController = UINavigationController(rootViewController: viewController)
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: imageName),
            selectedImage: selectedImageName == "" ? nil : UIImage(named: selectedImageName)
        )
        viewController.tabBarItem.imageInsets = imageInsets
        viewController.tabBarItem.titlePositionAdjustment = titlePositionAdjustment
        
        return viewController
    }
}
