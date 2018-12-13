//
//  String+substring.swift
//  Advent2018
//
//  Created by Francis Beauchamp on 2018-12-13.
//  Copyright © 2018 Francis Beauchamp. All rights reserved.
//

import Foundation

extension String {
    func index(at offset: Int) -> Index {
        return self.index(startIndex, offsetBy: offset)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(at: from)
        return String(self[fromIndex ..< endIndex])
    }

    func substring(to: Int) -> String {
        let toIndex = index(at: to)
        return String(self[startIndex ..< toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let indexRange = (index(at: r.lowerBound) ..< index(at: r.upperBound))
        return String(self[indexRange])
    }

    func substring(with r: NSRange) -> String {
        let indexRange = (index(at: r.lowerBound) ..< index(at: r.upperBound))
        return String(self[indexRange])
    }
}
