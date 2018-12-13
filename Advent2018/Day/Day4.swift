//
//  Day4.swift
//  Advent2018
//
//  Created by Francis Beauchamp on 2018-12-13.
//  Copyright © 2018 Francis Beauchamp. All rights reserved.
//

import Foundation

class Day4: Day {
    static let formatter = DateFormatter()
    static let regex = try! NSRegularExpression(pattern: "^(\\[1518\\-[0-9]{2}\\-[0-9]{2} [0-9]{2}:[0-9]{2}\\]) (.+)$", options: NSRegularExpression.Options.caseInsensitive)
    static let guardIdentifierRegex = try! NSRegularExpression(pattern: "#([0-9]+)", options: NSRegularExpression.Options.caseInsensitive)
    static let wakeUpIdentifier = "wakes up"
    static let fallsAsleepIdentifier = "falls asleep"

    class Record {
        enum Event {
            case wakeUp
            case fallsAsleep
            case beginShift(guardIdentifier: Int)
        }

        let timestamp: Date
        let event: Event
        init?(description: String) {
            let matches = Day4.regex.matches(in: description, options: [], range: NSRange(location: 0, length: description.count))

            guard let match = matches.first else { return nil }
            self.timestamp = formatter.date(from: description.substring(with: match.range(at: 1))) ?? Date()
            let eventString =  description.substring(with: match.range(at: 2))
            if eventString.contains(Day4.wakeUpIdentifier) {
                event = .wakeUp
            } else if eventString.contains(Day4.fallsAsleepIdentifier) {
                event = .fallsAsleep
            } else {
                let matches = Day4.guardIdentifierRegex.matches(in: description, options: [], range: NSRange(location: 0, length: description.count))
                guard let match = matches.first else { return nil }
                event = .beginShift(guardIdentifier: Int(description.substring(with: match.range(at: 1))) ?? -1)
            }
        }
    }

    class Guard {
        let identifier: Int

        var totalMinutesOfSleep: Int {
            return sleepSchedule.values.reduce(0, +)
        }

        var minuteMostSleptAt: Int {
            return sleepSchedule.max(by: { $0.value < $1.value })?.key ?? -1
        }

        var mostSleptAtOccurence: Int {
            return sleepSchedule.max(by: { $0.value < $1.value })?.value ?? -1
        }

        private var sleepSchedule: [Int: Int] = [:]
        private var sleeping: (value: Bool, from: Int) = (value: false, from: 0)

        init(identifier: Int) {
            self.identifier = identifier
        }

        func sleep(at minute: Int) {
            sleeping = (value: true, from: minute)
        }

        func wake(at minute: Int) {
            for index in sleeping.from ..< minute {
                if sleepSchedule[index] == nil {
                    sleepSchedule[index] = 1
                } else {
                    sleepSchedule[index]! += 1
                }
            }

            sleeping = (value: false, from: minute)
        }
    }

    func run(input: String) {
        var guards: [Guard] = []
        var activeGuard: Guard?
        Day4.formatter.dateFormat = "[yyyy-MM-dd HH:mm]"
        let records = input.components(separatedBy: .newlines).filter({ !$0.isEmpty }).map({ return Record(description: $0)! }).sorted {
            $0.timestamp < $1.timestamp
        }

        for record in records {
            switch record.event {
            case .fallsAsleep:
                activeGuard?.sleep(at: Calendar.current.component(.minute, from: record.timestamp))
            case .wakeUp:
                activeGuard?.wake(at: Calendar.current.component(.minute, from: record.timestamp))
            case .beginShift(let identifier):
                if let guardOnShift = guards.first(where: { $0.identifier == identifier }) {
                    activeGuard = guardOnShift
                } else {
                    let newGuard = Guard(identifier: identifier)
                    activeGuard = newGuard
                    guards.append(newGuard)
                }
            }
        }

        guard let weakestGuard = guards.max(by: { $0.totalMinutesOfSleep < $1.totalMinutesOfSleep }) else { return }
        print("Sneaky computation of guard \(weakestGuard.identifier) is \(weakestGuard.identifier * weakestGuard.minuteMostSleptAt)")

        guard let drowsyGuard = guards.max(by: { $0.mostSleptAtOccurence < $1.mostSleptAtOccurence }) else { return }
        print("Sneaky computation of drowsy guard \(drowsyGuard.identifier) is \(drowsyGuard.identifier * drowsyGuard.minuteMostSleptAt)")
    }
}
