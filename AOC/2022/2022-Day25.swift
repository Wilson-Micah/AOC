//
//  2022-Day25.swift
//  AOC
//
//  Created by Micah Wilson on 12/24/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day25: Day {
        func convertToDecimal(string: String) -> Int {
            var count = 1
            var value = 0
            for char in string {
                switch char {
                case "2":
                    value += Int(pow(5.0, Double(string.count - count)) * 2)
                case "1":
                    value += Int(pow(5.0, Double(string.count - count)))
                case "0": break
                case "-":
                    value -= Int(pow(5.0, Double(string.count - count)))
                case "=":
                    value -= Int(pow(5.0, Double(string.count - count)) * 2)
                default: break
                }
                count += 1
            }
            return value
        }
        
        func convertToSNAFU(value: Int) -> String {
            
            let length = Int(ceil(log(Double(value))/log(5)))
            var remainder = value
            var string = ""
            for i in 0...length {
                let base = Int(pow(5.0, Double(length - i)))
                
                if remainder > 0 {
                    if abs(base * 2 - remainder) > remainder && abs(remainder - base) > remainder {
                        string += "0"
                    } else if abs(base * 2 - remainder) <= abs(remainder - base) {
                        string += "2"
                        remainder -= base * 2
                    } else if abs(remainder - base) < abs(base * 2 - remainder) {
                        string += "1"
                        remainder -= base
                    }
                } else if remainder < 0 {
                    if abs(remainder + base * 2) > abs(remainder) && abs(base + remainder) > abs(remainder) {
                        string += "0"
                    } else if abs(remainder + base * 2) <= abs(base + remainder) {
                        string += "="
                        remainder += base * 2
                    } else if abs(base + remainder) < abs(remainder + base * 2) {
                        string += "-"
                        remainder += base
                    }
                } else {
                    string += "0"
                }
            }
            
            string.trimPrefix(while: { $0 == "0" })
            return string
        }
        
        func part1() -> String {
            let result = input.lines.map(convertToDecimal(string:)).reduce(into: 0, +=)
            return convertToSNAFU(value: result)
        }
        
        func part2() -> String {
            return "No Part 2 on Christmas"
        }
    }
}
