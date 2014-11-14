import UIKit
import XCTest

public protocol CellProtocol {
    func tick() -> CellProtocol
}

public class CellFactory {
    private let cellCreationRules:[Bool : (neighbours:[CellProtocol]) -> CellProtocol]
    
    public init() {
        self.cellCreationRules = [
            true : {(neighbourCells:[CellProtocol]) -> CellProtocol in return LiveCell(neighbours: neighbourCells)},
            false : {(neighbourCells:[CellProtocol]) -> CellProtocol in return DeadCell(neighbours: neighbourCells)}
        ]
    }
    
    public func createCell(isAlive:Bool, neighbourCells:[CellProtocol]) -> CellProtocol {
        return self.cellCreationRules[isAlive]!(neighbours: neighbourCells)
    }
}

public class LiveCell : CellProtocol {
    private let neighbours:[CellProtocol]
    private let cellFactory:CellFactory
    private let minimumViableNeighbours = 2
    private let maximumViableNeighbours = 3
    
    public convenience init() {
        self.init(neighbours: [CellProtocol]())
    }
    
    public init(neighbours:[CellProtocol]) {
        self.neighbours = neighbours
        self.cellFactory = CellFactory()
    }
    
    public func tick() -> CellProtocol {
        return cellFactory.createCell(isAlive(), neighbourCells: self.neighbours)
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
