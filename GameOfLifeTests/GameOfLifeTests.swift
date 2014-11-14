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
    
    public func iterate() -> Cell {
        return Cell(state: state.handle(self), neighbours: self.neighbours)
    }
    
    public var State:LifeState {
        return state
    }
    
    public func isAlive() -> Bool {
        return self.neighbours.count > 2 && self.neighbours.count <= 3
    }
}

public protocol LifeState {
    func handle(cell:Cell) -> LifeState
}

public class Live : LifeState {
    public func handle(cell:Cell) -> LifeState  {
        return cell.isAlive() ? self: Dead() // don't like this, violates Tell don't ask principle
    }
}

public class Dead : LifeState {
    public func handle(cell:Cell) -> LifeState {
        return self
    }
}

public class GameOfLifeTests: XCTestCase {
    
    override public func setUp() {
        super.setUp()
    }
    
    override public func tearDown() {
        super.tearDown()
    }
    
    func testThatItShouldSetLivingCellToDeadCellWhenItHasLessThanTwoLiveNeighbours() {
        let cell = Cell()
        
        let resultingCell = cell.iterate()
        XCTAssertTrue(resultingCell.state
            is Dead)
    }
    func testThatItShouldSetLivingCellToDeadCellWhenItHasMoreThanThreeLiveNeighbours() {
        let cell = Cell(state:Live(), neighbours:[Cell(), Cell(), Cell(), Cell()])
        
        let resultingCell = cell.iterate()
        XCTAssertTrue(resultingCell.state is Dead)
    }
}
