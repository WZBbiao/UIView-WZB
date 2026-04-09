import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let homeNavigationController = UINavigationController(rootViewController: ViewController())
        homeNavigationController.tabBarItem = UITabBarItem(title: "Canvas", image: UIImage(systemName: "square.grid.2x2"), tag: 0)

        let formsNavigationController = UINavigationController(rootViewController: FormsViewController())
        formsNavigationController.tabBarItem = UITabBarItem(title: "Forms", image: UIImage(systemName: "slider.horizontal.3"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController, formsNavigationController]
        tabBarController.selectedIndex = 0

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
