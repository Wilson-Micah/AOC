//
//  2022-Day23.swift
//  AOC
//
//  Created by Micah Wilson on 12/23/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day23: Day {
        
        func moveElves(elves: Set<Point>, index: inout Int) -> Set<Point> {
            var elvesToMove = elves.filter { elf in
                elf.adjacent.contains { adjacent in
                    elves.contains(adjacent)
                }
            }
            var elvesToStay = elves.subtracting(elvesToMove)
            var proposals = [Point: [Point]]()
            var movedElves = Set<Point>()
        testing: for elf in elvesToMove {
            for var i in index..<(index + 4) {
                i %= 4
                switch i {
                case 0:
                    if !elf.northish.contains(where: { elves.contains($0) }) {
                        proposals[.init(x: elf.x, y: elf.y - 1), default: []].append(elf)
                        continue testing
                    }
                case 1:
                    if !elf.southish.contains(where: { elves.contains($0) }) {
                        proposals[.init(x: elf.x, y: elf.y + 1), default: []].append(elf)
                        continue testing
                    }
                case 2:
                    if !elf.westish.contains(where: { elves.contains($0) }) {
                        proposals[.init(x: elf.x - 1, y: elf.y), default: []].append(elf)
                        continue testing
                    }
                case 3:
                    if !elf.eastish.contains(where: { elves.contains($0) }) {
                        proposals[.init(x: elf.x + 1, y: elf.y), default: []].append(elf)
                        continue testing
                    }
                default: break
                }
            }
            elvesToStay.insert(elf)
        }
            
            for proposal in proposals {
                if proposal.value.count == 1 {
                    movedElves.insert(proposal.key)
                } else {
                    proposal.value.forEach {
                        movedElves.insert($0)
                    }
                }
            }
            
            index = (index + 1) % 4
            
            return elvesToStay.union(movedElves)
        }
        
        func part1() -> String {
            let grid = input.gridNoSeparatorStrings
            var elves = Set<Point>()
            grid.traverse { point in
                if grid[point.x][point.y] == "#" {
                    elves.insert(.init(x: point.y, y: point.x))
                }
            }
            
            var index = 0
            var newElves = moveElves(elves: elves, index: &index)
            for _ in 0..<9 {
                newElves = moveElves(elves: newElves, index: &index)
            }
            
            let minX = newElves.map(\.x).min()!
            let maxX = newElves.map(\.x).max()!
            let minY = newElves.map(\.y).min()!
            let maxY = newElves.map(\.y).max()!
            
            return "\((maxX - minX + 1) * (maxY - minY + 1) - newElves.count)"
        }
        
        func part2() -> String {
            let grid = input.gridNoSeparatorStrings
            var elves = Set<Point>()
            grid.traverse { point in
                if grid[point.x][point.y] == "#" {
                    elves.insert(.init(x: point.y, y: point.x))
                }
            }
            
            var index = 0
            var newElves = moveElves(elves: elves, index: &index)
            var count = 1
            while newElves != elves {
                elves = newElves
                newElves = moveElves(elves: elves, index: &index)
                count += 1
            }

            return "\(count)"
        }
    }
}
