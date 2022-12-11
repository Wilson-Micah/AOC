//
//  2022-Day11.swift
//  AOC
//
//  Created by Micah Wilson on 12/10/22.
//

import Algorithms
import Foundation

extension AOC22 {
    
    struct Monkey {
        struct Item {
            var worryLevel: Int
        }
        var items: [Item]
        let operation: String
        let test: Int
        let trueMonkey: Int
        let falseMonkey: Int
        
        mutating func runOperation(divide: Bool = true, mod: Int, itemIndex: Int) -> Bool {
            let components = operation.spaces
            let lhs = components[0] == "old" ? items[itemIndex].worryLevel : Int(components[0])!
            let rhs = components[2] == "old" ? items[itemIndex].worryLevel : Int(components[2])!
            
            switch components[1] {
            case "+":
                items[itemIndex].worryLevel = (lhs + rhs)
            case "*":
                items[itemIndex].worryLevel = (lhs * rhs)
            default:
                break
            }

            if divide {
                items[itemIndex].worryLevel /= mod
            } else {
                items[itemIndex].worryLevel %= mod
            }
            return items[itemIndex].worryLevel % test == 0
        }
    }
    struct Day11: Day {
        var monkeys: [Monkey] {
            input.blankLines.map { monkeyData in
                let data = monkeyData.lines
                return Monkey(
                    items: data[1].components(separatedBy: ": ")[1].components(separatedBy: ", ").map { Monkey.Item(worryLevel: Int($0)!) },
                    operation: data[2].components(separatedBy: "= ")[1],
                    test: Int(data[3].components(separatedBy: "by ")[1])!,
                    trueMonkey: Int(data[4].spaces.last!)!,
                    falseMonkey: Int(data[5].spaces.last!)!
                )
            }
        }
        
        func runMonkeyInspection(divide: Bool = true, mod: Int, count: Int) -> String {
            var monkeys = self.monkeys
            var monkeyInspections = Array(repeating: 0, count: monkeys.count)
            for _ in 0..<count {
                for monkeyIndex in monkeys.indices {
                    for itemIndex in monkeys[monkeyIndex].items.indices {
                        monkeyInspections[monkeyIndex] += 1
                        if monkeys[monkeyIndex].runOperation(divide: divide, mod: mod, itemIndex: itemIndex) {
                            monkeys[monkeys[monkeyIndex].trueMonkey].items.append(monkeys[monkeyIndex].items[itemIndex])
                        } else {
                            monkeys[monkeys[monkeyIndex].falseMonkey].items.append(monkeys[monkeyIndex].items[itemIndex])
                        }
                    }
                    monkeys[monkeyIndex].items.removeAll()
                }
            }
            return "\(monkeyInspections.max(count: 2).reduce(into: 1, *=))"
        }
        
        func part1() -> String {
            return runMonkeyInspection(mod: 3, count: 20)
        }
        
        func part2() -> String {
            let mod = self.monkeys.map(\.test).reduce(into: 1, *=)
            return runMonkeyInspection(divide: false, mod: mod, count: 10000)
        }
    }
}
