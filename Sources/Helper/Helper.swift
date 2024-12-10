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

public struct Position: Equatable, Hashable, Sendable {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public func adding(_ other: Position) -> Position {
        return Position(x: x + other.x, y: y + other.y)
    }
    
    public func subtracting(_ other: Position) -> Position {
        return Position(x: x - other.x, y: y - other.y)
    }
    
    public func distanceVector(to other: Position) -> Position {
        return Position(x: other.x - x, y: other.y - y)
    }
}

public struct Grid<Content>: Hashable, Equatable, Sendable where Content: Hashable & Equatable & Sendable {
    private var _grid: [[Content]]
    
    public init(grid: [[Content]]) {

        _grid = grid
    }
    
    public var size: (width: Int, height: Int) {
        return (_grid[0].count, _grid.count)
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
    
    public subscript(position: Position) -> Content? {
        get {
            get(position)
        }
    }
    
    public func getAllPositionsInLineWith(_ position: Position, _ other: Position) -> [Position] {
        let distance = position.distanceVector(to: other)
        let gcd = gcd(distance.x, distance.y)
        let step = Position(x: distance.x / gcd, y: distance.y / gcd)
        var currentPosition = position
        var positions = [currentPosition]
        while currentPosition != other {
            currentPosition = currentPosition.adding(step)
            positions.append(currentPosition)
        }
        return positions
    }
    
    public static func gridWithRepeatingContent(width: Int, height: Int, content: Content) -> Grid {
        return Grid(grid: Array(repeating: Array(repeating: content, count: width), count: height))
    }
    
    public func print() {
        for row in _grid {
            Swift.print(row.map { "\($0)" }.joined())
        }
    }
    
    public func copy(changing position: Position, to content: Content) -> Grid {
        var newGrid = _grid
        newGrid[position.y][position.x] = content
        return Grid(grid: newGrid)
    }
    
    public mutating func set(_ position: Position, to content: Content) {
        guard isValid(position) else {
            return
        }
        _grid[position.y][position.x] = content
    }
    
    public func isValid(_ position: Position) -> Bool {
        return position.x >= 0 && position.x < _grid[0].count && position.y >= 0 && position.y < _grid.count
    }
}
