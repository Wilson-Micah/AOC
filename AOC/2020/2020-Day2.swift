//
//  2020-Day2.swift
//  AOC
//
//  Created by Micah Wilson on 12/17/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day2: Day {
        struct Password {
            let range: ClosedRange<Int>
            let char: String
            let password: String
            
            var isIncorrectlyValid: Bool {
                range.contains(password.characterCount[char, default: 0])
            }
            
            var isCorrectlyValid: Bool {
                let firstChar = String(password[password.index(password.startIndex, offsetBy: range.lowerBound - 1)])
                let secondChar = String(password[password.index(password.startIndex, offsetBy: range.upperBound - 1)])
                
                return (firstChar == char) != (secondChar == char)
            }
        }
        
        var passwords: [Password] {
            input.lines.map { line -> Password in
                let components = line.components(separatedBy: .init(charactersIn: "-: "))
                return Password(
                    range: Int(components[0])!...Int(components[1])!,
                    char: components[2],
                    password: components.last!
                )
            }
        }
        
        func part1() -> String {
            "\(passwords.filter { $0.isIncorrectlyValid }.count)"
        }
        
        func part2() -> String {
            "\(passwords.filter { $0.isCorrectlyValid }.count)"
        }
    }
}
