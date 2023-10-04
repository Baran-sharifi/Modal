//
//  Extensions.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/4/23.
//

import Foundation
import UIKit

extension UIViewController {
    
//    static func mostTopController() -> UIViewController? {
//        let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
//        let controller = keyWindow?.rootViewController
//        if var controller = controller {
//            while let presentedViewController = controller.presentedViewController {
//                controller = presentedViewController
//            }
//            return controller
//        }
//        return controller
//    }
//    
//    static func mostTopPush(vc: UIViewController) {
//        if let navc = UIViewController.mostTopController() as? UINavigationController {
//            navc.pushViewController(vc, animated: true)
//        } else {
//            UIViewController.mostTopController()?.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//    
//    static func present(_ viewController: UIViewController, _ animated: Bool = true) {
//        let navc = UINavigationController(rootViewController: viewController)
//        UIViewController.mostTopController()?.present(navc, animated: animated)
//    }
//    
//    static func fullScreenPresent(_ viewController: UIViewController, _ animated: Bool = true) {
//        let navc = UINavigationController(rootViewController: viewController)
//        navc.modalPresentationStyle = .fullScreen
//        UIViewController.mostTopController()?.present(navc, animated: animated)
//    }
//    
//    static func dismissTopMostViewController(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
//        UIViewController.mostTopController()?.dismiss(animated: animated, completion: completionHandler)
//    }
}
