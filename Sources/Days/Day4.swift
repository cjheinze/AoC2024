import Foundation
import Helper
import RegexBuilder
import Algorithms

public class Day3: DayProtocol {
    private let input: String
    private let rows: [String]
    
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 3).replacingOccurrences(of: "\n", with: "")
        rows = input.split(separator: "\n")
            .map(String.init)
    }
    
    fileprivate func extractMultiplicationPairs(row: String) -> [(Int, Int)] {
        let regex = #/mul\((\d+),(\d+)\)/#
        return row
            .matches(of: regex)
            .map { match in
                (Int(match.1)!, Int(match.2)!)
            }
    }
    
    
    public func partOne() -> String {
        return extractMultiplicationPairs(row: input)
            .map { pair in
                pair.0 * pair.1
            }
            .reduce(0, +).description
    }
    
    public func partTwo() -> String {
        let pattern = #/do\(\)|don't\(\)|mul\((\d+),(\d+)\)/#
        let matches = input.matches(of: pattern)
        
        var isEnabled = true
        var total = 0
        
        for match in matches {
            
            switch match.output.0 {
            case "do()":
                isEnabled = true
            case "don't()":
                isEnabled = false
            default:
                if isEnabled, let x = match.output.1, let y = match.output.2 {
                    total += Int(x)! * Int(y)!
                }
            }
        }
        return "\(total)"
    }
}
