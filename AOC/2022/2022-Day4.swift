//
//  2022-Day4.swift
//  AOC
//
//  Created by Micah Wilson on 12/4/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day4: Day {
        var sections: [(Set<Int>, Set<Int>)] {
            input.lines
                .map { line -> (Set<Int>, Set<Int>) in
                    let jobs = line.commas
                    let section1 = jobs[0].dashes
                    let section2 = jobs[1].dashes
                    return (Set(Int(section1[0])!...Int(section1[1])!), Set(Int(section2[0])!...Int(section2[1])!))
                }
        }
        
        func part1() -> String {
            let contains = sections.reduce(into: 0) { partialResult, job in
                partialResult += (job.0.isSubset(of: job.1) || job.1.isSubset(of: job.0) ? 1 : 0)
            }
            
            return "\(contains)"
        }
        
        func part2() -> String {
            let overlaps = sections.reduce(into: 0) { partialResult, job in
                partialResult += (job.0.intersection(job.1).isEmpty ? 0 : 1)
            }
            
            return "\(overlaps)"
        }
    }
}
