//
//  2022-Day16.swift
//  AOC
//
//  Created by Micah Wilson on 12/16/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day16: Day {
        struct Pipe: Hashable {
            let id: String
            let flowRate: Int
            let valves: [String]
            var distanceToPipe = [String: Int]()
        }
        
        func shortestDistance(pipes: [String: Pipe], from: Pipe, to: Pipe) -> Int {
            var seen = Set<Pipe>()
            var queue = Heap(array: [(from, 0)], sort: { $0.1 < $1.1 })
            var count = 0
            while !queue.isEmpty {
                count += 1
                let (pipe, distance) = queue.peek()!
                queue.remove()
                if pipe == to {
                    return distance
                }
                
                if seen.contains(pipe) {
                    continue
                }
                
                seen.insert(pipe)
                
                for valve in pipe.valves {
                    queue.insert((pipes[valve]!, distance + 1))
                }
            }
            return -1
        }
        
        func findMaximalFlow(pipes: inout [String: Pipe], current: String, seen: Set<String>, minute: Int, pressure: Int) -> Int {
            var pressure = pressure
            var minute = minute
            var seen = seen
            guard let pipe = pipes[current] else { return -1 }
            
            if minute >= 30 {
                return pressure
            }
            
            if pipe.flowRate > 0 {
                minute += 1
                pressure += (30 - minute) * pipe.flowRate
                seen.insert(pipe.id)
            }
            
            let pipesToSee = pipe.distanceToPipe
                .filter { !seen.contains($0.key) }
            if let max = pipesToSee.map({ findMaximalFlow(pipes: &pipes, current: $0.key, seen: seen, minute: minute + $0.value, pressure: pressure) }).max() {
                return max
            } else {
                return pressure
            }
        }
        
        func part1() -> String {
            let pipes = input.lines.map {
                let components = $0.spaces
                return Pipe(
                    id: components[1],
                    flowRate: Int(components[4].components(separatedBy: "rate=")[1].dropLast())!,
                    valves: components[9..<components.count].joined().commas
                )
            }
            
            let importantPipes = pipes.filter { $0.flowRate > 0 }
            
            var pipeMap = pipes.reduce(into: [String: Pipe]()) { partialResult, pipe in
                partialResult[pipe.id] = pipe
            }
            
            var modifiedPipes = pipes
            for p in pipes.indexed() {
                for important in importantPipes where important != p.element {
                    modifiedPipes[p.index].distanceToPipe[important.id] = shortestDistance(pipes: pipeMap, from: p.element, to: important)
                }
            }
            
            pipeMap = modifiedPipes.reduce(into: [String: Pipe]()) { partialResult, pipe in
                partialResult[pipe.id] = pipe
            }
            
            let maxPressure = findMaximalFlow(pipes: &pipeMap, current: "AA", seen: [], minute: 0, pressure: 0)
            
            return "\(maxPressure)"
        }
        
        func part2() -> String {
            let originalPipes = input.lines.map {
                let components = $0.spaces
                return Pipe(
                    id: components[1],
                    flowRate: Int(components[4].components(separatedBy: "rate=")[1].dropLast())!,
                    valves: components[9..<components.count].joined().commas
                )
            }
            
            let importantPipes = originalPipes.filter { $0.flowRate > 0 }
            let importantPipeCombinations = importantPipes.combinations(ofCount: importantPipes.count / 2)
            let pipeSet = Set(importantPipes)
            let maxPressure = importantPipeCombinations.map { pipes in
                let elephant = pipes
                let person = pipeSet.subtracting(Set(pipes))
                
                var elephantMap = originalPipes.reduce(into: [String: Pipe]()) { partialResult, pipe in
                    partialResult[pipe.id] = pipe
                }
                
                var modifiedPipes = originalPipes
                for p in originalPipes.indexed() {
                    for important in elephant where important != p.element {
                        modifiedPipes[p.index].distanceToPipe[important.id] = shortestDistance(pipes: elephantMap, from: p.element, to: important)
                    }
                }
                
                elephantMap = modifiedPipes.reduce(into: [String: Pipe]()) { partialResult, pipe in
                    partialResult[pipe.id] = pipe
                }
                
                var personMap = originalPipes.reduce(into: [String: Pipe]()) { partialResult, pipe in
                    partialResult[pipe.id] = pipe
                }
                
                modifiedPipes = originalPipes
                for p in originalPipes.indexed() {
                    for important in person where important != p.element {
                        modifiedPipes[p.index].distanceToPipe[important.id] = shortestDistance(pipes: personMap, from: p.element, to: important)
                    }
                }
                
                personMap = modifiedPipes.reduce(into: [String: Pipe]()) { partialResult, pipe in
                    partialResult[pipe.id] = pipe
                }
                
                let maxPressure = findMaximalFlow(pipes: &personMap, current: "AA", seen: [], minute: 4, pressure: 0) + findMaximalFlow(pipes: &elephantMap, current: "AA", seen: [], minute: 4, pressure: 0)
                return maxPressure
            }
            .max()!
            
            return "\(maxPressure)"
        }
    }
}
