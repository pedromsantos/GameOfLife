import UIKit
import XCTest

public class Cell {
    
    private let state:LifeState = Live()
    private let neighbours:[Cell]
    
    public convenience init() {
        self.init(state: Live(), neighbours: [Cell]())
    }
    
    public init(state:LifeState, neighbours:[Cell]) {
        self.state = state
        self.neighbours = neighbours
    }
    
    public func tick() -> Cell {
        return Cell(state: state.handle(self), neighbours: self.neighbours)
    }
    
    public var State:LifeState {
        return state
    }
    
    public var neighbouringCells:Int {
        return self.neighbours.count
    }
}

public protocol LifeState {
    func handle(cell:Cell) -> LifeState
}

public class Live : LifeState {
    private let minimumViableNeighbours = 2
    private let maximumViableNeighbours = 3
    
    public func handle(cell:Cell) -> LifeState  {
        return isAlive(cell)
            ? Live()
            : Dead()
    }
    
    private func isAlive(cell:Cell) -> Bool {
        return cell.neighbouringCells > minimumViableNeighbours
            && cell.neighbouringCells <= maximumViableNeighbours
    }
}

public class Dead : Live {
    private override func isAlive(cell:Cell) -> Bool {
        return cell.neighbouringCells == maximumViableNeighbours
    }
}

public class GameOfLifeStatePatternTests: XCTestCase {
    func testThatItShouldSetLivingCellToDeadCellWhenItHasLessThanTwoLiveNeighbours() {
        let cell = Cell()
        
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell.state is Dead)
    }
    
    func testThatItShouldSetLivingCellToDeadCellWhenItHasMoreThanThreeLiveNeighbours() {
        let cell = Cell(state:Live(), neighbours:[Cell(), Cell(), Cell(), Cell()])
        
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell.state is Dead)
    }
    
    func testThatItShouldSeDeadCellToLivingCellWhenItHasExactlyThreeLiveNeighbours() {
        let cell = Cell(state:Dead(), neighbours:[Cell(), Cell(), Cell()])
        
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell.state is Live)
    }
}
