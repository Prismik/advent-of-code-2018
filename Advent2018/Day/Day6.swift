//
//  Day6.swift
//  Advent2018
//
//  Created by Francis Beauchamp on 2018-12-13.
//  Copyright © 2018 Francis Beauchamp. All rights reserved.
//

import Foundation

class Day6: Day {
    class Coordinate {
        static var identifier = 0

        let x: Int
        let y: Int
        let identifier: Int
        init(instructions: String) {
            let components = instructions.components(separatedBy: ", ")
            self.x = Int(components[0])!
            self.y = Int(components[1])!
            self.identifier = Coordinate.identifier
            Coordinate.identifier += 1
        }

        func manhattanDistance(from coordinate: (x: Int, y: Int)) -> Int {
            return abs(coordinate.x - x + coordinate.y - y)
        }
    }

    func run(input: String) {
        var coordinates = input.components(separatedBy: .newlines).filter({ !$0.isEmpty }).map({ Coordinate(instructions: $0) })

    }
}
