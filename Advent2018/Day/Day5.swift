//
//  Day5.swift
//  Advent2018
//
//  Created by Francis Beauchamp on 2018-12-13.
//  Copyright © 2018 Francis Beauchamp. All rights reserved.
//

import Foundation

class Day5: Day {
    static let deltaReaction = 32

    func run(input: String) {
        let polymer = input.components(separatedBy: .newlines).first!
        let alteredPolymer = implode(polymer: polymer)
        print("There are \(alteredPolymer.count) units remaining after fully reacting.")

        let startTrimmingValue = Int("A".unicodeScalars.first!.value)
        let endTrimmingValue = Int("Z".unicodeScalars.first!.value)
        var trimmedPolymers: [String] = []
        for value in startTrimmingValue ... endTrimmingValue {
            trimmedPolymers.append(implode(polymer: optimize(polymer, removing: [value, value + Day5.deltaReaction])))
        }

        let bestPolymer = trimmedPolymers.min(by: { $0.count < $1.count }) ?? ""
        print("The best mutated polymer has a lenght of \(bestPolymer.count)")
    }

    func implode(polymer: String) -> String {
        var copy = polymer
        var index = copy.startIndex
        while index < copy.index(before: copy.endIndex) {
            let leftUnit = copy[index]
            let rightUnit = copy[copy.index(after: index)]
            if abs(Int(leftUnit.unicodeScalars.first!.value) - Int(rightUnit.unicodeScalars.first!.value)) == Day5.deltaReaction {
                copy.remove(at: index)
                copy.remove(at: index)

                if index != copy.startIndex {
                    index = copy.index(before: index)
                }
            } else if index != copy.index(before: copy.endIndex) {
                index = copy.index(after: index)
            }
        }

        return copy
    }

    func optimize(_ polymer: String, removing units: [Int]) -> String {
        var copy = polymer
        var index = copy.startIndex
        while index < copy.index(before: copy.endIndex) {
            if units.contains(Int(copy[index].unicodeScalars.first!.value)) {
                copy.remove(at: index)
                if index != copy.startIndex {
                    index = copy.index(before: index)
                }
            }

            if index != copy.index(before: copy.endIndex) {
                index = copy.index(after: index)
            }
        }

        return copy
    }
}
