//
//  AppDelegate.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        
        let navc = UINavigationController()
        navc.viewControllers = [ViewController()]
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = navc
        
        return true
    }
}
