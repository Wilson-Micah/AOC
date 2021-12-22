//
//  2020-Day12.swift
//  AOC
//
//  Created by Micah Wilson on 12/21/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day12: Day {
        enum Direction {
            case east
            case north
            case south
            case west
            
            mutating func turnLeft() {
                switch self {
                case .east:
                    self = .north
                case .north:
                    self = .west
                case .west:
                    self = .south
                case .south:
                    self = .east
                }
            }
            
            mutating func turnRight() {
                switch self {
                case .east:
                    self = .south
                case .north:
                    self = .east
                case .west:
                    self = .north
                case .south:
                    self = .west
                }
            }
        }
        
        struct Ship {
            var position = Point(x: 0, y: 0)
            var direction = Direction.east
            var waypoint = Point(x: 10, y: 1)
            
            mutating func move(amount: Int) {
                switch direction {
                case .east:
                    position.x += amount
                case .north:
                    position.y += amount
                case .south:
                    position.y -= amount
                case .west:
                    position.x -= amount
                }
            }
            
            mutating func moveTowardsWaypoint(amount: Int) {
                position.x += waypoint.x * amount
                position.y += waypoint.y * amount
            }
            
            mutating func advanceWaypoint(direction: Direction, amount: Int) {
                switch direction {
                case .east:
                    waypoint.x += amount
                case .north:
                    waypoint.y += amount
                case .south:
                    waypoint.y -= amount
                case .west:
                    waypoint.x -= amount
                }
            }
            
            mutating func turnWaypointLeft() {
                waypoint = .init(x: -waypoint.y, y: waypoint.x)
            }
            
            mutating func turnWaypointRight() {
                waypoint = .init(x: waypoint.y, y: -waypoint.x)
            }
        }
        
        func part1() -> String {
            let input = input.lines
            var ship = Ship()
            for var input in input {
                let command = input.removeFirst()
                let value = Int(input)!
                switch command {
                case "N":
                    ship.position.y += value
                case "S":
                    ship.position.y -= value
                case "E":
                    ship.position.x += value
                case "W":
                    ship.position.x -= value
                case "L":
                    for _ in 0..<value / 90 {
                        ship.direction.turnLeft()
                    }
                case "R":
                    for _ in 0..<value / 90 {
                        ship.direction.turnRight()
                    }
                case "F":
                    ship.move(amount: value)
                default: break
                }
            }
            
            return "\(abs(ship.position.x) + abs(ship.position.y))"
        }
        
        func part2() -> String {
            let input = input.lines
            var ship = Ship()
            for var input in input {
                let command = input.removeFirst()
                let value = Int(input)!
                switch command {
                case "N":
                    ship.advanceWaypoint(direction: .north, amount: value)
                case "S":
                    ship.advanceWaypoint(direction: .south, amount: value)
                case "E":
                    ship.advanceWaypoint(direction: .east, amount: value)
                case "W":
                    ship.advanceWaypoint(direction: .west, amount: value)
                case "L":
                    for _ in 0..<value / 90 {
                        ship.turnWaypointLeft()
                    }
                case "R":
                    for _ in 0..<value / 90 {
                        ship.turnWaypointRight()
                    }
                case "F":
                    ship.moveTowardsWaypoint(amount: value)
                default: break
                }
            }
            
            return "\(abs(ship.position.x) + abs(ship.position.y))"
        }
    }
}
