//
//  Day13.swift
//  AOC21
//
//  Created by Micah Wilson on 12/11/21.
//

import Foundation

struct Day13: Day {
    enum Fold {
        case x(Int)
        case y(Int)
    }
    
    func fold(points: inout [Point], fold: String) {
        let index = Int(fold.components(separatedBy: "=")[1])!
        if fold.contains("x") {
            for pointIndex in points.indices {
                if points[pointIndex].x > index {
                    points[pointIndex].x -= (points[pointIndex].x - index) * 2
                }
            }
        } else {
            for pointIndex in points.indices {
                if points[pointIndex].y > index {
                    points[pointIndex].y -= (points[pointIndex].y - index) * 2
                }
            }
        }
        points = Array(Set(points))
    }
    
    func part1() -> String {
        let input = input.components(separatedBy: "\n\n")
        let fold = input[1].lines[0]
        var points = input[0].lines.map { line -> Point in
            let points = line.commas.ints
            return Point(x: points.first!, y: points.last!)
        }
        
        self.fold(points: &points, fold: fold)
        
        return "\(points.count)"
    }
    
    func part2() -> String {
        let input = input.components(separatedBy: "\n\n")
        let folds = input[1].lines
        var points = input[0].lines.map { line -> Point in
            let points = line.commas.ints
            return Point(x: points.first!, y: points.last!)
        }
        
        for fold in folds {
            self.fold(points: &points, fold: fold)
        }
        
        let (minY, maxY) = points.map(\.y).minAndMax()!
        let (minX, maxX) = points.map(\.x).minAndMax()!
        let uniquePoints = Set(points)
        
        var message = ""
        for y in minY...maxY {
            for x in minX...maxX {
                if uniquePoints.contains(.init(x: x, y: y)) {
                    message += "*"
                } else {
                    message += " "
                }
            }
            message += "\n"
        }
        
        return "See Message: \n\n\(message)"
    }
}
