import Foundation
import Helper
import RegexBuilder
import Algorithms

public class DayX: DayProtocol {
    private let input: String
    
    public init() {
        input = FileHandler.getInputs(for: Bundle.module.resourcePath!, andDay: Int.max)
    }
    
    public func partOne() -> String {
        ""
    }
    
    public func partTwo() -> String {
        ""
    }
}
