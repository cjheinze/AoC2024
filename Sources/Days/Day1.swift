import Foundation
import Helper
import RegexBuilder

public class Day1: DayProtocol {
    private let input: String
    private let rows: [String]
    private let leftList, rightList: [Int]
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 1)
        rows = input.split(separator: "\n").map(String.init)
        let splitRows = rows.map { row in
            row.split(separator: .whitespace).map { Int($0)! }
        }
        leftList = splitRows.map({ $0[0] })
        rightList = splitRows.map({ $0[1] })
    }

    public func partOne() -> String {
        zip(leftList.sorted(), rightList.sorted()).reduce(0, { total, pair in
            total + abs(pair.0 - pair.1)
        }).description
    }
        
    public func partTwo() -> String {
        leftList.reduce(into: [Int : Int]()) { total, value in
            total[value] = rightList.count { $0 == value } * value
        }.values.reduce(0, +).description
    }
}
