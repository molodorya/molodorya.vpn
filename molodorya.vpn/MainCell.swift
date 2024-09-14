//
//  MainCell.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 04.09.2024.
//
import UIKit
import Foundation


class MainCell: UITableViewCell {
    
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var onVPN: UISwitch!
    
    
    
    
    override func awakeFromNib() {
        picture.layer.cornerRadius = picture.frame.width / 2
        
        picture.layer.borderColor = UIColor.black.cgColor
        picture.layer.borderWidth = 0.05
        
    }
    
    
    @IBAction func onStatus(_ sender: UISwitch) {
        
        if onVPN.isOn {
            VPN().connectVPN()
        } else {
            VPN().disconnectVPN()
        }
            
        
    }
    
    
    
    
}
