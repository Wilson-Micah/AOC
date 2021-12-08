//
//  Day8.swift
//  AOC21
//
//  Created by Micah Wilson on 12/7/21.
//

import Foundation

extension String {
    func matchesCharacters(of string: String) -> Bool {
        Set(Array(self)) == Set(Array(string))
    }
    
    func containsCharacters(of string: String) -> Bool {
        Set(Array(self)).union(Array(string)).count == self.count
    }
}

struct Day8: Day {
    func part1() -> String {
        let input = input.lines.map { $0.components(separatedBy: "|")[1] }.map { $0.spaces }
        
        var count = 0
        for row in input {
            count += row.filter {
                $0.count == 2 || $0.count == 3 || $0.count == 7 || $0.count == 4
            }.count
        }
        return "\(count)"
    }
    
    func part2() -> String {
        let code = input.lines.map { $0.components(separatedBy: "|")[0] }.map { $0.trimmingCharacters(in: .whitespaces).spaces }
        let output = input.lines.map { $0.components(separatedBy: "|")[1] }.map { $0.trimmingCharacters(in: .whitespaces).spaces }
        
        var count = 0
        for (codeRow, outputRow) in zip(code, output)  {
            let one = codeRow.filter { $0.count == 2 }[0]
            let four = codeRow.filter { $0.count == 4 }[0]
            let seven = codeRow.filter { $0.count == 3 }[0]
            let eight = codeRow.filter { $0.count == 7 }[0]
            let nine = codeRow.filter { row in row.count == 6 && row.containsCharacters(of: four) }[0]
            let zero = codeRow.filter { row in row.count == 6 && !row.containsCharacters(of: four) && row.containsCharacters(of: one) }[0]
            let three = codeRow.filter { row in row.count == 5 && row.containsCharacters(of: seven) }[0]
            let six = codeRow.filter { row in row.count == 6 && !row.containsCharacters(of: nine) && !row.containsCharacters(of: zero) }[0]

            let topRight = one.components(separatedBy: .init(charactersIn: six)).joined()
            let bottomRight = one.components(separatedBy: .init(charactersIn: topRight)).joined()
            let two = codeRow.filter { row in row.count == 5 && !row.contains(bottomRight) }[0]
            let five = codeRow.filter { row in row.count == 5 && !row.containsCharacters(of: three) && !row.containsCharacters(of: two) }[0]
            
            let outputNumbers = outputRow.map { value -> Int in
                if value.matchesCharacters(of: one) {
                    return 1
                } else if value.matchesCharacters(of: two) {
                    return 2
                } else if value.matchesCharacters(of: three) {
                    return 3
                } else if value.matchesCharacters(of: four) {
                    return 4
                } else if value.matchesCharacters(of: five) {
                    return 5
                } else if value.matchesCharacters(of: six) {
                    return 6
                } else if value.matchesCharacters(of: seven) {
                    return 7
                }  else if value.matchesCharacters(of: eight) {
                    return 8
                }  else if value.matchesCharacters(of: nine) {
                    return 9
                } else {
                    return 0
                }
            }
            
            count += Int(outputNumbers.map(String.init).joined())!
        }
        return "\(count)"
    }
}
