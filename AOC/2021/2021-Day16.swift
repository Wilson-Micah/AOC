//
//  Day16.swift
//  AOC21
//
//  Created by Micah Wilson on 12/15/21.
//

import Algorithms
import Foundation

extension AOC21 {
    struct Day16: Day {
        func part1() -> String {
            var binaryStrings = Array(input.hexToBinary).map(String.init)
            let packet = loadPacket(data: &binaryStrings)
            return "\(packet.summedVersion)"
        }
        
        func part2() -> String {
            var binaryStrings = Array(input.hexToBinary).map(String.init)
            let packet = loadPacket(data: &binaryStrings)
            return "\(packet.result)"
        }
    }
}

extension Day {
    func loadPacket(data: inout [String]) -> Packet {
        let versionBinary = data[0..<3].joined()
        let version = Int(versionBinary, radix: 2)!
        data.removeFirst(3)
        
        let typeBinary = data[0..<3].joined()
        let type = Int(typeBinary, radix: 2)!
        data.removeFirst(3)
        
        switch type {
        case 4:
            var decimalString = ""
            var groupBinary = "1"
            var decimalSize = 0
            repeat {
                groupBinary = data[0..<5].joined()
                decimalString += String(groupBinary.dropFirst())
                data.removeFirst(5)
                decimalSize += 5
            } while groupBinary.first == "1"
            
            let decimalValue = Int(decimalString, radix: 2)!
            return .init(
                version: version,
                typeID: type,
                type: .value(decimalValue),
                size: decimalSize + 6
            )
        default:
            let operatorType = data.removeFirst()
            if operatorType == "0" {
                let packetLengthBinary = data[0..<15].joined()
                let packetLength = Int(packetLengthBinary, radix: 2)!
                data.removeFirst(15)
                
                var remaining = packetLength
                var subPackets = [Packet]()
                while remaining > 0 {
                    let subPacket = loadPacket(data: &data)
                    remaining -= subPacket.totalSize
                    subPackets.append(subPacket)
                }
                return .init(
                    version: version,
                    typeID: type,
                    type: .lengthOperator(packetLength),
                    size: 15 + 1 + 6,
                    subPackets: subPackets
                )
            } else {
                let packetCountBinary = data[0..<11].joined()
                let packetCount = Int(packetCountBinary, radix: 2)!
                data.removeFirst(11)
                return .init(
                    version: version,
                    typeID: type,
                    type: .countOperator(packetCount),
                    size: 11 + 1 + 6,
                    subPackets: (0..<packetCount).map { _ in loadPacket(data: &data) }
                )
            }
        }
    }
}

struct Packet {
    enum PacketType {
        case lengthOperator(Int)
        case countOperator(Int)
        case value(Int)
    }
    let version: Int
    let typeID: Int
    let type: PacketType
    let size: Int
    var subPackets = [Packet]()
    var totalSize: Int {
        subPackets.reduce(into: size) { partialResult, packet in
            partialResult += packet.totalSize
        }
    }
    var summedVersion: Int {
        subPackets.reduce(into: version) { partialResult, packet in
            partialResult += packet.summedVersion
        }
    }
    var result: Int {
        switch typeID {
        case 0:
            return subPackets.reduce(into: 0) { partialResult, packet in
                partialResult += packet.result
            }
        case 1:
            return subPackets.reduce(into: 1) { partialResult, packet in
                partialResult *= packet.result
            }
        case 2:
            return subPackets.map(\.result).min()!
        case 3:
            return subPackets.map(\.result).max()!
        case 4:
            switch type {
            case let .value(val):
                return val
            default:
                return 0
            }
        case 5:
            return subPackets[0].result > subPackets[1].result ? 1 : 0
        case 6:
            return subPackets[0].result < subPackets[1].result ? 1 : 0
        case 7:
            return subPackets[0].result == subPackets[1].result ? 1 : 0
        default:
            return 0
        }
    }
}
