//
//  UIViewController+Alerts.swift
//  UniversalApp
//
//  Created by UHS on 15/12/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit


extension UIViewController {

    /**
     Shows alert with optional ok and cancel buttons

     - parameter title:         String?
     - parameter message:       String?
     - parameter okButton:      Bool? whether ok button is shown
     - parameter okTitle:       String? default OK
     - parameter okHandler:     ()->()?
     - parameter cancelButton:  Bool? whether cancel button is shown
     - parameter cancelTitle:   String? default Cancel
     - parameter cancelHandler: ()->()?
     */
    func showAlertView(title: String? = nil,
                       message: String? = nil,
                       okButton: Bool? = true,
                       okTitle: String? = NSLocalizedString("BTN_OK", comment: "OK button title"),
                       okHandler: ((UIAlertAction) -> Void)? = nil,
                       cancelButton: Bool? = false,
                       cancelTitle: String? = NSLocalizedString("BTN_CANCEL", comment: "Cancel button title"),
                       cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        guard let okButton = okButton,
            let cancelButton = cancelButton else {
                return
        }
        // ok button
        if okButton {
            let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
            alertController.addAction(okAction)
        }
        // cancel button
        if cancelButton {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
            alertController.addAction(cancelAction)
        }

        AppDelegate.sharedInstance()?.window?.visibleViewController()?.present(alertController, animated: true, completion: nil)
    }
}
