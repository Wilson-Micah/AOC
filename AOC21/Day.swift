//
//  Day.swift
//  AOC21
//
//  Created by Micah Wilson on 12/3/21.
//

import Foundation

protocol Day {
    var input: String { get }
    var example: String { get }
    
    func part1() -> String
    func part2() -> String
}

extension Day {
    var input: String {
        let data = FileManager.default.contents(atPath: "/Users/micah/Projects/AOC21/\(type(of: self))-input.txt")!
        let input = String(data: data, encoding: .utf8)!
        return input
    }
    
    var example: String {
        let data = FileManager.default.contents(atPath: "/Users/micah/Projects/AOC21/example.txt")!
        let input = String(data: data, encoding: .utf8)!
        return input
    }
}

public extension String {
    var lines: [String] {
        components(separatedBy: .newlines)
    }
    
    var linesAndSpaces: [String] {
        components(separatedBy: .whitespacesAndNewlines)
    }
    
    var spaces: [String] {
        components(separatedBy: .whitespaces)
    }
    
    var commas: [String] {
        components(separatedBy: ",")
    }
    
    var columns: [[String]] {
        let lines = components(separatedBy: .newlines)
        return (lines[0].indices).reduce(into: [[String]]()) { partialResult, index in
            partialResult.append(lines.map { String($0[index]) })
        }
    }
    
    var gridNoSeparator: [[Int]] {
        self.components(separatedBy: .newlines)
            .map {
                Array($0)
            }
            .map { row in
                row.map { Int(String($0))! }
            }
    }
}

public extension Collection where Element == String {
    var ints: [Int] {
        compactMap { Int($0) }
    }
    
    var doubles: [Double] {
        compactMap { Double($0) }
    }
}
