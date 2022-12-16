//
//  main.swift
//  AOC21
//
//  Created by Micah Wilson on 12/3/21.
//

import Foundation

func runAllDays() {
    let days: [Day] = [
        AOC21.Day1(),
        AOC21.Day2(),
        AOC21.Day3(),
        AOC21.Day4(),
        AOC21.Day5(),
        AOC21.Day6(),
        AOC21.Day7(),
        AOC21.Day8(),
        AOC21.Day9(),
        AOC21.Day10(),
        AOC21.Day11(),
        AOC21.Day12(),
        AOC21.Day13(),
        AOC21.Day14(),
        AOC21.Day15(),
        AOC21.Day16(),
        AOC21.Day17(),
        AOC21.Day18(),
        AOC21.Day19(),
        AOC21.Day20(),
        AOC21.Day21(),
        AOC21.Day22(),
        AOC21.Day23(),
        AOC21.Day24(),
        AOC21.Day25()
    ]

    let overallDate = Date()
    for day in days {
        let startDate = Date()
        let part1 = day.part1()
        let part2 = day.part2()

        print("Part 1:", part1)
        print("Part 2:", part2)
        print("Completed in", Date().timeIntervalSince(startDate))
    }
    print("Completed all days in", Date().timeIntervalSince(overallDate))
}

//runAllDays()

let startDate = Date()
let day = AOC20.Day19()
let part1 = day.part1()
let part2 = day.part2()

print("Part 1:", part1)
print("Part 2:", part2)
print("Completed in", Date().timeIntervalSince(startDate))
