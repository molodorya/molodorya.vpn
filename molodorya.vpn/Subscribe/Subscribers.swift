//
//  Subscribers.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 12.09.2024.
//

import UIKit

class Subscribers: UIViewController {
    
    let typeSubscribers = ["1 Месяц", "3 Месяца", "6 месяцев", "12 месяцев"]
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}



extension Subscribers: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
