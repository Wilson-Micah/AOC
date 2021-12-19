//
//  2020-Day4.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day4: Day {
        struct Passport {
            var data: [String: String]
            
            init(string: String) {
                data = [:]
                let components = string.components(separatedBy: .whitespacesAndNewlines)
                for component in components {
                    let pair = component.components(separatedBy: ":")
                    data[pair[0]] = pair[1]
                }
            }
            
            var isValidKeys: Bool {
                data["byr"] != nil &&
                data["iyr"] != nil &&
                data["eyr"] != nil &&
                data["hgt"] != nil &&
                data["hcl"] != nil &&
                data["ecl"] != nil &&
                data["pid"] != nil
            }
            
            var isValidValues: Bool {
                guard isValidKeys else { return false }
                let byr = Int(data["byr"]!)!
                let iyr = Int(data["iyr"]!)!
                let eyr = Int(data["eyr"]!)!
                let hgt = data["hgt"]!
                let validHeight: Bool
                if hgt.contains("cm") {
                    let height = Int(hgt.replacingOccurrences(of: "cm", with: ""))!
                    validHeight = height >= 150 && height <= 193
                } else {
                    let height = Int(hgt.replacingOccurrences(of: "in", with: ""))!
                    validHeight = height >= 59 && height <= 76
                }
                let hcl = data["hcl"]!
                let ecl = data["ecl"]!
                let pid = data["pid"]!
                let supportedEcl = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
                
                return byr >= 1920 && byr <= 2002 &&
                iyr >= 2010 && iyr <= 2020 &&
                eyr >= 2020 && eyr <= 2030 &&
                validHeight &&
                hcl.count == 7 &&
                hcl.range(of: #"#[0-9|a-f]{6}"#, options: .regularExpression, range: nil, locale: nil) != nil &&
                supportedEcl.contains(ecl) &&
                pid.count == 9 &&
                pid.allSatisfy({ $0.isNumber })
            }
        }
        
        var passports: [Passport] {
            input.components(separatedBy: "\n\n")
                .map {
                    Passport(string: $0)
                }
        }
        
        func part1() -> String {
            let valid = passports.filter { $0.isValidKeys }
            return "\(valid.count)"
        }
        
        func part2() -> String {
            let valid = passports.filter { $0.isValidValues }
            return "\(valid.count)"
        }
    }
}
