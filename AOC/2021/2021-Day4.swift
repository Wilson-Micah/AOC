//
//  Day4.swift
//  AOC21
//
//  Created by Micah Wilson on 12/3/21.
//

import Foundation

extension AOC21 {
    struct Day4: Day {
        func checkBoard(_ board: [[String]]) -> Bool {
            for row in board.indices {
                if board[row].allSatisfy({ $0 == "*" }) {
                    return true
                }
                var bingo = true
                for col in board[row].indices {
                    if board[col][row] != "*" {
                        bingo = false
                    }
                }
                if bingo {
                    return true
                }
            }
            return false
        }
        
        func markBoard(_ board: inout [[String]], input: String) {
            for row in board.indices {
                for col in board[row].indices where board[row][col] == input {
                    board[row][col] = "*"
                }
            }
        }
        
        func calculateBoard(_ board: [[String]], input: String) -> Int {
            var value = 0
            for row in board.indices {
                for col in board[row].indices {
                    if board[row][col] != "*",
                       let amount = Int(board[row][col]) {
                        value += amount
                    }
                }
            }
            return value * Int(input)!
        }
        
        func part1() -> String {
            var boards = Array(input.components(separatedBy: "\n\n").dropFirst())
                .map { board in
                    board.components(separatedBy: .newlines).map { line in
                        line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
                    }
                }
            let input = input.lines.first!.components(separatedBy: ",")
            
            for input in input {
                for boardIndex in boards.indices {
                    markBoard(&boards[boardIndex], input: input)
                    if checkBoard(boards[boardIndex]) {
                        return "\(calculateBoard(boards[boardIndex], input: input))"
                    }
                }
            }
            return ""
        }
        
        func part2() -> String {
            var boards = Array(input.components(separatedBy: "\n\n").dropFirst())
                .map { board in
                    board.components(separatedBy: .newlines).map { line in
                        line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
                    }
                }
            let input = input.lines.first!.components(separatedBy: ",")
            var unfinishedBoards = zip(boards, boards.indices).reduce(into: [Int: [[String]]]()) { partialResult, result in
                partialResult[result.1] = result.0
            }
            for input in input {
                for boardIndex in boards.indices {
                    markBoard(&boards[boardIndex], input: input)
                    if checkBoard(boards[boardIndex]) && unfinishedBoards.isEmpty {
                        return "\(calculateBoard(boards[boardIndex], input: input))"
                    } else if checkBoard(boards[boardIndex]) {
                        unfinishedBoards[boardIndex] = nil
                        
                        if unfinishedBoards.isEmpty {
                            return "\(calculateBoard(boards[boardIndex], input: input))"
                        }
                    }
                }
            }
            return ""
        }
    }
}
