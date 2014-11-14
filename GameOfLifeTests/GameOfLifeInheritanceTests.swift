import UIKit
import XCTest

public protocol CellProtocol {
    func tick() -> CellProtocol
}

public class LiveCell : CellProtocol {
    private let neighbours:[CellProtocol]
    private let minimumViableNeighbours = 2
    private let maximumViableNeighbours = 3
    private let cellCreationRules:[Bool : () -> CellProtocol]
    
    public convenience init() {
        self.init(neighbours: [CellProtocol]())
    }
    
    public init(neighbours:[CellProtocol]) {
        self.neighbours = neighbours
        self.cellCreationRules = [
            true : {() -> CellProtocol in return LiveCell(neighbours: neighbours)},
            false : {() -> CellProtocol in return DeadCell(neighbours: neighbours)}
        ]
    }
    
    public func tick() -> CellProtocol {
        return cellCreationRules[isAlive()]!()
    }
    
    private func isAlive() -> Bool {
        let neighboursCount = neighbours.count
        return neighboursCount >= minimumViableNeighbours && neighboursCount <= maximumViableNeighbours
    }
}

public class DeadCell : LiveCell {
    private override func isAlive() -> Bool {
        return neighbours.count == maximumViableNeighbours
    }
}

public class GameOfLifeInheritanceTests: XCTestCase {
    func testThatItShouldSetLivingCellToDeadCellWhenItHasLessThanTwoLiveNeighbours() {
        let cell = LiveCell()
        
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell is DeadCell)
    }
    
    func testThatItShouldSetLivingCellToDeadCellWhenItHasMoreThanThreeLiveNeighbours() {
        let cell = LiveCell(neighbours:[LiveCell(), LiveCell(), LiveCell(), LiveCell()])
        
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell is DeadCell)
    }

    func testThatItShouldSeDeadCellToLivingCellWhenItHasExactlyThreeLiveNeighbours() {
        let cell = DeadCell(neighbours:[LiveCell(), LiveCell(), LiveCell()])
        
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell is LiveCell)
    }
}
