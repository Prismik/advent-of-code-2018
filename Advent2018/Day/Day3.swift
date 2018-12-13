//
//  Day3.swift
//  Advent2018
//
//  Created by Francis Beauchamp on 2018-12-12.
//  Copyright © 2018 Francis Beauchamp. All rights reserved.
//

import Foundation

class Day3: Day {
    struct Point: Hashable {
        let x: Int
        let y: Int

        static func ==(lhs: Point, rhs: Point) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }
    }

    struct Rectangle {
        let x: Int
        let y: Int
        let width: Int
        let height: Int
    }

    class Claim {
        let rectangle: Rectangle
        let identifier: Int
        init(instructions: String) {
            let data = instructions.components(separatedBy: .whitespaces)
            var id = data[0]
            id.removeFirst()
            self.identifier = Int(id) ?? -1

            // Skip @

            var location = data[2]
            location.removeAll(where: { $0 == ":" })
            let locationComponents = location.components(separatedBy: ",")
            let x = Int(locationComponents[0]) ?? -1
            let y = Int(locationComponents[1]) ?? -1

            let sizeComponents = data[3].components(separatedBy: "x")
            let width = Int(sizeComponents[0]) ?? -1
            let height = Int(sizeComponents[1]) ?? -1
            self.rectangle = Rectangle(x: x, y: y, width: width, height: height)
        }
    }

    class Fabric {
        var grid: [Point: Int] = [:]
        func add(claim: Claim) {
            let area = claim.rectangle
            for x in (area.x ... area.x + area.width - 1) {
                for y in (area.y ... area.y + area.height - 1) {
                    if grid[Point(x: x, y: y)] == nil {
                        grid[Point(x: x, y: y)] = 1
                    } else {
                        grid[Point(x: x, y: y)]! += 1
                    }
                }
            }
        }

        func overusedSquareInches() -> Int {
            return grid.values.reduce(0, { (result, claimCount) -> Int in
                return claimCount > 1 ? result + 1 : result
            })
        }

        func isIntact(claim: Claim) -> Bool {
            let area = claim.rectangle
            for x in (area.x ... area.x + area.width - 1) {
                for y in (area.y ... area.y + area.height - 1) {
                    if grid[Point(x: x, y: y)] != 1 {
                        return false
                    }
                }
            }

            return true
        }
    }

    func run(input: String) {
        let fabric = Fabric()
        let claims = input.components(separatedBy: .newlines).filter({ !$0.isEmpty }).map({ return Claim(instructions: $0) })
        for claim in claims {
            fabric.add(claim: claim)
        }

        print("The number of inches of fabric that are within two or more claims is \(fabric.overusedSquareInches())")
        let intactClaims = claims.filter({ fabric.isIntact(claim: $0) })
        print("These are the intact claims: \(intactClaims.map({ $0.identifier }))")
    }
}
