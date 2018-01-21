//  Created by Axel Ancona Esselmann on 1/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import CoreLocation
import MapKit

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

public func !=(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return !(lhs == rhs)
}

public func ==(lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
    return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
}

public func !=(lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
    return !(lhs == rhs)
}
