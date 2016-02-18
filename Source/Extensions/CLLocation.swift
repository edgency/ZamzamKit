//
//  CLLocation.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//
import Foundation
import CoreLocation

public extension CLLocation {
    
    /**
     Retrieves location name for a place
     
     - parameter coordinates: Latitude and longitude] coordinates
     - parameter completion: Async callback with retrived data
     */
    public func getMeta(completionHandler: (location: LocationMeta?) -> Void) {
        // Reverse geocode stored coordinates
        CLGeocoder().reverseGeocodeLocation(
            CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)) {
                placemarks, error in
                // Validate values
                guard let mark = placemarks?[0] where error == nil else {
                    return completionHandler(location: nil)
                }
                
                // Get timezone if applicable
                var timezone: String?
                if mark.description != "" {
                    let desc = mark.description
                    
                    // Extract timezone description
                    if let regex = try? NSRegularExpression(
                        pattern: "identifier = \"([a-z]*\\/[a-z]*_*[a-z]*)\"",
                        options: .CaseInsensitive),
                        let result = regex.firstMatchInString(desc, options: [], range: NSMakeRange(0, desc.characters.count)) {
                            let tz = (desc as NSString).substringWithRange(result.rangeAtIndex(1))
                            timezone = tz.stringByReplacingOccurrencesOfString("_", withString: " ")
                    }
                }
                
                // Process callback
                completionHandler(location: LocationMeta(
                    locality: mark.locality,
                    country: mark.country,
                    countryCode: mark.ISOcountryCode,
                    timezone: timezone,
                    administrativeArea: mark.administrativeArea))
        }
    }
    
}