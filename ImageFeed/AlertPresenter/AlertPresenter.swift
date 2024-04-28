//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by gimon on 27.04.2024.
//

import UIKit

final class AlertPresenter {
    
    static let alertError: UIAlertController = {
            let alert = UIAlertController(
                title: "Что-то пошло не так(",
                message: "Не удалось войти в систему",
                preferredStyle: .alert
            )
            let action = UIAlertAction(
                title: "Ок",
                style: .default){ _ in alert.dismiss(animated: true)
                }
            alert.addAction(action)
        return alert
//        present(AlertPresenter.alertError, animated: true, completion: nil)
    }()
}
