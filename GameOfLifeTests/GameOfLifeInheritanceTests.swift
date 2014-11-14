import UIKit
import XCTest

public protocol CellProtocol {
    func tick() -> CellProtocol
}

public enum CellStatus:Int {
    case Dead
    case Alive
    
    public static func statusFrom(status:Bool) -> CellStatus {
        return CellStatus(rawValue: Int(status))!
    }
}

public class CellFactory {
    private let cellCreationRules:[CellStatus : (neighbours:[CellProtocol]) -> CellProtocol]
    
    public init() {
        self.cellCreationRules = [
            CellStatus.Alive
                : {(neighbourCells:[CellProtocol]) -> CellProtocol in
                    return LiveCell(neighbours: neighbourCells)},
            CellStatus.Dead
                : {(neighbourCells:[CellProtocol]) -> CellProtocol in
                    return DeadCell(neighbours: neighbourCells)}
        ]
    }
    
    public func createCell(status:CellStatus, neighbourCells:[CellProtocol]) -> CellProtocol {
        return self.cellCreationRules[status]!(neighbours: neighbourCells)
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
        return cellFactory.createCell(status(), neighbourCells: self.neighbours)
    }
    
    private func status() -> CellStatus {
        let neighboursCount = neighbours.count
        let isAlive = neighboursCount >= minimumViableNeighbours && neighboursCount <= maximumViableNeighbours
        return CellStatus.statusFrom(isAlive)
    }
}

public class DeadCell : LiveCell {
    private override func status() -> CellStatus {
        let isAlive = neighbours.count == maximumViableNeighbours
        return CellStatus.statusFrom(isAlive)
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
