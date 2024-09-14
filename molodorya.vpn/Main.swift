//
//  ViewController.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 01.09.2024.
//

import UIKit

class Main: UIViewController {
    
     
    
    var servers = [
        ["Нидерланды"],
        ["Амстердам"]
    ]
    
    let imgFlags = ["netherlands"]
    
    @IBOutlet weak var tableView: UITableView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Gradient VPN"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        VPN().connectVPN()
        
       
    }
    
}



extension Main: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers[1].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MainCell
        
        
        cell.country.text = servers[0][indexPath.row]
        cell.city.text = servers[1][indexPath.row]
        cell.picture.image = UIImage(named: imgFlags[indexPath.row])
        
        return cell
    }
    
    
}
