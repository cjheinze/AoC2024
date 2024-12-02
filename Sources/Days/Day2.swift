import Foundation
import Helper
import RegexBuilder
import Algorithms

public class Day2: DayProtocol {
    private let input: String
    private let rows: [[Int]]

    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 2)
        rows = input.split(separator: "\n")
            .map(String.init)
            .map({ row in
                row.split(separator: .whitespace).map { Int($0)! }
            })
    }

    public func partOne() -> String {
        rows.map(verifyRow(_:)).count(where: { $0 }).description
    }
        
    public func partTwo() -> String {
        return rows.map { row in
            if verifyRow(row) {
                return true
            } else {
                let permutations = row.indices.map { index in
                    var copy = row
                    copy.remove(at: index)
                    return copy
                }
                return permutations.contains(where: { verifyRow($0) })
            }
        }
        .count(where: { $0 }).description
    }
    
    func verifyRow(_ row: [Int]) -> Bool {
        if row == row.sorted() || row == row.sorted(by: >) {
            let differences = row.windows(ofCount: 2).map { pair in
                abs(pair.last! - pair.first!)
            }
            return differences.allSatisfy { (1...3).contains($0) }
        } else {
            return false
        }
    }
}
