//
//  ModelVPN.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 14.09.2024.
//

import UIKit
import Foundation


struct ModelVPN: Decodable {
    var username: String
    var ipAdress: String
    var sharedSecret: String
    var password: String
    var nameVPN: String
}



class getDataVPN {
    func getDataFromJSON() {
           guard let url = URL(string: "https://raw.githubusercontent.com/molodorya/gradientJSON/main/json.json?token=GHSAT0AAAAAACWJ6YYIZPB2MJ3L5QKQST44ZXFZOHQ") else { return }
           
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else { return }
               guard error == nil else { return }
               
               do {
                   let jsonVPN = try JSONDecoder().decode(ModelVPN.self, from: data)
                   print(jsonVPN.ipAdress)
                
               } catch let error {
                   print(error)
               }
           }
           
           .resume()
           
       }
}
