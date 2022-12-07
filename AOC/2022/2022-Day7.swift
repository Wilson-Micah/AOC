//
//  2022-Day7.swift
//  AOC
//
//  Created by Micah Wilson on 12/7/22.
//

import Algorithms
import Foundation

extension AOC22 {
    enum Directory {
        case directory(name: String, contents: [Directory])
        case file(name: String, size: Int)
        
        var size: Int {
            switch self {
            case let .directory(_, dir):
                return dir.map(\.size).reduce(into: 0, +=)
            case let .file(_, file):
                return file
            }
        }
        
        var name: String {
            switch self {
            case let .directory(name, _):
                return name
            case let .file(name, _):
                return name
            }
        }
        
        subscript(index: String) -> Directory? {
            get {
                switch self {
                case let .directory(_, contents):
                    return contents.first(where: { $0.name == index })
                case .file:
                    return nil
                }
            }
            set(newValue) {
                switch self {
                case .directory(let name, var contents):
                    if let i = contents.firstIndex(where: { $0.name == index }), let value = newValue {
                        contents[i] = value
                        self = .directory(name: name, contents: contents)
                    }
                case .file:
                    break
                }
            }
        }
        
        mutating func addDirectory(directory: Directory) {
            switch self {
            case .directory(let name, var contents):
                contents.append(directory)
                self = .directory(name: name, contents: contents)
            case .file:
                break
            }
        }
        
        mutating func addDirectory(path: [String], directory: Directory) {
            if path.isEmpty {
                addDirectory(directory: directory)
            } else if var d = self[path[0]] {
                d.addDirectory(path: Array(path.dropFirst()), directory: directory)
                self[path[0]] = d
            }
        }
        
        func traverse(includeFiles: Bool, _ traverse: (_ directory: Directory) -> Void) {
            switch self {
            case .file where includeFiles:
                traverse(self)
            case let .directory(_, contents):
                traverse(self)
                contents.forEach { $0.traverse(includeFiles: includeFiles, traverse) }
            default:
                break
            }
        }
    }
    
    struct Day7: Day {
        func createFileSystem() -> Directory {
            var currentPath = [String]()
            var fileSystem = Directory.directory(name: "\\", contents: [])
            for line in input.lines {
                if !line.contains("$") {
                    if line.contains("dir") {
                        let name = line.components(separatedBy: "dir ").last!
                        fileSystem.addDirectory(path: currentPath, directory: .directory(name: name, contents: []))
                    } else {
                        let components = line.components(separatedBy: .whitespaces)
                        let size = Int(components[0])!
                        let name = components[1]
                        fileSystem.addDirectory(path: currentPath, directory: .file(name: name, size: size))
                    }
                }
                if line.contains("$ cd /") {
                  currentPath = []
                } else if line.contains("$ cd ..") {
                    currentPath = Array(currentPath.dropLast())
                } else if line.contains("$ cd ") {
                    let name = line.components(separatedBy: "$ cd ").last!
                    currentPath.append(name)
                } else if line.contains("$ ls") {
                }
            }
            
            return fileSystem
        }
        
        func part1() -> String {
            let fileSystem = createFileSystem()
            var bytes = 0
            fileSystem.traverse(includeFiles: false) { file in
                if file.size <= 100000 {
                    bytes += file.size
                }
            }
            return "\(bytes)"
        }
        
        func part2() -> String {
            let maxSize = 70000000
            let spaceNeeded = 30000000
            let fileSystem = createFileSystem()
            let size = fileSystem.size
            let deleteAmount = spaceNeeded - (maxSize - size)
            var candidates = [Int]()
            fileSystem.traverse(includeFiles: false) { file in
                if file.size - deleteAmount > 0 {
                    candidates.append(file.size)
                }
            }
            return "\(candidates.min()!)"
        }
    }
}
