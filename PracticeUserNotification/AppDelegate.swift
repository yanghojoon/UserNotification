import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { // 앱이 처음 실행되는 방법은 정말 다양하다. launchOptions에 remoteNotification을 처리할 수 있다.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]) { granted, error in
            print("권한 허용 \(granted)")
            
            if let error = error {
                print(error)
            }
        }
        application.registerForRemoteNotifications() // APNs 사용하기 위해
        center.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 알림을 탭으로 터치했을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did Receive")
        
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
            return
        }
        
        guard let tapbarVC = rootViewController as? UITabBarController else { return }
        
        if response.notification.request.content.userInfo["target_view"] as! String == "yellow_view" {
            let title = response.notification.request.content.title
            let body = response.notification.request.content.body
            tapbarVC.selectedIndex = 1
            guard let navigationController = tapbarVC.selectedViewController as? UINavigationController else { return }
            navigationController.topViewController?.performSegue(withIdentifier: "yellow", sender: (title, body))
        } else if response.notification.request.content.userInfo["target_view"] as! String == "brown_view" {
            tapbarVC.selectedIndex = 2
            tapbarVC.selectedViewController?.performSegue(withIdentifier: "brown", sender: nil)
        }
    }
    
    // 앱이 foreground에 있을 때 -> 설정을 따로 해주지 않으면 Alert가 따로 뜨진 않는다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
        print("willPresent")
    }
}
