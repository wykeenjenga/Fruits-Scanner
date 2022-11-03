//
//  AppDelegate.swift
//  iKhokhaFruits
//
//  Created by Wykee Njenga on 10/26/22.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

@main
class APAppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate{

    var window: UIWindow?
    let appDiContainer = APDIContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        navigateToOnboarding()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func navigateToOnboarding() {
        if let onboarding = Accessors.Storyboard.main.instantiate(with: "OnBoardingScreen") as? UIViewController {
            if UIApplication.shared.keyWindow == nil {
                self.window?.rootViewController = onboarding
                self.window?.makeKeyAndVisible()
            }else{
                UIApplication.shared.keyWindow?.setRootViewController(onboarding, options: UIWindow.TransitionOptions(direction: .toRight))
            }
        } else {
            assertionFailure("Could not load onboarding screen")
        }
    }
    

}

