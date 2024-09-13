//
//  VPN.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 01.09.2024.
//

import Foundation
import NetworkExtension
import UIKit
import Security

class VPN {
    
    let vpnManager = NEVPNManager.shared()
    
    private var vpnLoadHandler: (Error?) -> Void { return
        { (error:Error?) in
            
            if ((error) != nil) {
                print("Could not load VPN Configurations")
                return
            }
            
            
            let p = NEVPNProtocolIPSec()
            p.username = "vpnuser"
            p.serverAddress = "185.103.255.104"
            p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
            
            let kcs = KeychainService()
            kcs.save(key: "SHARED", value: "RJzDxhdsBZzSxK53UTCR")
            kcs.save(key: "VPN_PASSWORD", value: "Tfgv8rzBdFzCzbn2")
            p.sharedSecretReference = kcs.load(key: "SHARED")
            p.passwordReference = kcs.load(key: "VPN_PASSWORD")
            p.useExtendedAuthentication = true
            
            self.vpnManager.protocolConfiguration = p
            
             
            self.vpnManager.localizedDescription = "GradientVPN"
            self.vpnManager.isEnabled = true
            self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
        } }
    
    
    
    
    private var vpnSaveHandler: (Error?) -> Void { return
        { (error:Error?) in
            
            if (error != nil) {
                print("Could not save VPN Configurations")
                return
                
            } else {
                
                do {
                
                    try self.vpnManager.connection.startVPNTunnel()
                    
                } catch let error {
                    
                    print("Error starting VPN Connection \(error.localizedDescription)");
                }
            }
        }

    }
    
    
    
    
    public func connectVPN() {
        self.vpnManager.loadFromPreferences(completionHandler: vpnLoadHandler)
    }

    public func disconnectVPN() -> Void {
        vpnManager.connection.stopVPNTunnel()
    }
    
}





// Identifiers
let serviceIdentifier = "MySerivice"
let userAccount = "authenticatedUser"
let accessGroup = "MySerivice"

// Arguments for the keychain queries
var kSecAttrAccessGroupSwift = NSString(format: kSecClass)

let kSecClassValue = kSecClass as CFString
let kSecAttrAccountValue = kSecAttrAccount as CFString
let kSecValueDataValue = kSecValueData as CFString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as CFString
let kSecAttrServiceValue = kSecAttrService as CFString
let kSecMatchLimitValue = kSecMatchLimit as CFString
let kSecReturnDataValue = kSecReturnData as CFString
let kSecMatchLimitOneValue = kSecMatchLimitOne as CFString
let kSecAttrGenericValue = kSecAttrGeneric as CFString
let kSecAttrAccessibleValue = kSecAttrAccessible as CFString

class KeychainService: NSObject {
    func save(key:String, value:String) {
        let keyData: Data = key.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        let valueData: Data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        
        let keychainQuery = NSMutableDictionary();
        keychainQuery[kSecClassValue as! NSCopying] = kSecClassGenericPasswordValue
        keychainQuery[kSecAttrGenericValue as! NSCopying] = keyData
        keychainQuery[kSecAttrAccountValue as! NSCopying] = keyData
        keychainQuery[kSecAttrServiceValue as! NSCopying] = "VPN"
        keychainQuery[kSecAttrAccessibleValue as! NSCopying] = kSecAttrAccessibleAlwaysThisDeviceOnly
        keychainQuery[kSecValueData as! NSCopying] = valueData;
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    func load(key: String)->Data {
        
        let keyData: Data = key.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        let keychainQuery = NSMutableDictionary();
        keychainQuery[kSecClassValue as! NSCopying] = kSecClassGenericPasswordValue
        keychainQuery[kSecAttrGenericValue as! NSCopying] = keyData
        keychainQuery[kSecAttrAccountValue as! NSCopying] = keyData
        keychainQuery[kSecAttrServiceValue as! NSCopying] = "VPN"
        keychainQuery[kSecAttrAccessibleValue as! NSCopying] = kSecAttrAccessibleAlwaysThisDeviceOnly
        keychainQuery[kSecMatchLimit] = kSecMatchLimitOne
        keychainQuery[kSecReturnPersistentRef] = kCFBooleanTrue
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(keychainQuery, UnsafeMutablePointer($0)) }
        
        
        if status == errSecSuccess {
            if let data = result as! NSData? {
                if let value = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) {
                }
                return data as Data;
            }
        }
        return "".data(using: .utf8)!;
    }
}
