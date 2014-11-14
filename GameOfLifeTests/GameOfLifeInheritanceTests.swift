import UIKit
import XCTest

public protocol CellProtocol {
    func tick() -> CellProtocol
}

public class LiveCell : CellProtocol {
    private let neighbours:[CellProtocol]
    
    public init() {
        self.neighbours = [CellProtocol]()
    }
    
    public init(neighbours:[CellProtocol]) {
        self.neighbours = neighbours
    }
    
    public func tick() -> CellProtocol {
        let neighboursCount = neighbours.count
        return neighboursCount < 2 || neighboursCount > 3 ? DeadCell(neighbours: self.neighbours) : LiveCell(neighbours: self.neighbours)
    }
}

public class DeadCell : LiveCell {
    public override func tick() -> CellProtocol {
        let neighboursCount = neighbours.count
        return neighboursCount == 3 ? LiveCell(neighbours: self.neighbours) : DeadCell(neighbours: self.neighbours)
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
