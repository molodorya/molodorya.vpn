//
//  ViewController.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 01.09.2024.
//

import UIKit

class Main: UIViewController {
    
     
    
    var servers = [
        ["Russia", "Finland", "UAE"],
        ["0.0.0.0", "1.1.1.1", "2.2.2.2"]
    ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vpnStart: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vpnStart.layer.cornerRadius = 15
        
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Molodorya.VPN"
        navigationController?.navigationBar.prefersLargeTitles = true
       
    }
    
    
    
    @IBAction func startVPN(_ sender: UIButton) {
        
        
        VPNIKEv2Setup.shared.initVPNTunnelProviderManager()


    }
    

}



extension Main: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath)
        
        
        
        
        
        return cell
    }
    
    
}
