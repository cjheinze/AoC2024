import Foundation
import Helper
import RegexBuilder
import Algorithms

public class Day4: DayProtocol {
    private let input: String
    private let grid: [[Character]]
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 4)
        grid = input.split(separator: "\n")
            .map(String.init)
            .map(Array.init)
    }
    
    public func partOne() -> String {
        let wordToFindInGrid = "XMAS"
        
        let directionsToCheck: [Grid<Character>.Position] = [
            .init(x: 1, y: 0),
            .init(x: 1, y: 1),
            .init(x: 1, y: -1),
            .init(x: -1, y: 1),
            .init(x: -1, y: 0),
            .init(x: -1, y: -1),
            .init(x: 0, y: -1),
            .init(x: 0, y: 1),
        ]
        
        let wordSearch = Grid(grid: self.grid)
        
        let result = doTheSearch(wordSearch, directionsToCheck, wordToFindInGrid)
        
        return result.flatMap { $0 }.count(where: { $0 }).description
    }
    
    public func partTwo() -> String {
        
        let result = findXPattern(Grid(grid: self.grid))
        
        return (result.count(where: { $0 })).description
    }
    
    fileprivate func findXPattern(_ wordSearch: Grid<Character>) -> [Bool] {

        return wordSearch.allPositions.map { pos in
            var foundX = false
            if let char = wordSearch.get(pos),
               let topLeft = wordSearch.get(Grid.Position(x: pos.x - 1, y: pos.y - 1)),
               let topRight = wordSearch.get(Grid.Position(x: pos.x + 1, y: pos.y - 1)),
               let bottomLeft = wordSearch.get(Grid.Position(x: pos.x - 1, y: pos.y + 1)),
               let bottomRight = wordSearch.get(Grid.Position(x: pos.x + 1, y: pos.y + 1)) {
                guard char == "A" else {
                    return false
                }
                return ((topLeft == "M" && bottomRight == "S") || (topLeft == "S" && bottomRight == "M")) &&
                ((topRight == "M" && bottomLeft == "S") || (topRight == "S" && bottomLeft == "M"))
                    
            }
            return false
        }
    }
    
    fileprivate func doTheSearch(_ wordSearch: Grid<Character>, _ directionsToCheck: [Grid<Character>.Position], _ wordToFindInGrid: String) -> [[Bool]] {
        return wordSearch.allPositions.map { pos in
            directionsToCheck.map { direction in
                var currentPos = pos
                var foundWord = ""
                while let char = wordSearch.get(currentPos) {
                    foundWord.append(char)
                    if foundWord == wordToFindInGrid {
                        return true
                    }
                    currentPos = Grid.Position(x: currentPos.x + direction.x, y: currentPos.y + direction.y)
                }
                return false
            }
        }
    }    
}
