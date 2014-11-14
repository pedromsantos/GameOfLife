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
        let resultingLifeState = state.handle(self)
        return Cell(state: resultingLifeState, neighbours: self.neighbours)
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
    private let lifeStateFactory:LifeStateFactory
    
    public init() {
        self.lifeStateFactory = LifeStateFactory()
    }
    
    public func handle(cell:Cell) -> LifeState  {
        return lifeStateFactory.createLifeState(isAlive(cell))
    }
    
    private func isAlive(cell:Cell) -> CellState {
        let isAlive = cell.neighbouringCells > minimumViableNeighbours
            && cell.neighbouringCells <= maximumViableNeighbours
        
        return CellState.stateFrom(isAlive)
    }
}

public class Dead : Live {
    private override func isAlive(cell:Cell) -> CellState {
        let isAlive = cell.neighbouringCells == maximumViableNeighbours
        return CellState.stateFrom(isAlive)
    }
}

public class LifeStateFactory {
    private let stateCreationRules:[CellState : () -> LifeState]
    
    public init() {
        self.stateCreationRules = [
            CellState.Alive : {() -> LifeState in return Live()},
            CellState.Dead : {() -> LifeState in return Dead()}
        ]
    }
    
    public func createLifeState(isAlive:CellState) -> LifeState {
        return stateCreationRules[isAlive]!()
    }
}

public enum CellState:Int {
    case Dead
    case Alive
    
    public static func stateFrom(status:Bool) -> CellState {
        return CellState(rawValue: Int(status))!
    }
}

public class GameOfLifeStatePatternTests: XCTestCase {
    func testThatItShouldSetLivingCellToDeadCellWhenItHasLessThanTwoLiveNeighbours() {
        let cell = createCellWithNeighbours()
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell.state is Dead)
    }
    
    func testThatItShouldSetLivingCellToDeadCellWhenItHasMoreThanThreeLiveNeighbours() {
        let cell = createCellWithNeighbours(neighbours: 4)
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell.state is Dead)
    }
    
    func testThatItShouldSetDeadCellToLivingCellWhenItHasExactlyThreeLiveNeighbours() {
        let cell = createCellWithNeighbours(state:Dead(), neighbours: 3)
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell.state is Live)
    }
    
    private func createCellWithNeighbours(state:LifeState = Live(), neighbours:Int = 0) -> Cell {
        return Cell(state: state, neighbours: createCellNeighbours(neighbours))
    }
    
    private func createCellNeighbours(neighbours:Int) -> [Cell] {
        var cellNeighbours = [Cell]()
        for var i = 0; i < neighbours; i++ {
            cellNeighbours.append(Cell())
        }
        
        return cellNeighbours
    }
}
