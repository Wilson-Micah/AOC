//
//  2020-Day16.swift
//  AOC
//
//  Created by Micah Wilson on 12/11/22.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day16: Day {
        struct TicketField {
            let name: String
            let validValues: Set<Int>
        }
        
        func part1() -> String {
            let data = input.blankLines
            let dataFields = data[0].lines.map { line in
                return line.components(separatedBy: ": ")[1].components(separatedBy: " or ").map { range in
                    let components = range.dashes.compactMap(Int.init)
                    return Set(components[0]...components[1])
                }
            }
                .flatMap { $0 }
                .reduce(into: Set<Int>()) { partialResult, range in
                    partialResult.formUnion(range)
                }
            
            var invalidData = [Int]()
            for ticket in data[2].lines.dropFirst() {
                for number in ticket.commas.ints {
                    if !dataFields.contains(number) {
                        invalidData.append(number)
                    }
                }
            }
            
            return "\(invalidData.reduce(into: 0, +=))"
        }
        
        func part2() -> String {
            let data = input.blankLines
            let dataFields = data[0].lines.map { line in
                let components = line.components(separatedBy: ": ")
                let name = components[0]
                return TicketField(
                    name: name,
                    validValues: components[1].components(separatedBy: " or ").map { range in
                        let components = range.dashes.compactMap(Int.init)
                        return Set(components[0]...components[1])
                    }.reduce(into: Set<Int>()) { partialResult, range in
                        partialResult = partialResult.union(range)
                    }
                )
            }
            
            let yourTicket = data[1].lines.dropFirst().map { $0.commas.ints }[0]
            let nearbyTicket = data[2].lines.dropFirst().map { $0.commas.ints }
            let tickets = [yourTicket] + nearbyTicket
            let allData = Set(dataFields.flatMap(\.validValues))
            let validTickets = tickets.filter { ticket in
                ticket.allSatisfy { allData.contains($0) }
            }
            var matches = [Int: [String]]()
            for number in 0..<validTickets[0].count {
                for dataField in dataFields {
                    if validTickets.allSatisfy({
                        dataField.validValues.contains($0[number])
                    }) {
                        matches[number, default: []].append(dataField.name)
                    }
                }
            }
            
            var confidentMatches = [(Int, String)]()
            
            while matches.values.contains(where: { $0.count > 1 }) {
                for match in matches where match.value.count == 1 {
                    confidentMatches.append((match.key, match.value[0]))
                    for m in matches {
                        matches[m.key]?.removeAll(where: { $0 == match.value[0] })
                    }
                }
            }
            confidentMatches.sort(by: { $0.0 < $1.0 })
            let results = confidentMatches.filter { $0.1.starts(with: "departure") }[0..<6]
            
            let answer = yourTicket.enumerated()
                .filter { field in
                    results.contains(where: { $0.0 == field.offset })
                }
                .map(\.element)
                .reduce(into: 1, *=)
            
            return "\(answer)"
        }
    }
}
