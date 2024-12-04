//
//  File.swift
//  
//
//  Created by Carl-Johan Heinze on 2022-12-05.
//

import Foundation

public struct FileHandler {
    
    public static func getInputs(for path: String, andDay day: Int) -> String {
        let contents = try? String(contentsOfFile: path.appending("/Day\(day).txt"))
        return contents ?? ""
    }
}

public extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

public protocol DayProtocol {
    func partOne() -> String
    func partTwo() -> String
}

public extension Int {
    func mod(_ other: Int) -> Int {
        guard other != 0 else { return 0 }
        let m = self % other
        return m < 0 ? m + other : m
    }
}

// GCD of two numbers:
func gcd(_ a: Int, _ b: Int) -> Int {
    var (a, b) = (a, b)
    while b != 0 {
        (a, b) = (b, a % b)
    }
    return abs(a)
}

// GCD of a vector of numbers:
func gcd(_ vector: [Int]) -> Int {
    return vector.reduce(0, gcd)
}

// LCM of two numbers:
public func lcm(a: Int, b: Int) -> Int {
    return (a / gcd(a, b)) * b
}

// LCM of a vector of numbers:
public func lcm(_ vector : [Int]) -> Int {
    return vector.reduce(1, lcm)
}

public func +<T: Numeric> (x: (T, T), y: (T, T)) -> (T, T) {
    (x.0 + y.0, x.1 + y.1)
}

public struct Grid<Content> {
    public struct Position {
        public let x: Int
        public let y: Int
        
        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
    
    private let _grid: [[Content]]
    
    public init(grid: [[Content]]) {
        _grid = grid
    }
    
    public var allPositions: [Position] {
        return (0..<_grid.count).flatMap { y in
            (0..<_grid[y].count).map { x in
                Position(x: x, y: y)
            }
        }
    }
    
    public func get(_ position: Position) -> Content? {
        guard isValid(position) else {
            return nil
        }
        return _grid[position.y][position.x]
    }
    
    public func isValid(_ position: Position) -> Bool {
        return position.x >= 0 && position.x < _grid[0].count && position.y >= 0 && position.y < _grid.count
    }
}
