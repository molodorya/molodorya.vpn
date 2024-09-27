//
//  ViewController.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 01.09.2024.
//

import UIKit
import NetworkExtension
import AVKit

import SceneKit



class Main: UIViewController {
    
    static var addedServer: [NewVPN] = []
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var connect: UIButton!

//    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var player: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    
    @IBOutlet weak var sceneView: SCNView!
    var modelNode: SCNNode!

    
    
    // MARK: - Создание 3D модели
    func addSceneViewModel() {
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = false
        
        // Загружаем модель
        let modelScene = SCNScene(named: "earth.dae")
        modelNode = modelScene?.rootNode.childNode(withName: "worldVPN", recursively: true)
     
        scene.rootNode.addChildNode(modelNode!)
        
    }
    
    
    // MARK: - Анимация 3D модели
    func rotateModel(status: Bool) {
        
        let rotateAction = SCNAction.rotate(by: CGFloat.pi * 0.10, around: SCNVector3(0, 1, 0), duration: 1)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        
        if status == true {
            modelNode.runAction(repeatAction)
        } else {
            modelNode.removeAllActions()
        }
        
        
    }

    
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addSceneViewModel()
        
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
            rotateModel(status: true)
           
        } else {
            VPN().disconnectVPN()
            statusVPN = false
            rotateModel(status: false)
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
                    if #available(iOS 13.0, *) {
                        self.connect.backgroundColor = .systemGray2
                    } else {
                        // Fallback on earlier versions
                    }
                    
                }
                
                
            case NEVPNStatus.connecting , NEVPNStatus.reasserting:
                connect.titleLabel?.text = "Подключение"
                
                connect.titleLabel?.lineBreakMode = .byWordWrapping
                
                UIView.animate(withDuration: 0.3) {
                    self.connect.backgroundColor = .systemYellow
                }
                
                
                
            case NEVPNStatus.disconnecting:
                connect.titleLabel?.text = "Отключение"
                
                UIView.animate(withDuration: 0.3) {
                    self.connect.backgroundColor = .systemRed
                   
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
            cell.statusLabel.text = ""

            
            cell.hiddenServer.isHidden = false
            cell.hiddenServer.alpha = 0.1
            
        default:
            break
            
        }
        
        return cell
    }
    
    
}








