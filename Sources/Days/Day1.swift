//
//  File.swift
//  
//
//  Created by Carl-Johan Heinze on 2022-12-05.
//

import Foundation
import Helper
import RegexBuilder

public class Day1: DayProtocol {
    private let input: String
    private let rows: [String]
    
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: 1)
        rows = input.split(separator: "\n").map(String.init)
    }
    
    func getLeftAndRightList() -> ([Int], [Int]) {
        let splitRows = rows.map({ $0.split(separator: .whitespace) })
            .map({ $0.map({ Int($0)! }) })
            .flatMap { $0 }
            .enumerated()
        var leftList = [Int]()
        var rightList = [Int]()
        splitRows.forEach { index, value in
            if index % 2 == 0 {
                leftList.append(value)
            } else {
                rightList.append(value)
            }
        }
        return (leftList, rightList)
    }

    public func partOne() -> String {
        let (leftList, rightList) = getLeftAndRightList()
        var differences = [Int]()
        zip(leftList.sorted(), rightList.sorted()).forEach { left, right in
            differences.append(abs(left - right))
        }
        
        return differences.reduce(0, +).description
    }
        
    public func partTwo() -> String {
        let (leftList, rightList) = getLeftAndRightList()
        var similarityScores = [Int : Int]()
        leftList.forEach { value in
            let occurances = rightList.filter { $0 == value }.count
            similarityScores[value] = occurances * value
        }
        
        return similarityScores.values.reduce(0, +).description
    }
}
