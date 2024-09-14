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
        
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnBoard")
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
            } else {
             
            }
            
            present(vc, animated: true)
           
        }
        
        
       
        getDataVPN().getDataFromJSON()
        
        
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Gradient VPN"
        navigationController?.navigationBar.prefersLargeTitles = true
        
       
       
    }
    
}



extension Main: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers[1].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MainCell
        
        
        cell.country.text = servers[0][indexPath.row]
        cell.city.text = servers[1][indexPath.row]
        cell.picture.image = UIImage(named: imgFlags[indexPath.row])
        
        return cell
    }
    
    
}
