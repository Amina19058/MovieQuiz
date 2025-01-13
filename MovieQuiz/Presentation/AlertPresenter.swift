//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Amina Khusnutdinova on 19.12.2024.
//

import UIKit

final class AlertPresenter {
    private weak var viewControllerDelegate: ViewControllerDelegate?
    
    func setup(delegate: ViewControllerDelegate) {
        viewControllerDelegate = delegate
    }
    
    func present(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }

        alert.addAction(action)
        alert.view.accessibilityIdentifier = alertModel.accessibilityIdentifier

        viewControllerDelegate?.present(alert, animated: true, completion: nil)
    }
}
