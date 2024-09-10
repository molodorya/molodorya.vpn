//
//  VPN.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 01.09.2024.
//

import Foundation
import NetworkExtension

class VPNIKEv2Setup {
    
    static let shared = VPNIKEv2Setup()

    let vpnManager = NEVPNManager.shared()
    
    func initVPNTunnelProviderManager() {

        print("CALL LOAD TO PREFERENCES...")
        self.vpnManager.loadFromPreferences { [self] (error) -> Void in
            
            if((error) != nil) {

                print("VPN Preferences error: 1 - \(String(describing: error))")
            } else {

                let IKEv2Protocol = NEVPNProtocolIKEv2()
                
                IKEv2Protocol.authenticationMethod = .certificate
                IKEv2Protocol.serverAddress = VPNServerSettings.shared.vpnServerAddress
                IKEv2Protocol.remoteIdentifier = VPNServerSettings.shared.vpnRemoteIdentifier
                IKEv2Protocol.localIdentifier = VPNServerSettings.shared.vpnLocalIdentifier
                IKEv2Protocol.passwordReference = "UY1hbppeY9Cs".data(using: .utf8)

                IKEv2Protocol.useExtendedAuthentication = false
                IKEv2Protocol.ikeSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256GCM
                IKEv2Protocol.ikeSecurityAssociationParameters.diffieHellmanGroup = .group20
                IKEv2Protocol.ikeSecurityAssociationParameters.integrityAlgorithm = .SHA512
                IKEv2Protocol.ikeSecurityAssociationParameters.lifetimeMinutes = 1440

                IKEv2Protocol.childSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256GCM
                IKEv2Protocol.childSecurityAssociationParameters.diffieHellmanGroup = .group20
                IKEv2Protocol.childSecurityAssociationParameters.integrityAlgorithm = .SHA512
                IKEv2Protocol.childSecurityAssociationParameters.lifetimeMinutes = 1440
                
                IKEv2Protocol.deadPeerDetectionRate = .medium
                IKEv2Protocol.disableRedirect = true
                IKEv2Protocol.disableMOBIKE = false
                IKEv2Protocol.enableRevocationCheck = false
                IKEv2Protocol.enablePFS = true
                IKEv2Protocol.useConfigurationAttributeInternalIPSubnet = false

                IKEv2Protocol.serverCertificateIssuerCommonName = VPNServerSettings.shared.vpnServerCertificateIssuerCommonName
                IKEv2Protocol.disconnectOnSleep = false
                IKEv2Protocol.certificateType = .ECDSA384
                IKEv2Protocol.identityDataPassword = VPNServerSettings.shared.p12Password
                IKEv2Protocol.identityData = self.dataFromFile()

                self.vpnManager.protocolConfiguration = IKEv2Protocol
                self.vpnManager.localizedDescription = "molodorya.vpn"
                self.vpnManager.isEnabled = true
                self.vpnManager.isOnDemandEnabled = false

                //Set rules
                var rules = [NEOnDemandRule]()
                let rule = NEOnDemandRuleConnect()
                rule.interfaceTypeMatch = .any
                rules.append(rule)
//                self.vpnManager.onDemandRules = rules

                print("SAVE TO PREFERENCES...")
                //SAVE TO PREFERENCES...
                self.vpnManager.saveToPreferences(completionHandler: { (error) -> Void in
                    if((error) != nil) {

                        print("VPN Preferences error: 2 - \(String(describing: error))")
                    } else {

                        print("CALL LOAD TO PREFERENCES AGAIN...")
                        //CALL LOAD TO PREFERENCES AGAIN...
                        self.vpnManager.loadFromPreferences(completionHandler: { (error) in
                            if ((error) != nil) {
                                print("VPN Preferences error: 2 - \(String(describing: error))")
                            } else {
                                var startError: NSError?

                                do {
                                    //START THE CONNECTION...
                                    try self.vpnManager.connection.startVPNTunnel()
                                } catch let error as NSError {

                                    startError = error
                                    print(startError.debugDescription)
                                } catch {

                                    print("Fatal Error")
                                    fatalError()
                                }
                                if ((startError) != nil) {
                                    print("VPN Preferences error: 3 - \(String(describing: error))")

                                    //Show alert here
                                    print("title: Oops.., message: Something went wrong while connecting to the VPN. Please try again.")

                                    print(startError.debugDescription)
                                } else {

                                    print("Starting VPN...")
                                }
                            }
                        })
                    }
                })
            }
        }

    }

    //MARK:- Connect VPN
    static func connectVPN() {
        VPNIKEv2Setup().initVPNTunnelProviderManager()
        
    }

    //MARK:- Disconnect VPN
    static func disconnectVPN() {
        VPNIKEv2Setup().vpnManager.connection.stopVPNTunnel()
    }
    
    //MARK:- Disconnect VPN
    static func testConnect() {
        do {
            try VPNIKEv2Setup().vpnManager.connection.startVPNTunnel()
        } catch let error {
            print(error)
        }
    }

