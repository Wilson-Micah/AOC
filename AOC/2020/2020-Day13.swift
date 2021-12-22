//
//  2020-Day13.swift
//  AOC
//
//  Created by Micah Wilson on 12/21/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day13: Day {
        func part1() -> String {
            let input = input.lines
            let arrivalTime = Int(input[0])!
            let buses = input[1].replacingOccurrences(of: ",x", with: "").commas.ints
            
            let offsets = buses.reduce(into: [Int: Int]()) { partialResult, bus in
                partialResult[bus] = bus - (arrivalTime % bus)
            }
            let (id, offset) = offsets.min(by: { $0.value < $1.value })!
            
            return "\(id * offset)"
        }
        
        func part2() -> String {
            let buses = input.lines[1].commas.optionalInts
            var found = false
            var interval = buses[0]!
            var timestamp = 0
            var busesFound = [Set([0]): 0]
            var busesIntervals = [Set([0]): buses[0]]
            var scannedGroups = Set([[0]])

            while !found {
                let foundIndexes = buses.indices.filter { i in
                    guard let value = buses[i] else { return false }
                    return (timestamp + i) % (value) == 0
                }
                
                if !scannedGroups.contains(foundIndexes), let found = busesFound[Set(foundIndexes)] {
                    busesIntervals[Set(foundIndexes)] = timestamp - found
                    interval = max(timestamp - found, interval)
                    scannedGroups.insert(foundIndexes)
                } else {
                    busesFound[Set(foundIndexes)] = timestamp
                }
                
                if buses.indices.allSatisfy({ (timestamp + $0) % (buses[$0] ?? 1) == 0 }) {
                    found = true
                } else {
                    timestamp += interval
                }
            }
            
            return "\(timestamp)"
        }
    }
}
