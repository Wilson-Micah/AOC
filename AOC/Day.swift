//
//  Day.swift
//  AOC21
//
//  Created by Micah Wilson on 12/3/21.
//

import Foundation

struct AOC19 {}
struct AOC20 {}
struct AOC21 {}

protocol Day {
    var input: String { get }
    var example: String { get }
    
    func part1() -> String
    func part2() -> String
}

extension Day {
    private var inputDetails: (directory: String, day: String) {
        let details = String(reflecting: Self.self).components(separatedBy: ".")
        return (directory: details[1], day: details[2])
    }
    
    var input: String {
        let data = FileManager.default.contents(atPath: "/Users/micah/Projects/AOC/\(inputDetails.directory)/\(inputDetails.day)-input.txt")!
        let input = String(data: data, encoding: .utf8)!
        return input
    }
    
    var example: String {
        let data = FileManager.default.contents(atPath: "/Users/micah/Projects/AOC/\(inputDetails.directory)/example.txt")!
        let input = String(data: data, encoding: .utf8)!
        return input
    }
}

public extension String {
    var lines: [String] {
        components(separatedBy: .newlines)
    }
    
    var blankLines: [String] {
        components(separatedBy: "\n\n")
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
        components(separatedBy: .newlines)
            .map {
                Array($0)
            }
            .map { row in
                row.map { Int(String($0))! }
            }
    }
    
    func matchesCharacters(of string: String) -> Bool {
        Set(Array(self)) == Set(Array(string))
    }
    
    func containsCharacters(of string: String) -> Bool {
        Set(Array(self)).union(Array(string)).count == count
    }
    
    var characterCount: [String: Int] {
        Array(self).reduce(into: [String: Int]()) { partialResult, character in
            partialResult[String(character), default: 0] += 1
        }
    }
    
    var hexToBytes: [UInt8] {
        var start = startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let end = index(after: start)
            defer { start = index(after: end) }
            return UInt8(self[start...end], radix: 16)
        }
    }
    
    var hexToBinary: String {
        hexToBytes
            .map {
                let binary = String($0, radix: 2)
                return repeatElement("0", count: 8-binary.count) + binary
            }
            .joined()
    }
}

extension String.Element {
    var closingBacket: String.Element {
        switch self {
        case "(":
            return ")"
        case "[":
            return "]"
        case "{":
            return "}"
        case "<":
            return ">"
        default:
            return " "
        }
    }
    
    var isOpenBracket: Bool {
        switch self {
        case "(",
            "[",
            "{",
            "<":
            return true
        default:
            return false
        }
    }
}

public extension Collection where Element == String {
    var ints: [Int] {
        compactMap { Int($0) }
    }
    
    var optionalInts: [Int?] {
        map { Int($0) }
    }
    
    var doubles: [Double] {
        compactMap { Double($0) }
    }
}

extension Int {
    var triangleNumber: Self {
        ((self + 1) * self) / 2
    }
}

extension Array where Element == [String] {
    func printGrid() {
        var string = ""
        for col in self[0].indices {
            for row in self.indices {
                string += self[row][col]
            }
            string += "\n"
        }
        print(string)
    }
}

extension Array where Element: Collection, Element.Index == Int, Element.Element: Hashable {
    func count(of: Element.Element) -> Int {
        var count = 0
        traverse { point in
            count += self[point.x][point.y] == of ? 1 : 0
        }
        return count
    }
    
    func traverse(indexPath: (Point) -> Void) {
        for col in self.indices {
            for row in self[col].indices {
                indexPath(Point(x: col, y: row))
            }
        }
    }
    
    func traverseAdjacent(point: Point, value: (Element.Element?) -> Void) {
        point.adjacent.forEach { point in
            if point.x < 0 || point.y < 0 || point.x >= self.count || point.y >= self[0].count {
                value(nil)
            } else {
                value(self[point.x][point.y])
            }
        }
    }
    
    func traverseAdjacentIncludingSelf(point: Point, value: (Element.Element?) -> Void) {
        point.adjacentInclusive.forEach { point in
            if point.x < 0 || point.y < 0 || point.x >= self.count || point.y >= self[0].count {
                value(nil)
            } else {
                value(self[point.x][point.y])
            }
        }
    }
    
    func traverseNeighbors(point: Point, value: (Element.Element?) -> Void) {
        point.neighbors.forEach { point in
            if point.x < 0 || point.y < 0 || point.x >= self.count || point.y >= self[0].count {
                value(nil)
            } else {
                value(self[point.x][point.y])
            }
        }
    }
    
    func traverseNeighborsIncludingSelf(point: Point, value: (Element.Element?) -> Void) {
        point.neighborsInclusive.forEach { point in
            if point.x < 0 || point.y < 0 || point.x >= self.count || point.y >= self[0].count {
                value(nil)
            } else {
                value(self[point.x][point.y])
            }
        }
    }
    
    func traverseAdjacentInSight(point: Point, query: Set<Element.Element>, value: (Element.Element, Point) -> Void) {
        point.adjacent.forEach { p in
            var pos = p
            var found = false
            while !found {
                if pos.x < 0 || pos.y < 0 || pos.x >= self.count || pos.y >= self[0].count {
                    found = true
                } else if query.contains(self[pos.x][pos.y]) {
                    value(self[pos.x][pos.y], pos)
                    found = true
                } else {
                    pos.x += pos.x < point.x ? -1 : 0
                    pos.x += pos.x > point.x ? 1 : 0
                    pos.y += pos.y < point.y ? -1 : 0
                    pos.y += pos.y > point.y ? 1 : 0
                }
            }
        }
    }
}

extension Array where Element == [Int] {
    func shortestPath(start: Point, end: Point) -> Int {
        dijkstras(start: start, end: end)
    }
    
    func dijkstras(start: Point, end: Point) -> Int {
        var seen = Set<Point>()
        var queue = Heap(array: [(start, 0)], sort: { $0.1 < $1.1 })
        var count = 0
        while !queue.isEmpty {
            count += 1
            let (pos, distance) = queue.peek()!
            queue.remove()
            if pos == end {
                return distance
            }
            
            if seen.contains(pos) {
                continue
            }
            
            seen.insert(pos)
            
            if pos.x > 0, !seen.contains(.init(x: pos.x - 1, y: pos.y)) {
                queue.insert((Point(x: pos.x - 1, y: pos.y), distance + self[pos.x - 1][pos.y]))
            }
            
            if pos.y > 0, !seen.contains(.init(x: pos.x, y: pos.y - 1)) {
                queue.insert((Point(x: pos.x, y: pos.y - 1), distance + self[pos.x][pos.y - 1]))
            }
            
            if pos.x < self.count - 1, !seen.contains(.init(x: pos.x + 1, y: pos.y)) {
                queue.insert((Point(x: pos.x + 1, y: pos.y), distance + self[pos.x + 1][pos.y]))
            }
            
            if pos.y < self.last!.count - 1, !seen.contains(.init(x: pos.x, y: pos.y + 1)) {
                queue.insert((Point(x: pos.x, y: pos.y + 1), distance + self[pos.x][pos.y + 1]))
            }
        }
        
        return 0
    }
}
