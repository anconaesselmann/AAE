//  Created by Axel Ancona Esselmann on 1/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreLocation

public extension Array where Element: CLLocation {
    
    var distanceDeltas: [CLLocationDistance] {
        return deltas { $0.distance(from: $1) }
    }
    
    var timeDeltas: [TimeInterval] {
        return deltas { $1.timestamp.timeIntervalSince($0.timestamp) }
    }
    
    var elevationDeltas: [CLLocationDistance] {
        return deltas { $0.altitude - $1.altitude }
    }
    
    var secsPerMeterDeltas: [Double] {
        return zip(timeDeltas, distanceDeltas).map { $0.0 / $0.1 }
    }
    
    var minutesPerMileDeltas: [Double] {
        return secsPerMeterDeltas.map { $0 * LocationConstants.minutesPerMile }
    }
    
    var totalDistance: CLLocationDistance {
        return distanceDeltas.reduce(0.0, +)
    }
    
    var totalDistanceMiles: CLLocationDistance {
        return totalDistance / DistanceConstants.metersPerMile
    }
    
    var totalDistanceKilometers: CLLocationDistance {
        return totalDistance / DistanceConstants.metersPerKilometer
    }
    
    var totalTime: TimeInterval {
        return timeDeltas.reduce(0, +)
    }
    
    var totalElevationGained: CLLocationDistance {
        return elevationDeltas.filter { $0 > 0 }.reduce(0, +)
    }
    
    var totalElevationLost: CLLocationDistance {
        return elevationDeltas.filter { $0 < 0 }.reduce(0, +)
    }
    
    var totalElevationChange: CLLocationDistance {
        guard let last = last, let first = first else { return 0 }
        return first.altitude - last.altitude
    }
    
    var minutesPerMile: Double {
        return minutesPerMileDeltas.reduce(0, +) / Double(minutesPerMileDeltas.count)
    }
    
    var minuteSplits: [[CLLocation]] {
        let splitSize = Double(TimeConstants.secondsPerMinute)
        return splits(splitSize, transform: { $1.timestamp.timeIntervalSince($0.timestamp) })
    }
    
    var mileSplits: [[CLLocation]] {
        let splitSize = DistanceConstants.metersPerMile
        return splits(splitSize, transform: { $0.distance(from: $1) })
    }
    
    var halfMileSplits: [[CLLocation]] {
        let splitSize = DistanceConstants.metersPerMile / 2.0
        return splits(splitSize, transform: { $0.distance(from: $1) })
    }
    
    var quarterMileSplits: [[CLLocation]] {
        let splitSize = DistanceConstants.metersPerMile / 4.0
        return splits(splitSize, transform: { $0.distance(from: $1) })
    }
    
    var kilometerSplits: [[CLLocation]] {
        return metricDistanceSplits(metersPerDistanceUnit: DistanceConstants.metersPerKilometer)
    }
    
    var hundredMeterSplits: [[CLLocation]] {
        return metricDistanceSplits(metersPerDistanceUnit: DistanceConstants.hundredMetersPerKilometer)
    }
    
    func metricDistanceSplits(metersPerDistanceUnit: Double = 1.0) -> [[CLLocation]] {
        return splits(metersPerDistanceUnit, transform: { $0.distance(from: $1) })
    }
    
    var runningTotalsDistanceMeters: [CLLocationDistance] {
        return distanceDeltas.runningTotals()
    }
    
    var runningTotalsDistanceKilometers: [CLLocationDistance] {
        return distanceDeltas.runningTotals().map{ $0 / DistanceConstants.metersPerKilometer}
    }
    
    var runningTotalsDistanceMiles: [CLLocationDistance] {
        return distanceDeltas.runningTotals().map{ $0 / DistanceConstants.metersPerMile}
    }
    
}
