//
//  Day17.swift
//  AOC21
//
//  Created by Micah Wilson on 12/16/21.
//

import Algorithms
import Foundation

struct Day17: Day {
    func calculateXDistance(startXVelocity: Int, time: Int) -> Int {
        (startXVelocity * time) - ((time * (time - 1)) / 2)
    }
    
    func calculateYDistance(startYVelocity: Int, time: Int) -> Int {
        (startYVelocity * time) - ((time * (time - 1)) / 2)
    }
    
    func rocketWillFallIntoTarget(
        time: Int,
        startYVelocity: Int,
        yTarget: Set<Int>
    ) -> Bool {
        var time = time
        var yPos = Int.max
        while yPos > yTarget.min()! {
            time += 1
            yPos = calculateYDistance(startYVelocity: startYVelocity, time: time)
            
            if yTarget.contains(yPos) {
                return true
            }
        }
        return false
    }
    
    func fire(
        startVelocity: Point,
        xTarget: Set<Int>,
        yTarget: Set<Int>
    ) -> Point? {
        for time in 1...startVelocity.x {
            let xPos = calculateXDistance(startXVelocity: startVelocity.x, time: time)
            let yPos = calculateYDistance(startYVelocity: startVelocity.y, time: time)
            if xTarget.contains(xPos) && yTarget.contains(yPos) {
                return startVelocity
            } else if time == startVelocity.x && yPos >= yTarget.min()! && xTarget.contains(xPos) {
                return rocketWillFallIntoTarget(
                    time: time,
                    startYVelocity: startVelocity.y,
                    yTarget: yTarget
                ) ? startVelocity : nil
            }
            
            if xPos > xTarget.max()! {
                return nil
            }
        }
        
        return nil
    }
    
    var target: Set<Point> {
        let characterSet = CharacterSet.decimalDigits.union(.init(charactersIn: "-"))
        let input = input.components(separatedBy: characterSet.inverted).ints
        var t = Set<Point>()
        for x in input[0]...input[1] {
            for y in input[2]...input[3] {
                t.insert(.init(x: x, y: y))
            }
        }
        return t
    }
    
    func part1() -> String {
        let minY = target.map(\.y).min()!
        return "\(minY * (minY + 1) / 2)"
    }
    
    func part2() -> String {
        let target = target
        let targetX = Set(target.map(\.x))
        let targetY = Set(target.map(\.y))
        let maxX = targetX.max()!
        let minY = targetY.min()!
        var successes = Set<Point>()
        for x in 1...maxX {
            for y in minY..<abs(minY) {
                if fire(startVelocity: .init(x: x, y: y), xTarget: targetX, yTarget: targetY) != nil {
                    successes.insert(.init(x: x, y: y))
                }
            }
        }
        
        return "\(successes.count)"
    }
}
