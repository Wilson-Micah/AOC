//
//  2020-Day5.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day5: Day {
        struct Seat {
            let row: Int
            let column: Int
            var id: Int { row * 8 + column }
            
            static let rows = 127
            static let columns = 7
        }
        
        var seats: [Seat] {
            input.lines.map { line in
                let data = Array(line)
                let rowBinary = data.dropLast(3)
                let columnBinary = data.dropFirst(7)
                
                var rowRange = 0...Seat.rows
                for binary in rowBinary {
                    if binary == "F" {
                        rowRange = rowRange.lowerBound...((rowRange.lowerBound + rowRange.upperBound) / 2)
                    } else {
                        rowRange = (Int(ceil(Double(rowRange.lowerBound + rowRange.upperBound) / 2)))...rowRange.upperBound
                    }
                }
                
                var columnRange = 0...Seat.columns
                for binary in columnBinary {
                    if binary == "L" {
                        columnRange = columnRange.lowerBound...((columnRange.lowerBound + columnRange.upperBound) / 2)
                    } else {
                        columnRange = (Int(ceil(Double(columnRange.lowerBound + columnRange.upperBound) / 2)))...columnRange.upperBound
                    }
                }
                
                return Seat(row: rowRange.lowerBound, column: columnRange.lowerBound)
            }
        }
        
        func part1() -> String {
            let result = seats.map(\.id).max()!
            return "\(result)"
        }
        
        func part2() -> String {
            let seats = seats
            let seatMap = seats.reduce(into: [Int: Seat]()) { partialResult, seat in
                partialResult[seat.id] = seat
            }
            let ids = seatMap.keys.minAndMax()!
            let seatID = (ids.min...ids.max).first { id -> Bool in
                seatMap[id - 1] != nil && seatMap[id + 1] != nil && seatMap[id] == nil
            }!
            
            return "\(seatID)"
        }
    }
}
