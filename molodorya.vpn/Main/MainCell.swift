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
    
    
    @IBOutlet weak var hiddenServer: UIView!
    
    
   
    
    override func awakeFromNib() {
        picture.layer.cornerRadius = picture.frame.width / 2
        
        picture.layer.borderColor = UIColor.black.cgColor
        picture.layer.borderWidth = 0.05
        
        self.statusLabel.isHidden = true
        
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { Timer in
                
                let status = VPN().vpnManager.connection.status
                
                
                switch status {
                case NEVPNStatus.connected:
                    self.statusLabel.text = "· Connected"
                    self.statusLabel.textColor = .systemGreen
                    self.statusLabel.isHidden = false
                    
                case NEVPNStatus.invalid, NEVPNStatus.disconnected :
                    self.statusLabel.isHidden = true
                    
                case NEVPNStatus.connecting , NEVPNStatus.reasserting:
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "· Connecting"
                    self.statusLabel.textColor = .systemYellow
                    
                case NEVPNStatus.disconnecting:
                    self.statusLabel.isHidden = true
                   
                default:
                    break
                }
               
            }
        
        
        
    }
    
    
    
    
    @IBAction func onStatus(_ sender: UISwitch) {
        
      
        
    }
    
    
    
    
 
    
    
}