    //MARK:- check connection staatus
    static func checkStatus() {

        let status = VPNIKEv2Setup().vpnManager.connection.status
        print("VPN connection status = \(status.rawValue)")

        switch status {
        case NEVPNStatus.connected:

            print("Connected")

        case NEVPNStatus.invalid, NEVPNStatus.disconnected :

            print("Disconnected")

        case NEVPNStatus.connecting , NEVPNStatus.reasserting:

            print("Connecting")

        case NEVPNStatus.disconnecting:

            print("Disconnecting")

        default:
            print("Unknown VPN connection status")
        }
    }
    
    
    let certi = """
    -----BEGIN CERTIFICATE-----
    MIIE8DCCAtigAwIBAgIISJUXw50QnAkwDQYJKoZIhvcNAQEMBQAwFjEUMBIGA1UE
    AxMLVlBOIHJvb3QgQ0EwHhcNMjQwOTEwMTY1MDA4WhcNMzQwOTA4MTY1MDA4WjAW
    MRQwEgYDVQQDEwtWUE4gcm9vdCBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCC
    AgoCggIBAJLyVUKHug+E5MG+pyX6BnFPvX70rIYOu8TC1dFZCyS8oXF/peo/gbal
    oiOxcJx4DHF+Xy71sHOy+LW3Q0D3HJ5QPL1CJ+BKjVMJ+/Bfq6H9XjI4GfJP35t6
    uikag/i1OGuFQLYEDvTZet3jhTt8tDXViwcXu98waUahuB98mtCvH7qY9tgVr+hj
    En4HUA4G9gweOwPcspk0Ywe+is3LAA7fhUxuKkMP0kjKCNXkUeQWsE1QlhTA3cZ/
    j//ROBqgQtUKy1nNViSpc4vbiyfYVzpgb62TxH5slwiAOqOztqjyecd7aSNcvWQT
    U1boUozPkTrIRn9WUCapt0x2ROOd7pzhmfeDmDQAt4Fn4G1ZRKTUoPiWsLxcLiI2
    rnpOC3szeBmjkBkv3jXZ7p4xkX+ex8rllyqXpkNI0yqdtAfjrXF4cK6nDQ3ZjeWl
    jUjBL+4aTGQqOVmmzzq79+DggleDn9v5bYKnOfOGjEsTCkvFjxISeoTh8oqFW+rt
    Z4WP53OJRsf4OVnXiehd3xPFacZ6Q5KHxw5iIedpAx0M+QnZNWUPHk4NP7WW0Hw5
    eSDlM2CN03DkSf/9nD7EQuCmm5RZBaJG7Gk/z7JbP/CiF5uJi3N34efMV8V0DfhQ
    QyC8FpaVIzsahDyGO2acVtVfTStet0ornloEySSBAzRe9ivpigrnAgMBAAGjQjBA
    MA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRgB4Uf
    eGnb6Q+IVD9zFpnOofX1bzANBgkqhkiG9w0BAQwFAAOCAgEAPE2ANjz/pBxcq0ra
    oRl/hjgMIMYgExMgo531OQ5VBnxsNyFQzKEQPby10GsGQWJXQMtURGeIjQZMyo4J
    A1sxxi1A91r99n8qdgi7n2hC+rez7qyKnYFgDL/srF0vtw5b4IRiGO8m9fQGab6O
    FbHT7/Yk/9W6MzOAJ0fclBCd1uBHr2jzHdp1XUmHk0cuxpcEnT0vwsWiYfJIn6x0
    Buvh/3yB4xZ2y+GagGlscthEK2wDars0iDm+nDb4B6/hqZBT1J3HPnLgIxZDpnQ+
    lAnWlA7DO8Dil8sHJeAJKxAT7ytF7E1H1/wF66+4Ki17FembDwAmnDNGfeW0sq8G
    ZZQTVgDf68jG5XM9WsIA/IT4drx7GFqCL8HXBzrir2tizmJCLgTmpKF71qIV6Za5
    HsLmOL6kDckxVnFGeJmlmPw+IC/pIZTepX1SDv/yoRJB2ERUshoEgul3ayvMZ1PK
    lyXtt1Hh8M+tLuTQ9/jvSaYyjD8Pw+vNuyP1PN0uT9Vp1tmELe0+4+sifWTCJReW
    9fRFYsouZcNjs7Wbv0zSzYx0yVRbELcbS8lbyk1VFmT5WRU0ad7i8cJb9+fN32Mw
    S+H+fh+QESdkd2ZlxHAwx8J410y3bA3xqbMYWB+0w6bma4ImqqpPE0R2c+ti+Bbm
    XCsR4Yg9xZKuiY5vwzJHC9WYO2A=
    -----END CERTIFICATE-----
    """.data(using: .utf8)
    
    func dataFromFile() -> Data? {
        let rootCertPath = Bundle.main.url(forResource: "phone", withExtension: "p12")
        print(rootCertPath?.absoluteURL as Any)
        
        return certi
    }
    
}

class VPNServerSettings: NSObject {
    static let shared = VPNServerSettings()
    
    let p12Password = "UY1hbppeY9Cs" // пароль от файла сертификата "****.p12"
    let vpnServerAddress = "185.103.255.104"
    let vpnRemoteIdentifier = "185.103.255.104" // В моем случае то же самое, что и адрес VPN-сервера.
    let vpnLocalIdentifier = "root"
    let vpnServerCertificateIssuerCommonName = "185.103.255.104" // В моем случае то же самое, что и адрес VPN-сервера.
}
