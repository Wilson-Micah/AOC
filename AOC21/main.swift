//
//  main.swift
//  AOC21
//
//  Created by Micah Wilson on 12/3/21.
//

@_exported import Algorithms
import Foundation

//func runAllDays() {
//    let days: [Day] = [
//        Day1(),
//        Day2(),
//        Day3(),
//        Day4(),
//        Day5(),
//        Day6(),
//        Day7(),
//        Day8(),
//        Day9(),
//        Day10(),
//        Day11(),
//        Day12(),
//        Day13(),
//        Day14(),
//        Day15(),
//        Day16(),
//        Day17(),
//        Day18(),
//        Day19(),
//        Day20(),
//        Day21(),
//        Day22(),
//        Day23(),
//        Day24(),
//        Day25()
//    ]
//
//    for day in days {
//        let startDate = Date()
//        let part1 = day.part1()
//        let part2 = day.part2()
//
//        print("Part 1:", part1)
//        print("Part 2:", part2)
//        print("Completed in", Date().timeIntervalSince(startDate))
//    }
//}
//
//runAllDays()

let startDate = Date()
let day = Day13()
let part1 = day.part1()
let part2 = day.part2()

print("Part 1:", part1)
print("Part 2:", part2)
print("Completed in", Date().timeIntervalSince(startDate))
