import Foundation
import Helper
import RegexBuilder
import Algorithms

public class Day6: DayProtocol {
    private let input: String
    
    private let map: Grid<MapSymbols>
    
    private let startPosition: Grid<MapSymbols>.Position
    
    private let up = Grid<MapSymbols>.Position(x: 0, y: -1)
    private let down = Grid<MapSymbols>.Position(x: 0, y: 1)
    private let left = Grid<MapSymbols>.Position(x: -1, y: 0)
    private let right = Grid<MapSymbols>.Position(x: 1, y: 0)

    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 6)
        map = Grid(grid: input.split(separator: "\n")
            .map(String.init)
            .map { row in
                Array(row).map { MapSymbols(rawValue: String($0))! }
            })
        startPosition = map.allPositions.first(where: { [map] in map.get($0) == .start })!
    }
    
    public func partOne() -> String {
                
        var currentDirection = up
        var currentPosition = startPosition
        var nextPosition = startPosition.adding(currentDirection)
        var visitedPositions: Set<Grid<MapSymbols>.Position> = [startPosition]
        while map.isValid(nextPosition) {
            let nextSymbol = map.get(nextPosition)
            switch nextSymbol {
            case .obstacle:
                currentDirection = getNextDirection(currentDirection)
            case .open, .start:
                currentPosition = nextPosition
            case .none:
                break
            }
            visitedPositions.insert(currentPosition)
            nextPosition = currentPosition.adding(currentDirection)
        }
        
        return "currentPosition: \(currentPosition.x), \(currentPosition.y), visitedPositions: \(visitedPositions.count)"
    }
    
    public func partTwo() -> String {
        map.allPositions
            .filter { [map] in map.get($0) == .open }
            .count(
                where: { openPosition in
                    findLoop(map: map.copy(changing: openPosition, to: .obstacle))
                }).description
    }
    
    func findLoop(map: Grid<MapSymbols>) -> Bool {
        var currentDirection = up
        var currentPosition = startPosition
        var visitedPositionsAndDirections: [Grid<MapSymbols>.Position : Set<Grid<MapSymbols>.Position>] = [:]

        while map.isValid(currentPosition.adding(currentDirection)) {
            if visitedPositionsAndDirections[currentPosition]?.contains(currentDirection) == true {
                return true
            }
            
            visitedPositionsAndDirections[currentPosition, default: []].insert(currentDirection)
            
            let nextSymbol = map.get(currentPosition.adding(currentDirection))
            if nextSymbol == .obstacle {
                currentDirection = getNextDirection(currentDirection)
            } else {
                currentPosition = currentPosition.adding(currentDirection)
            }
        }
        return false
    }
    
    func getNextDirection(_ direction: Grid<MapSymbols>.Position) -> Grid<MapSymbols>.Position {
        return switch direction {
        case up: right
        case right: down
        case down: left
        case left: up
        default:
            fatalError("Invalid direction")
        }
    }
        
    enum MapSymbols: String {
        case open = "."
        case obstacle = "#"
        case start = "^"
    }
}
