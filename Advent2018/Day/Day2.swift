//
//  Day2.swift
//  Advent2018
//
//  Created by Francis Beauchamp on 2018-12-12.
//  Copyright © 2018 Francis Beauchamp. All rights reserved.
//

import Foundation

class Day2: Day {
    class Box {
        let identifier: String

        private var letterCounts: [Character: Int] = [:]

        init(identifier: String) {
            self.identifier = identifier
            for letter in identifier {
                if letterCounts[letter] == nil {
                    letterCounts[letter] = 1
                } else {
                    letterCounts[letter]! += 1
                }
            }
        }

        func containsLetter(repeated times: Int) -> Bool {
            return letterCounts.contains(where: { (key, count) in
                return count == times
            })
        }

        func distance(from box: Box) -> Int {
            if box.identifier.isEmpty {
                return Int.max
            }

            var distance = 0
            for (index, letter) in identifier.enumerated() {
                let stringIndex = identifier.index(identifier.startIndex, offsetBy: index)
                if box.identifier[stringIndex] != letter {
                    distance += 1
                }
            }

            return distance
        }
    }

    func run(input: String) {
        let boxIdentifiers = input.components(separatedBy: .newlines)
        let boxes = boxIdentifiers.map({ return Box(identifier: $0) })
        let checksum = boxes.filter({ return $0.containsLetter(repeated: 2) }).count * boxes.filter({ return $0.containsLetter(repeated: 3) }).count

        print("Checksum for the boxes is \(checksum)")

        var candidateBoxes: (first: String, second: String) = ("", "")
        for firstBox in boxes {
            for secondBox in boxes {
                if firstBox.distance(from: secondBox) == 1 {
                    candidateBoxes = (firstBox.identifier, secondBox.identifier)
                    break
                }
            }
        }

        print("Boxes containing prototype fabric have ids of \(candidateBoxes)")

        var commonIdentifier: String = ""
        for (index, letter) in candidateBoxes.first.enumerated() {
            let stringIndex = candidateBoxes.first.index(candidateBoxes.first.startIndex, offsetBy: index)
            if candidateBoxes.second[stringIndex] != letter {
                var copy = candidateBoxes.first
                copy.remove(at: stringIndex)
                commonIdentifier = copy
            }
        }

        print("Boxes containing prototype fabric have common ids of \(commonIdentifier)")
    }
}
