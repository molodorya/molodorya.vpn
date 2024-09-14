//
//  MainCell.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 04.09.2024.
//
import UIKit
import Foundation
import NetworkExtension


class MainCell: UITableViewCell {
    
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var onVPN: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    var timer : Timer?
    var counter = 0

    
    
    override func awakeFromNib() {
        picture.layer.cornerRadius = picture.frame.width / 2
        
        picture.layer.borderColor = UIColor.black.cgColor
        picture.layer.borderWidth = 0.05
        
        self.statusLabel.isHidden = true
        
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { Timer in
            
            let status = VPN().vpnManager.connection.status
            
            
            switch status {
            case NEVPNStatus.connected:
                self.onVPN.isOn = true
                self.statusLabel.text = "· Connected"
                self.statusLabel.textColor = .systemGreen
                self.statusLabel.isHidden = false
                
            case NEVPNStatus.invalid, NEVPNStatus.disconnected :
                self.onVPN.isOn = false
                self.statusLabel.isHidden = true
                
            case NEVPNStatus.connecting , NEVPNStatus.reasserting:
                self.onVPN.isOn = true
                self.statusLabel.isHidden = false
                self.statusLabel.text = "· Connecting"
                self.statusLabel.textColor = .systemYellow
                
            case NEVPNStatus.disconnecting:
                self.onVPN.isOn = false
                self.statusLabel.isHidden = true
               
            default:
                print("Unknown VPN connection status")
            }
           
        }
        
    }
    
    
    
    
    @IBAction func onStatus(_ sender: UISwitch) {
        
        
        
        if onVPN.isOn == true {
            VPN().connectVPN()
          
//            timer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(prozessTimer), userInfo: nil, repeats: true)
            
        } else {
            print(2)
            VPN().disconnectVPN()
            killTimer()
        }
            
        
    }
    
    
    
    
    @objc func prozessTimer() {
        counter += 1
        print("This is a second ", counter)
        
    }
    
    func killTimer() {
        timer?.invalidate()
        timer = nil
    }

    
    
}
