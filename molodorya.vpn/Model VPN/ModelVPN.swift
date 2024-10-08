//
//  ModelVPN.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 14.09.2024.
//

import UIKit
import Foundation



struct DataVPN: Decodable {
    let DataVPN: InfoVPN
    let Message: String
}
 
struct InfoVPN: Decodable {
    let username: String
    let ipAdress: String
    let sharedSecret: String
    let password: String
    let country: String
    let city: String
}




class getDataVPN {
    func getDataFromJSON() {
           guard let url = URL(string: "http://www.molodorya.ru/gradientVPN.js") else { return }
           
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else { return }
               guard error == nil else { return }
               
               do {
                   let VPN = try JSONDecoder().decode(DataVPN.self, from: data)
                   
//                   connectNewVPN(username: VPN.DataVPN.username, serverAdress: VPN.DataVPN.ipAdress, sharedSecret: VPN.DataVPN.sharedSecret, password: VPN.DataVPN.password, nameVPN: VPN.DataVPN.password)
                   
                   
                   DispatchQueue.main.async {
//                       Main().topAlertLabel.text = "\(VPN.Message)"
                   }
                   
                  
                   
                
               } catch let error {
                   print(error)
               }
           }
           
           .resume()
           
       }
}

