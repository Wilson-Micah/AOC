//
//  2021-Day23.swift
//  AOC
//
//  Created by Micah Wilson on 12/22/21.
//

import Algorithms
import Foundation

extension AOC21 {
    struct Amphipod {
        enum AmphipodType: String {
            case a = "A"
            case b = "B"
            case c = "C"
            case d = "D"
            
            var energy: Int {
                switch self {
                case .a:
                    return 1
                case .b:
                    return 10
                case .c:
                    return 100
                case .d:
                    return 1000
                }
            }
            
            var correctRoom: Int {
                switch self {
                case .a:
                    return 0
                case .b:
                    return 1
                case .c:
                    return 2
                case .d:
                    return 3
                }
            }
        }
        var type: AmphipodType
        var position: Point
        
        var room: Int? {
            if position.x == 3 {
                return 0
            } else if position.x == 5 {
                return 1
            } else if position.x == 7 {
                return 2
            } else if position.x == 9 {
                return 3
            }
            return nil
        }
        
        var topOfRoom: Bool {
            position.y == 1
        }
        
        var bottomOfRoom: Bool {
            position.y == 2
        }
        
        var inCorrectRoom: Bool {
            type.correctRoom == room
        }
        
        var inHallway: Bool {
            position.y == 0
        }
    }
    /*
     #############
     #...........#
     ###B#D#C#A###
       #C#D#B#A#
       #########
     */
    struct Day23: Day {
        func part1() -> String {
            let grid = input.lines.map {
                Array($0).map(String.init)
            }
            let energyConsumed = shortestPath(grid)
            return "\(energyConsumed)"
        }
        
        func part2() -> String {
            let insertion = """
  #D#C#B#A#
  #D#B#A#C#
"""
            let lines = Array(input.lines.dropLast(2)) + insertion.lines + Array(input.lines.dropFirst(3))
            let grid = lines.map {
                Array($0).map(String.init)
            }
            let energyConsumed = shortestPath(grid)
            return "\(energyConsumed)"
        }
        
        struct DiagramState: Hashable {
            let diagram: [[String]]
            var energy = 0
            
            var movements: [DiagramState] {
                var movements = [DiagramState]()
                for hallwayPosition in occupiedHallwayIndexes {
                    let value = diagram[hallwayPosition.y][hallwayPosition.x]
                    guard let (point, energy) = canMove(from: hallwayPosition, to: .init(x: Self.caveXMap[value]!, y: diagram.count-2)) else { continue }
                    var diagram = diagram
                    diagram[hallwayPosition.y][hallwayPosition.x] = "."
                    diagram[point.y][point.x] = value
                    movements.append(.init(diagram: diagram, energy: energy + self.energy))
                }
                
                for i in (Self.hallwayYIndex + 1)..<(diagram.count-1) {
                    for cave in Self.caveXIndexes where diagram[i][cave] != "." && !isValidPosition(point: .init(x: cave, y: i)) {
                        for hallwayPosition in Self.validSittingXIndexes {
                            guard let (point, energy) = canMove(from: .init(x: cave, y: i), to: .init(x: hallwayPosition, y: Self.hallwayYIndex)) else { continue }
                            var diagram = diagram
                            diagram[point.y][point.x] = diagram[i][cave]
                            diagram[i][cave] = "."
                            movements.append(.init(diagram: diagram, energy: energy + self.energy))
                        }
                    }
                }
                
                return movements
            }
            
            var occupiedHallwayIndexes: [Point] {
                var points = [Point]()
                for x in Self.validSittingXIndexes where diagram[Self.hallwayYIndex][x] != "." {
                    points.append(.init(x: x, y: Self.hallwayYIndex))
                }
                return points
            }
            
            /// Returns energy consumed or nil if not possible.
            func canMove(from: Point, to: Point) -> (Point, Int)? {
                if from.y == Self.hallwayYIndex {
                    for xHallway in Self.validSittingXIndexes.filter({ ($0 > from.x && $0 < to.x) || ($0 < from.x && $0 > to.x) }) {
                        if diagram[Self.hallwayYIndex][xHallway] != "." {
                            return nil
                        }
                    }
                    
                    for y in ((Self.hallwayYIndex + 1)..<(diagram.count-1)).reversed() {
                        if diagram[y][to.x] == "." {
                            return (.init(x: to.x, y: y), energyConsumtion(from: from, to: .init(x: to.x, y: y)))
                        } else if diagram[y][to.x] == diagram[from.y][from.x] {
                            continue
                        } else {
                            return nil
                        }
                    }
                } else if diagram[from.y-1][from.x] == "." {
                    for xHallway in Self.validSittingXIndexes.filter({ ($0 >= from.x && $0 <= to.x) || ($0 <= from.x && $0 >= to.x) }) {
                        if diagram[Self.hallwayYIndex][xHallway] != "." {
                            return nil
                        }
                    }
                    
                    return (to, energyConsumtion(from: from, to: to))
                }
                
                return nil
            }
            
            func isValidPosition(point: Point) -> Bool {
                if Self.caveMap[point.x] != diagram[point.y][point.x] {
                    return false
                }
                
                for y in ((point.y)..<(diagram.count-1)) {
                    if diagram[y][point.x] != Self.caveMap[point.x] {
                        return false
                    }
                }
                
                return true
            }
            
            func energyConsumtion(from: Point, to: Point) -> Int {
                let value = diagram[from.y][from.x]
                let distance = abs(to.y - from.y) + abs(to.x - from.x)
                return Self.consumptionMap[value]! * distance
            }
            
            var isCompleted: Bool {
                for i in (Self.hallwayYIndex + 1)..<(diagram.count-1) {
                    for cave in Self.caveXIndexes {
                        if diagram[i][cave] != Self.caveMap[cave] {
                            return false
                        }
                    }
                }
                return true
            }
            
            static var validSittingXIndexes: [Int] {
                return [1, 2, 4, 6, 8, 10, 11]
            }
            
            static var hallwayYIndex: Int {
                1
            }
            
            static var caveXIndexes: [Int] {
                [3, 5, 7, 9]
            }
            
            static var caveXMap: [String: Int] {
                ["A": 3, "B": 5, "C": 7, "D": 9]
            }
            
            static var caveMap: [Int: String] {
                [3: "A", 5: "B", 7: "C", 9: "D"]
            }
            
            static var consumptionMap: [String: Int] {
                ["A": 1, "B": 10, "C": 100, "D": 1000]
            }
            
            func printDiagram() {
                var string = ""
                for col in diagram {
                    for row in col {
                        string += row
                    }
                    string += "\n"
                }
                print(string)
            }
        }
        
        func shortestPath(_ diagram: [[String]]) -> Int {
            var seen = Set<[[String]]>()
            var queue = Heap(array: [DiagramState(diagram: diagram)], sort: { $0.energy < $1.energy })
            while !queue.isEmpty {
                let diagramState = queue.peek()!
                queue.remove()
                if diagramState.isCompleted {
                    return diagramState.energy
                }
                
                if seen.contains(diagramState.diagram) {
                    continue
                }
                
                seen.insert(diagramState.diagram)
                
                for movement in diagramState.movements where !seen.contains(movement.diagram) {
                    queue.insert(movement)
                }
            }
            
            return 0
        }
    }
}
