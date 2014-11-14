import UIKit
import XCTest

public class BaseCell {
    private let neighbours:[Cell]
    
    public init() {
        self.neighbours = [Cell]()
    }
    
    public init(neighbours:[Cell]) {
        self.neighbours = neighbours
    }
    
    public func tick() -> BaseCell {
        return self
    }
}

public class LiveCell : BaseCell {
    public override func tick() -> BaseCell {
        return neighbours.count < 2 ? DeadCell(neighbours: self.neighbours) : LiveCell(neighbours: self.neighbours)
    }
}

public class DeadCell : BaseCell {
}

public class GameOfLifeHinreritanceTests: XCTestCase {
    func testThatItShouldSetLivingCellToDeadCellWhenItHasLessThanTwoLiveNeighbours() {
        let cell = LiveCell()
        
        let resultingCell = cell.tick()
        XCTAssertTrue(resultingCell is DeadCell)
    }
}
