//
//  PopUp.swift
//  Honnaeng
//
//  Created by Rarla on 4/2/24.
//

import UIKit

final class PopUp {
    
    static let shared = PopUp()
    private init() {}
    
    func showOneButtonPopUp(self: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { action in }
        alert.addAction(confirmAction)
        self.present(alert, animated: true)
    }
    
    func showTwoButtonPopUp(self: UIViewController, title: String, message: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { action in }
        let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
            completionHandler()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true)
    }
}
