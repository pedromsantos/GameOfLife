import UIKit
import XCTest

public protocol CellProtocol {
    func tick() -> CellProtocol
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

public enum CellStatus:Int {
    case Dead
    case Alive
    
    public static func statusFrom(status:Bool) -> CellStatus {
        return CellStatus(rawValue: Int(status))!
    }
}

public class GameOfLifeInheritanceTests: XCTestCase {
    func testThatItShouldSetLivingCellToDeadCellWhenItHasLessThanTwoLiveNeighbours() {
        let cell = createLivingCellWithNeighbours()
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell is DeadCell)
    }
    
    func testThatItShouldSetLivingCellToDeadCellWhenItHasMoreThanThreeLiveNeighbours() {
        let cell = createLivingCellWithNeighbours(neighbours: 4)
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell is DeadCell)
    }

    func testThatItShouldSetDeadCellToLivingCellWhenItHasExactlyThreeLiveNeighbours() {
        let cell = createDeadCellWithNeighbours(neighbours: 3)
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell is LiveCell)
    }
    
    private func createLivingCellWithNeighbours(neighbours:Int = 0) -> CellProtocol {
        return LiveCell(neighbours: createCellNeighbours(neighbours))
    }
    
    private func createDeadCellWithNeighbours(neighbours:Int = 0) -> CellProtocol {
        return DeadCell(neighbours: createCellNeighbours(neighbours))
    }
    
    private func createCellNeighbours(neighbours:Int) -> [CellProtocol] {
        var cellNeighbours = [CellProtocol]()
        for var i = 0; i < neighbours; i++ {
            cellNeighbours.append(LiveCell())
        }
        
        return cellNeighbours
    }
}
