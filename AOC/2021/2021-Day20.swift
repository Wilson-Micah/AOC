//
//  2021-Day20.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Algorithms
import Foundation

extension AOC21 {
    struct Day20: Day {
        func enhance(input: [String], image: [[String]], infiniteOn: Bool) -> [[String]] {
            var enhanced = [[String]]()
            
            for col in -1..<(image.count + 1) {
                enhanced.append([])
                for row in -1..<(image[0].count + 1) {
                    var string = ""
                    image.traverseAdjacentIncludingSelf(point: Point(x: col, y: row)) { value in
                        string.append(value ?? (infiniteOn && input.first == "#" ? "#" : "."))
                    }
                    
                    let binaryString = string.replacingOccurrences(of: ".", with: "0").replacingOccurrences(of: "#", with: "1")
                    let result = Int(binaryString, radix: 2)!
                    enhanced[col + 1].append(input[result])
                }
            }
            return enhanced
        }
        
        func enhanceImage(count: Int) -> [String] {
            let input = input.blankLines
            let enhancement = Array(input[0].lines.joined()).map(String.init)
            let image = input[1].columns
            var enhancedImage = image// enhance(input: enhancement, image: image, infiniteOn: false)
            for i in 0..<count {
                enhancedImage = enhance(input: enhancement, image: enhancedImage, infiniteOn: i % 2 == 1)
            }
            return enhancedImage.flatMap { $0 }
            
        }
        
        func part1() -> String {
            let onPixels = enhanceImage(count: 2).filter { $0 == "#" }
            return "\(onPixels.count)"
        }
        
        func part2() -> String {
            let onPixels = enhanceImage(count: 50).filter { $0 == "#" }
            return "\(onPixels.count)"
        }
    }
}
