import Foundation
import Helper
import RegexBuilder
import Algorithms

public class Day5: DayProtocol {
    private let input: String
    private let rules: [String]
    private let orders: [[Int]]
    
    private let illegalSubsequentPages: [Int: [Int]]
    
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 5)
        
        let sections = input.split(separator: "\n\n").map(String.init)
        rules = sections[0] .split(separator: "\n").map(String.init)
        orders = sections[1].split(separator: "\n").map(String.init)
            .map { $0.split(separator: ",").map { Int($0)! } }
        illegalSubsequentPages = rules
            .map { rule in
                let pair = rule.split(separator: "|").map(String.init)
                return (x: Int(pair.first!)!, y: Int(pair.last!)!)
            }.reduce(into: [Int: [Int]]()) { map, rule in
                map[rule.y, default: [Int]()].append(rule.x)
            }
    }
    
    public func partOne() -> String {
        
        return orders.compactMap { pages in
            pageOrderCorrect(pages: pages) ? pages.getMiddleValue() : nil
        }.reduce(0, +).description
    }
    
    public func partTwo() -> String {
        return orders.compactMap { pages in
            pageOrderCorrect(pages: pages) ? nil : pages.sorted { a, b in
                illegalSubsequentPages[a]?.contains(b) ?? true
            }.getMiddleValue()
        }.reduce(0, +).description
    }
    
    fileprivate func pageOrderCorrect(pages: [Int]) -> Bool {
        pages.enumerated().map { index, page in
            let nextPages = pages.dropFirst(index + 1)
            return illegalSubsequentPages[page]?.allSatisfy { !nextPages.contains($0) } ?? true
        }.allSatisfy { $0 }
    }

}

extension Array where Element == Int {
    func getMiddleValue() -> Int {
        guard count > 0 else {
            fatalError("Array is empty")
        }
        return self[self.count / 2]
    }
}
