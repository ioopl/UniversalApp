//
//  UIWindow.swift
//  UniversalApp
//
//  Created by UHS on 15/12/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit

extension UIWindow {

    /**
     This method returns the visible view controller on the window.
     - returns UIViewController : Any instance of visible View Controller on the screen.
     */
    func visibleViewController() -> UIViewController? {
        return visibleViewController(viewController: self.rootViewController)
    }

    private func visibleViewController(viewController: UIViewController?) -> UIViewController? {
        var visibleViewController: UIViewController? = nil

        if let navigationController = viewController as? UINavigationController {
            return navigationController.visibleViewController
        } else {
            if let presentedViewController = viewController?.presentedViewController {
                visibleViewController = self.visibleViewController(viewController: presentedViewController)
            } else {
                visibleViewController = viewController
            }
        }
        return visibleViewController
    }
}
