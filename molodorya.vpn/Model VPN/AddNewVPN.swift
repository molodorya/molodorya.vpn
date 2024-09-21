//
//  AddNewVPN.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 16.09.2024.
//

import UIKit
import Foundation
import NetworkExtension


struct NewVPN {
    var username: String
    var serverAdress: String
    var sharedSecret: Data
    var password: Data
    var nameVPN: String
}


func connectNewVPN(username: String, serverAdress: String, sharedSecret: String, password: String, nameVPN: String) {
    let VPNManager = NEVPNManager.shared()
    let VPNSetting = NEVPNProtocolIPSec()
    let keychain = KeychainService()
    
    VPNSetting.username = username
    VPNSetting.serverAddress = serverAdress
    VPNSetting.authenticationMethod = .sharedSecret
    
    keychain.save(key: "sharedSecret", value: sharedSecret)
    keychain.save(key: "password", value: password)
    
    VPNSetting.sharedSecretReference = keychain.load(key: "sharedSecret")
    VPNSetting.passwordReference = keychain.load(key: "password")
    
    VPNManager.protocolConfiguration = VPNSetting
    
    VPNManager.localizedDescription = nameVPN
    VPNManager.isEnabled = true
    VPNManager.saveToPreferences { _ in
        
        do {
            try VPNManager.connection.startVPNTunnel()
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
        
    }

}
