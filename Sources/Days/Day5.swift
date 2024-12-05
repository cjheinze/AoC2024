import Foundation
import Helper
import RegexBuilder
import Algorithms

public class Day5: DayProtocol {
    private let input: String
    private let rules: [String]
    private let orders: [String]
    
    private let illegalSubsequentPages: [Int: [Int]]
    
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 5)
        
        let sections = input.split(separator: "\n\n").map(String.init)
        rules = sections[0].split(separator: "\n").map(String.init)
        orders = sections[1].split(separator: "\n").map(String.init)
        illegalSubsequentPages = rules.map { rule in
            let pair = rule.split(separator: "|").map(String.init)
            return (x: Int(pair[0])!, y: Int(pair[1])!)
        }.reduce(into: [Int: [Int]]()) { map, rule in
            map[rule.y, default: [Int]()].append(rule.x)
        }
    }
    
    public func partOne() -> String {
        
        return orders.compactMap { order in
            let pages = order.split(separator: ",").map({ Int ($0)! })
            let isValid = pageOrderCorrect(order: order)
            return isValid ? pages[pages.count / 2] : nil
        }.reduce(0, +).description
    }
    
    public func partTwo() -> String {
        var enumeratedOrders = orders.enumerated()
        var checkedOrders = enumeratedOrders.compactMap { index, order in
            let pages = order.split(separator: ",").map({ Int ($0)! })
            let isValid = pageOrderCorrect(order: order)
            return (index, order, isValid)
        }
        
        return checkedOrders.filter({ !$0.2 })
            .map { index, order, _ in
                let pages = order.split(separator: ",").map({ Int ($0)! })
                let fixed = pages.sorted { a, b in
                    illegalSubsequentPages[a]?.contains(b) ?? true
                }
                return fixed[fixed.count / 2]
            }.reduce(0, +).description
    }
    
    
    fileprivate func pageOrderCorrect(order: String) -> Bool {
        let pages = order.split(separator: ",").map({ Int ($0)! })
        return pages.enumerated().map { index, page in
            let nextPages = pages.dropFirst(index + 1)
            return illegalSubsequentPages[page]?.allSatisfy { !nextPages.contains($0) } ?? true
        }.allSatisfy { $0 }
    }

}
