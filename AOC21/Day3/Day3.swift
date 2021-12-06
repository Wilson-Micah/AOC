//
//  Day3.swift
//  AOC21
//
//  Created by Micah Wilson on 12/3/21.
//

import Foundation

struct Day3: Day {
    func part1() -> String {
        let input = input.columns.map(\.ints)
        var gammaRate = ""
        var epsilonRate = ""
        
        for column in input {
            let oneBit = column.filter { $0 == 1 }.count > column.filter { $0 == 0 }.count
            gammaRate += oneBit ? "1" : "0"
            epsilonRate += oneBit ? "0" : "1"
        }
        let gamma = Int(gammaRate, radix: 2)!
        let epsilon = Int(epsilonRate, radix: 2)!
        return "\(gamma * epsilon)"
    }
    
    func part2() -> String {
        var oxygenInput = input.columns.map(\.ints)
        var co2Input = input.columns.map(\.ints)
        
        for row in oxygenInput.indices where oxygenInput[row].count > 1 {
            let oneBit = oxygenInput[row].filter { $0 == 1 }.count >= oxygenInput[row].filter { $0 == 0 }.count
            oxygenInput = oxygenInput.map { input in
                input.indices.filter { oxygenInput[row][$0] == (oneBit ? 1 : 0) }
                .map { input[$0] }
            }
        }
        
        for row in co2Input.indices where co2Input[row].count > 1 {
            let oneBit = co2Input[row].filter { $0 == 1 }.count >= co2Input[row].filter { $0 == 0 }.count
            co2Input = co2Input.map { input in
                input.indices.filter { co2Input[row][$0] == (oneBit ? 0 : 1) }
                .map { input[$0] }
            }
        }
        let oxygenString = oxygenInput.reduce(into: "") { partialResult, bit in
            partialResult += "\(bit[0])"
        }
        let co2String = co2Input.reduce(into: "") { partialResult, bit in
            partialResult += "\(bit[0])"
        }
        let oxygen = Int(oxygenString, radix: 2)!
        let co2 = Int(co2String, radix: 2)!
        return "\(oxygen * co2)"
    }
}
