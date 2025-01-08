//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Amina Khusnutdinova on 21.12.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount = "gamesCount"
        case bestGameCorrect = "bestGameCorrect"
        case bestGameTotal = "bestGameTotal"
        case bestGameDate = "bestGameDate"
        case totalAmount = "totalAmount"
        case correctAnswers = "correctAnswers"
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    private var totalAmount: Int {
        get {
            storage.integer(forKey: Keys.totalAmount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAmount.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            let bestGameCorrect = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let bestGameTotal = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let bestGameDate = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: bestGameCorrect, total: bestGameTotal, date: bestGameDate)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let totalCorrectAnswers = storage.double(forKey: Keys.correctAnswers.rawValue)
            let totalQuestionsAmount = storage.double(forKey: Keys.totalAmount.rawValue)
            
            return totalQuestionsAmount > .zero ? totalCorrectAnswers * 100 / totalQuestionsAmount : .zero
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correctAnswers += count
        totalAmount += amount
        
        let gameResult = GameResult(correct: count, total: amount, date: Date())
        
        if gameResult.isBetterThan(bestGame) {
            bestGame = gameResult
        }
    }
}
