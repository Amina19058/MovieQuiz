//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Amina Khusnutdinova on 19.12.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        guard another.total > 0 else {
            return true
        }
        return Double(correct)/Double(total) > Double(another.correct)/Double(another.total)
    }
}
