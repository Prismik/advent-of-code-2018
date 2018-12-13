//
//  Input.swift
//  Advent2018
//
//  Created by Francis Beauchamp on 2018-12-12.
//  Copyright © 2018 Francis Beauchamp. All rights reserved.
//

import Foundation

class Input {
    static let inputURL = URL(fileURLWithPath: #file).deletingLastPathComponent()

    static func get(_ file: String) throws -> String {
        let inputData = try Data(contentsOf: inputURL.appendingPathComponent(file))
        guard let input = String(data: inputData, encoding: .utf8) else {
            throw NSError() as Error
        }
        return input
    }
}
