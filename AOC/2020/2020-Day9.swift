//
//  2020-Day9.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day9: Day {
        func validateInput(input: [Int], preamble: Int) -> Int? {
            outer: for i in preamble..<input.count {
                let startOfValidation = (i - preamble)
                let endOfValidation = (i - preamble) + preamble
                let data = Set(input[startOfValidation..<endOfValidation])
                let check = input[i]
                
                for d in data {
                    if data.contains(check - d) && check - d != d {
                        continue outer
                    }
                }
                return input[i]
            }
            
            return nil
        }
        
        func contiguousSet(input: [Int], sum: Int) -> [Int] {
            var result = [Int]()
            for i in input {
                result.append(i)
                
                var joinedSum = result.reduce(into: 0, +=)
                if joinedSum > sum {
                    while joinedSum > sum {
                        let popped = result.removeFirst()
                        joinedSum -= popped
                    }
                }
                if joinedSum == sum {
                    return result
                }
            }
            return []
        }
        
        func part1() -> String {
            let input = input.lines.ints
            let invalidLine = validateInput(input: input, preamble: 25)!
            return "\(invalidLine)"
        }
        
        func part2() -> String {
            let input = input.lines.ints
            let invalidLine = validateInput(input: input, preamble: 25)!
            let contiguousSet = contiguousSet(input: input, sum: invalidLine)
            let (min, max) = contiguousSet.minAndMax()!
            return "\(min + max)"
        }
    }
}
