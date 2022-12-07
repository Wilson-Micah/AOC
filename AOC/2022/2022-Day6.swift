//
//  2022-Day6.swift
//  AOC
//
//  Created by Micah Wilson on 12/5/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day6: Day {
        func findPacket(of length: Int) -> String {
            let index = Array(input.windows(ofCount: length)).firstIndex(where: { Set($0).count == length })! + length
            return "\(index)"
        }
        
        func part1() -> String {
            return findPacket(of: 4)
        }
        
        func part2() -> String {
            return findPacket(of: 14)
        }
    }
}
