//
//  ModelVPN.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 14.09.2024.
//

import UIKit
import Foundation



struct AvailableVPN: Codable {
    let country: Country
}

 
struct Country: Codable {
    let one, two, free, four, five, six, seven, eight, nine, ten: DataInfo
}
 
struct DataInfo: Codable {
    let username, ipAdress, sharedSecret, password: String
    let nameVPN: String
}




class getDataVPN {
    func getDataFromJSON() {
           guard let url = URL(string: "http://www.molodorya.ru/gradientVPN.js") else { return }
           
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else { return }
               guard error == nil else { return }
               
               do {
                   let jsonVPN = try JSONDecoder().decode(AvailableVPN.self, from: data)
                   print("jsonVPN \(jsonVPN)")
                
               } catch let error {
                   print(error)
               }
           }
           
           .resume()
           
       }
}

