//
//  2020-Day14.swift
//  AOC
//
//  Created by Micah Wilson on 12/21/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day14: Day {
        func part1() -> String {
            var mask = Array<String.Element>()
            var memory = [Int: Int]()
            input.lines.forEach { line in
                if line.contains("mask") {
                    mask = Array(line.components(separatedBy: .whitespaces).last!)
                    return
                }
                
                let memoryPosition = Int(line.components(separatedBy: "[")[1].components(separatedBy: "]")[0])!
                let decimal = Int(line.components(separatedBy: "= ")[1])!
                var binary = Array(String(decimal, radix: 2))
                let padding = Array(repeating: String.Element("0"), count: mask.count - binary.count)
                binary = padding + binary
                
                for (maskChar, binaryChar) in zip(mask.indices, binary.indices) {
                    if mask[maskChar] != "X" {
                        binary[binaryChar] = mask[maskChar]
                    }
                }
                
                memory[memoryPosition] = Int(binary.map(String.init).joined(), radix: 2)
            }
            return "\(memory.values.reduce(into: 0, +=))"
        }
        
        func part2() -> String {
            var mask = Array<String.Element>()
            var memory = [Int: Int]()
            input.lines.forEach { line in
                if line.contains("mask") {
                    mask = Array(line.components(separatedBy: .whitespaces).last!)
                    return
                }
                
                let memoryPosition = Int(line.components(separatedBy: "[")[1].components(separatedBy: "]")[0])!
                let decimal = Int(line.components(separatedBy: "= ")[1])!
                var binary = Array(String(memoryPosition, radix: 2))
                let padding = Array(repeating: Character("0"), count: mask.count - binary.count)
                binary = padding + binary
                
                var newMemoryAddress = ""
                var xIndexes = [Int]()
                var count = 0
                for (maskChar, binaryChar) in zip(mask.indices.reversed(), binary.indices.reversed()) {
                    if mask[maskChar] != "X" {
                        newMemoryAddress = String(mask[maskChar] == "0" ? binary[binaryChar] : "1") + newMemoryAddress
                    } else {
                        xIndexes.append(count)
                        newMemoryAddress = "X" + newMemoryAddress
                    }
                    count += 1
                }
                var baseDecimal = Set([Int(newMemoryAddress.replacingOccurrences(of: "X", with: "0"), radix: 2)!])
                
                for xIndex in xIndexes {
                    var temp = baseDecimal
                    for decimal in baseDecimal {
                        let increase = Int(pow(2, Double(xIndex)))
                        temp.insert(decimal + increase)
                    }
                    baseDecimal = temp
                }
                
                for base in baseDecimal {
                    memory[base] = decimal
                }
            }

            return "\(memory.values.reduce(into: 0, +=))"
        }
    }
}
