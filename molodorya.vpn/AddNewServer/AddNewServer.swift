//
//  Subscribers.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 12.09.2024.
//

import UIKit

class Subscribers: UIViewController {
    
    
    @IBOutlet weak var serverNameTextField: UITextField!
    @IBOutlet weak var serverAdressTextFIeld: UITextField!
    @IBOutlet weak var sharedSecretTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var VPNNameTextField: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
  
       hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func leftBarButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        
//        let kcs = KeychainService()
//        kcs.save(key: "SHAREDNew", value: sharedSecretTextField.text ?? "")
//        kcs.save(key: "VPN_PASSWORDNew", value: passwordTextField.text ?? "")
////        p.sharedSecretReference = kcs.load(key: "SHARED")
////        p.passwordReference = kcs.load(key: "VPN_PASSWORD")
//        
//        
//        Main.addedServer.append(NewVPN(username: serverNameTextField.text ?? "", serverAdress: serverAdressTextFIeld.text ?? "", sharedSecret: kcs.load(key: "SHAREDNew"), password: kcs.load(key: "VPN_PASSWORDNew"), nameVPN: VPNNameTextField.text ?? ""))
        
        
        
        connectNewVPN(username: serverNameTextField.text ?? "", serverAdress: serverAdressTextFIeld.text ?? "", sharedSecret: sharedSecretTextField.text ?? "", password: passwordTextField.text ?? "", nameVPN: VPNNameTextField.text ?? "")
        
        
        
    }
    
    
    
    // Server name
    @IBOutlet var serverView: UIView!
    
    @IBAction func serverNameDidBegin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) { [self] in
            serverView.frame.size.height = 2
            serverView.backgroundColor = .systemBlue
        }

        
    }
    
    @IBAction func serverNameDidEnd(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) { [self] in
            serverView.frame.size.height = 1
            serverView.backgroundColor = .systemGray
        }
        
    }
    
    
    // Server name
    @IBOutlet var serverAdressView: UIView!
    
    @IBAction func serverAdressDidBegin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) { [self] in
            serverAdressView.frame.size.height = 2
            serverAdressView.backgroundColor = .systemBlue
        }

        
    }
    
    @IBAction func serverAdressDidEnd(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) { [self] in
            serverAdressView.frame.size.height = 1
            serverAdressView.backgroundColor = .systemGray
        }
        
    }
    
    
}


