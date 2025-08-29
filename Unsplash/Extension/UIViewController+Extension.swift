//
//  UIViewController+Extension.swift
//  Unsplash
//
//  Created by 금가경 on 8/29/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .default)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
