//
//  2022-Day20.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day20: Day {
        func part1() -> String {
            let data = Array(input.lines.ints.enumerated())
            var mixedData = data
            for i in data {
                guard let mixedIndex = mixedData.firstIndex(where: { $0.element == i.element && $0.offset == i.offset }) else { continue }
                
                let value = mixedData.remove(at: mixedIndex)
                var newIndex = (mixedIndex + value.element) % mixedData.count
                if newIndex < 0 {
                    newIndex = mixedData.count + newIndex
                }
                mixedData.insert(value, at: newIndex)
            }
            
            let zeroIndex = mixedData.firstIndex(where: { $0.element == 0 })!
            let result = [
                mixedData[(zeroIndex + 1000) % mixedData.count],
                mixedData[(zeroIndex + 2000) % mixedData.count],
                mixedData[(zeroIndex + 3000) % mixedData.count]
            ].map(\.element)

            return "\(result.reduce(into: 0, +=))"
        }
        
        func part2() -> String {
            let data = Array(input.lines.ints.map { $0 * 811589153 }.enumerated())
            var mixedData = data
            for _ in 0..<10 {
                for i in data {
                    guard let mixedIndex = mixedData.firstIndex(where: { $0.element == i.element && $0.offset == i.offset }) else { continue }
                    
                    let value = mixedData.remove(at: mixedIndex)
                    var newIndex = (mixedIndex + value.element) % mixedData.count
                    if newIndex < 0 {
                        newIndex = mixedData.count + newIndex
                    }
                    mixedData.insert(value, at: newIndex)
                }
            }
            
            let zeroIndex = mixedData.firstIndex(where: { $0.element == 0 })!
            let result = [
                mixedData[(zeroIndex + 1000) % mixedData.count],
                mixedData[(zeroIndex + 2000) % mixedData.count],
                mixedData[(zeroIndex + 3000) % mixedData.count]
            ].map(\.element)

            return "\(result.reduce(into: 0, +=))"
        }
    }
}
