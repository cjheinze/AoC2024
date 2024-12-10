import Foundation
import Helper
import RegexBuilder
import Algorithms

public class Day8: DayProtocol {
    private let input: String
    private let map: Grid<Character>
    private let antennaPositions: [Character: [Position]]
    
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 8)
        map = Grid(grid: input.split(separator: "\n").map { row in
            row.map { $0 }
        })
        antennaPositions = map.allPositions.reduce(into: [Character: [Position]]()) { [map] dict, position in
            if let char = map.get(position), char != "." {
                dict[char, default: []].append(position)
            }
        }
    }
    
    public func partOne() -> String {
        var antinodes: Set<Position> = Set()
        antennaPositions.keys.forEach { type in
            let positions = antennaPositions[type]!
            positions.permutations(ofCount: 2).forEach { perm in
                let distanceVector = perm[0].distanceVector(to: perm[1])
                let antinode = perm[1].adding(distanceVector)
                if map.isValid(antinode) {
                    antinodes.insert(antinode)
                }
            }
        }
            
        return antinodes.count.description
    }
    
    public func partTwo() -> String {
        var antinodes: Set<Position> = Set()
        antennaPositions.keys.forEach { type in
            let positions = antennaPositions[type]!
            positions.permutations(ofCount: 2).forEach { perm in
                let distanceVector = perm[0].distanceVector(to: perm[1])
                var antinode = perm[0].adding(distanceVector)
                while map.isValid(antinode) {
                    antinodes.insert(antinode)
                    antinode = antinode.adding(distanceVector)
                }
            }
        }
        return antinodes.count.description

    }
}
