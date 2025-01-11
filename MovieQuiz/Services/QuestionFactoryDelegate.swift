//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Amina Khusnutdinova on 19.12.2024.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
