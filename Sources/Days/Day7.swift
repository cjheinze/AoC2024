import Foundation
import Helper
import RegexBuilder
import Algorithms

public class Day7: DayProtocol {
    private let input: String
    private let equations: [(goal: Int, values: [Int])]
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 7)
        let rows = input.split(separator: "\n")
            .map(String.init)
        equations = rows.map { row in
            let goal = row.split(separator: ": ").first.map { Int($0)! }
            let values = row.split(separator: ": ").last.map { $0.split(separator: " ").map { Int($0)! } }
            return (goal!, values!)
        }
    }
    
    public func partOne() -> String {
        equations.map { equation in
            let values = Array(equation.values.dropFirst()).enumerated().makeIterator()
            return (equation.goal, reduceEquation(goal: equation.goal, sum: equation.values.first!, values: values))
            
        }.filter { $0.1 }
            .map { $0.0 }
            .reduce(0, +)
            .description
    }
    
    public func partTwo() -> String {
        equations.map { equation in
            let values = Array(equation.values.dropFirst()).enumerated().makeIterator()
            return (equation.goal, reduceEquation2(goal: equation.goal, sum: equation.values.first!, values: values))
            
        }.filter { $0.1 }
            .map { $0.0 }
            .reduce(0, +)
            .description
    }
    
    func reduceEquation(goal: Int, sum: Int, values: EnumeratedSequence<[Int]>.Iterator) -> Bool {
        var values = values
        switch values.next() {
        case nil:
            return sum == goal
        case .some(let next):
            return reduceEquation(goal: goal, sum: sum + next.element, values: values) ||
                    reduceEquation(goal: goal, sum: sum * next.element, values: values)
        }
    }
    
    func reduceEquation2(goal: Int, sum: Int, values: EnumeratedSequence<[Int]>.Iterator) -> Bool {
        var values = values
        switch values.next() {
        case nil:
            return sum == goal
        case .some(let next):
            return reduceEquation2(goal: goal, sum: sum + next.element, values: values) ||
                    reduceEquation2(goal: goal, sum: sum * next.element, values: values) ||
                    reduceEquation2(goal: goal, sum: Int("\(sum)\(next.element)")!, values: values)
        }
    }
}
