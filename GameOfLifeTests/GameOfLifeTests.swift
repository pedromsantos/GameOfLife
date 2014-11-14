import UIKit
import XCTest

public class Cell {
    
    private let state:LifeState = Live()
    private let neighbours:[Cell]
    
    public init() {
        self.state = Live()
        self.neighbours = [Cell]()
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
    public func handle(cell:Cell) -> LifeState  {
        return cell.neighbouringCells > 2 && cell.neighbouringCells <= 3 ? self : Dead()
    }
}

public class Dead : LifeState {
    public func handle(cell:Cell) -> LifeState {
        return cell.neighbouringCells == 3 ? Live() : self
    }
}

public class GameOfLifeTests: XCTestCase {
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
