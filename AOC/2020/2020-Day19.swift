//
//  2020-Day19.swift
//  AOC
//
//  Created by Micah Wilson on 12/15/22.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day19: Day {
        indirect enum Rule {
            case string(String)
            case or([Rule])
            case and([Rule])
            
            static func addRule(rule: String? = nil, current: String, rules: [String: String]) -> Rule {
                guard let rule = rule ?? rules[current] else { fatalError() }
                if rule.contains("\"") {
                    return .string(rule.components(separatedBy: "\"")[1])
                } else if rule.contains("|") {
                    let components = rule.components(separatedBy: " | ")
                    return .or(
                        components.map {
                            Self.addRule(rule: $0, current: $0, rules: rules)
                        }
                    )
                } else {
                    let components = rule.spaces
                    return .and(
                        components.map {
                            Self.addRule(current: $0, rules: rules)
                        }
                    )
                }
            }
            
            var validStrings: [String] {
                switch self {
                case let .string(string):
                    return [string]
                case let .and(rules):
                    var validStrings = [String]()
                    for rule in rules {
                        if validStrings.isEmpty {
                            validStrings = rule.validStrings
                        } else {
                            let rhsStrings = rule.validStrings
                            validStrings = validStrings.flatMap { lhs in rhsStrings.map { lhs + $0 } }
                        }
                    }
                    return validStrings
                case let .or(rules):
                    return rules.flatMap { $0.validStrings }
                }
            }
            
            func validate(_ string: String) -> Bool {
                return false
            }
        }
        
        func rule(_ lines: [String], current: String) -> Rule {
            let rules = lines.reduce(into: [String: String]()) { partialResult, lines in
                let components = lines.components(separatedBy: ": ")
                partialResult[components[0]] = components[1]
            }
            
            return Rule.addRule(current: current, rules: rules)
        }
        
        func part1() -> String {
            let validStrings = Set(rule(input.blankLines[0].lines, current: "0").validStrings)
            let strings = input.blankLines[1].lines
            return "\(strings.filter { validStrings.contains($0) }.count)"
        }
        
        func part2() -> String {
            let rule42 = rule(
                input.blankLines[0].replacingOccurrences(of: "8: 42", with: "8: 42 | 42 8").replacingOccurrences(of: "11: 42 31", with: "11: 42 31 | 42 11 31")
                    .lines,
                current: "42"
            )
            let rule31 = rule(
                input.blankLines[0].replacingOccurrences(of: "8: 42", with: "8: 42 | 42 8").replacingOccurrences(of: "11: 42 31", with: "11: 42 31 | 42 11 31")
                    .lines,
                current: "31"
            )

            let strings = input.blankLines[1].lines
            let start = rule42.validStrings
            let end = rule31.validStrings
            
            var validCount = 0
            outer: for var string in strings {
                let subString = string[string.startIndex..<string.index(string.startIndex, offsetBy: 8)]
                string.removeFirst(8)
                if !start.contains(String(subString)) {
                    continue
                } else {
                    var startCount = 0
                    var endCount = 0
                    while !string.isEmpty {
                        let subString = string[string.startIndex..<string.index(string.startIndex, offsetBy: 8)]
                        string.removeFirst(8)
                        if endCount == 0 && start.contains(String(subString)) {
                            startCount += 1
                        } else if end.contains(String(subString)) {
                            endCount += 1
                        } else {
                            continue outer
                        }
                    }
                    
                    if startCount > 0 && endCount > 0 && startCount >= endCount {
                        validCount += 1
                    }
                }
            }
            
            return "\(validCount)"
        }
    }
}
