//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by gimon on 27.04.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
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
    }()
    
    func alertExit() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "Да",
            style: .default){[weak self] _ in
                guard let view = self?.view else {
                    return
                }
                view.confirmExit()
            }
        let action2 = UIAlertAction(
            title: "Нет",
            style: .default){_ in
                alert.dismiss(animated: true)
            }
        alert.addAction(action)
        alert.addAction(action2)
        guard let view = view as? ProfileViewController else {
            print("AlertPresenter alertExit view: nil")
            return
        }
        view.present(alert, animated: true )
    }
}
