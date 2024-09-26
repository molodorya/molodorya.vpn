//
//  ViewController.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 01.09.2024.
//

import UIKit
import NetworkExtension
import AVKit

class Main: UIViewController {
    
    static var addedServer: [NewVPN] = []
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var connect: UIButton!

    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var player: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
  
    
    let imgFlags = ["netherlands", "uae"]
    
  
    
    var servers = [
        ServerLocation(country: "Netherlands", city: "Amsterdam", imgFlag: "netherlands", lat: 55, long: 22),
        ServerLocation(country: "UAE (Premium)", city: "Dubai", imgFlag: "uae", lat: 25.20, long: 55.27)
    ]
    
    var users = [
        UserLocation(name: "Netherlands", imageName: "netherlands", lat: 55, long: 22),
        UserLocation(name: "UAE (Premium)", imageName: "uae", lat: 25.20, long: 55.27)
    ]
    
    
    var swithStatus = [true, false]
    
    
    func onVPNAnimation() {
        guard let path = Bundle.main.path(forResource: "vpn", ofType:".mp4") else {
             
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resize

        videoView.layer.addSublayer(avPlayerLayer)
        player.play()
    }
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
     
       
     onVPNAnimation()
        
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        
        connect.layer.cornerRadius = 25
     
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
        } else {
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
        
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self

        navigationController?.navigationBar.prefersLargeTitles = true
         
        connect.titleLabel?.textAlignment = .center
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        avPlayerLayer.frame = videoView.layer.bounds
    }
   


    
    var statusVPN = false
    
    @IBAction func connect(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        
        generator.impactOccurred()
        
        if statusVPN == false {
            VPN().connectVPN()
            statusVPN = true
        } else {
            VPN().disconnectVPN()
            statusVPN = false
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] Timer in
            
            let status = VPN().vpnManager.connection.status
            
            
            switch status {
            case NEVPNStatus.connected:
                connect.titleLabel?.text = "Отключить"
            
                UIView.animate(withDuration: 0.3) {
                    self.connect.backgroundColor = .systemRed
                }
                
                
                
                statusVPN = true
                
                
            case NEVPNStatus.invalid, NEVPNStatus.disconnected:
                connect.titleLabel?.text = "Подключиться"
             
             
                UIView.animate(withDuration: 0.3) {
                    self.connect.backgroundColor = .systemGreen
                }
                
                
            case NEVPNStatus.connecting , NEVPNStatus.reasserting:
                connect.titleLabel?.text = "Подключение"
                
                connect.titleLabel?.lineBreakMode = .byWordWrapping
                
                UIView.animate(withDuration: 0.3) {
                    self.connect.backgroundColor = UIColor.init(hexString: "2e6930")
                }
                
                
                
            case NEVPNStatus.disconnecting:
                connect.titleLabel?.text = "Подключиться"
              
                UIView.animate(withDuration: 0.3) {
                    self.connect.backgroundColor = .systemBlue
                }
                
                
            default:
                print("Unknown VPN connection status")
            }
            
        }
        
        
    }
        
       
        
    }
    
    
    




extension Main: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String?
    {
        
        return "Available servers"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MainCell
        
        
        switch indexPath.row {
        case 0:
            cell.country.text = servers[0].country
            cell.city.text = servers[0].city
            cell.picture.image = UIImage(named: imgFlags[0])
            cell.onVPN.isOn = swithStatus[0]
            
        case 1:
            cell.country.text = servers[1].country
            cell.city.text = servers[1].city
            cell.picture.image = UIImage(named: imgFlags[1])
            cell.onVPN.isOn = swithStatus[1]

            
            cell.hiddenServer.isHidden = false
            cell.hiddenServer.alpha = 0.1
            
        default:
            break
            
        }
        
        
        /*
         cell.country.text = servers[0][indexPath.row]
         cell.city.text = servers[1][indexPath.row]
         cell.picture.image = UIImage(named: imgFlags[indexPath.row])
         cell.onVPN.isOn = swithStatus[indexPath.row]
         */
  
        
        
        
        
        
        return cell
    }
    
    
}








