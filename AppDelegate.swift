//
//  AppDelegate.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 25/04/24.
//

import UIKit
import FirebaseCore
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func listenToAuthChanges() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! UITabBarController
        let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! UINavigationController
        
        Auth.auth().addStateDidChangeListener { auth, newUser in
            if let _ = newUser{
                Task{
                    await getUserDetails()
                    do{
                        try await getProducts()
                        await getChats()
                        await listenToChanges()
                    }catch{}

                }
                return self.switchRootViewController(to: mainViewController)
            } else {
                self.switchRootViewController(to: authViewController)
            }
        }
    }
    
    func switchRootViewController(to newViewController: UIViewController) {
        DispatchQueue.main.async{
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first {
                window.rootViewController = newViewController
                window.makeKeyAndVisible()
            }
        }
    }



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Task{
            listenToAuthChanges()
        }
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

