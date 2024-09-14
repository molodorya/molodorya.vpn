//
//  Subscribers.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 12.09.2024.
//

import UIKit

class Subscribers: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100

    }
    
}



extension Subscribers: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscribeCell", for: indexPath) as! SubscribeCell
        
        
        switch indexPath.row {
        case 0:
            cell.month.text = "1"
            cell.titleMonth.text = "Месяц"
            cell.promptMonth.text = "Безлимитного доступа"
            cell.priceMonth.text = "249 ₽"
        case 1:
            cell.month.text = "3"
            cell.titleMonth.text = "Месяца"
            cell.promptMonth.text = "Безлимитного доступа"
            cell.priceMonth.text = "499 ₽"
        case 2:
            cell.month.text = "6"
            cell.titleMonth.text = "Месяцев"
            cell.promptMonth.text = "Безлимитного доступа"
            cell.priceMonth.text = "799 ₽"
        default:
            break
        }
        
       
        
        
        return cell
    }
    
    
}
