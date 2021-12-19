//
//  Day2.swift
//  AOC21
//
//  Created by Micah Wilson on 12/3/21.
//

import Foundation

extension AOC21 {
    struct Day2: Day {
        func part1() -> String {
            var depth = 0
            var hor = 0
            
            let input = input.lines.map { ($0.components(separatedBy: .whitespaces)[0], Int($0.components(separatedBy: .whitespaces)[1])!) }
            
            for input in input {
                switch input.0 {
                case "forward":
                    hor += input.1
                case "up":
                    depth -= input.1
                case "down":
                    depth += input.1
                default:
                    break
                }
            }
            return "\(depth * hor)"
        }
        
        func part2() -> String {
            var depth = 0
            var hor = 0
            var aim = 0
            
            let input = input.lines.map { ($0.components(separatedBy: .whitespaces)[0], Int($0.components(separatedBy: .whitespaces)[1])!) }
            
            for input in input {
                switch input.0 {
                case "forward":
                    hor += input.1
                    depth += input.1 * aim
                case "up":
                    aim -= input.1
                case "down":
                    aim += input.1
                default:
                    break
                }
            }
            return "\(depth * hor)"
        }
    }
}
