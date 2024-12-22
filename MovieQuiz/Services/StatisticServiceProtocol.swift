//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Amina Khusnutdinova on 19.12.2024.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
