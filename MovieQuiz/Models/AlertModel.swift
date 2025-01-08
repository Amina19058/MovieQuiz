//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Amina Khusnutdinova on 19.12.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
