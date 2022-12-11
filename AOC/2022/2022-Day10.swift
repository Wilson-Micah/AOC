//
//  2022-Day10.swift
//  AOC
//
//  Created by Micah Wilson on 12/9/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day10: Day {
        func runProgram(postCycle: Bool, lines: [String], cycle: (_ cycle: Int, _ value: Int) -> Void) {
            var cycleCount = postCycle ? 1 : 0
            var currentValue = 1
            for line in lines {
                cycle(cycleCount, currentValue)
                cycleCount += 1
                
                if line != "noop" {
                    cycle(cycleCount, currentValue)
                    cycleCount += 1
                    currentValue += Int(line.spaces[1])!
                }
            }
        }
        
        func part1() -> String {
            var values = [Int]()
            runProgram(postCycle: true, lines: input.lines) { cycle, value in
                guard (cycle - 20) % 40 == 0 else { return }
                values.append(value * (cycle))
            }
            return "\(values.reduce(into: 0, +=))"
        }
        
        func part2() -> String {
            var ouput = [[String]()]
            runProgram(postCycle: false, lines: input.lines) { cycle, value in
                ouput[ouput.count - 1].append((abs(value - (cycle % 40)) <= 1 ? "#" : "."))
                if ouput.last!.count == 40 {
                    ouput.append(.init())
                }
            }
            
            return "\(ouput.grid)"
        }
    }
}
