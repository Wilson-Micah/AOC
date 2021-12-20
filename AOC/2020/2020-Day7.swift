//
//  2020-Day7.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day7: Day {
        var bags: [String: [(count: Int, bagName: String)]] {
            var data = [String: [(count: Int, bagName: String)]]()
            let input = input.lines
            for line in input {
                let components = line.components(separatedBy: " contain ")
                let name = components[0]
                let bags = components[1].replacingOccurrences(of: ".", with: "")
                let bagComponents = bags.components(separatedBy: ", ")
                let counts = bagComponents.compactMap { component -> (count: Int, bagName: String)? in
                    let details = component.spaces
                    guard let count = Int(details[0]) else { return nil }
                    let name = details.dropFirst().joined(separator: " ")
                    return (count: count, bagName: name.last == "s" ? name : name + "s")
                }
                data[name] = counts
            }
            return data
        }
        
        func part1() -> String {
            let bags = bags
            var goldBagHolder = 0
            for bag in bags {
                var queue = bag.value
                while !queue.isEmpty {
                    let bag = queue.removeFirst()
                    if bag.bagName == "shiny gold bags" {
                        goldBagHolder += 1
                        queue.removeAll()
                    } else {
                        queue.append(contentsOf: bags[bag.bagName].flatMap { $0 } ?? [])
                    }
                }
            }
            return "\(goldBagHolder)"
        }
        
        func part2() -> String {
            let bags = bags
            var goldBagHolder = 0
            var queue = bags["shiny gold bags"]!
            while !queue.isEmpty {
                let bag = queue.removeFirst()
                goldBagHolder += bag.count
                let bagContents = bags[bag.bagName]
                    .flatMap { $0 }?
                    .map { contents in
                        return (count: contents.count * bag.count, bagName: contents.bagName)
                    } ?? []
                queue.append(contentsOf: bagContents)
            }
            return "\(goldBagHolder)"
        }
    }
}
