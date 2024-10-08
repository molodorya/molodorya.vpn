//
//  ModelMap.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 21.09.2024.
//

import Foundation
import CoreLocation
import MapKit


class ServerLocation {
    var country: String?
    var city: String?
    var imgFlag: String?
    
    init(country: String, city: String, imgFlag: String) {
        self.country = country
        self.city = city
        self.imgFlag = imgFlag
    }
}

class UserLocation: NSObject, MKAnnotation {
 
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D
     
     init(name: String, imageName: String, lat: CLLocationDegrees, long: CLLocationDegrees){

         coordinate = CLLocationCoordinate2DMake(lat, long)
     }
}
