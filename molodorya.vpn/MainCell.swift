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
        
        country.text = "Russia"
        city.text = "Moscow"
        
        picture.downloaded(from: "https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Flag_of_Russia.svg/1599px-Flag_of_Russia.svg.png?20120812153731")
        
    }
    
    
    
}
