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


class A {
    var status = false
}



@available(iOS 13.0, *)
class Main: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var connect: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var topAlertView: UIView!
    @IBOutlet weak var topAlertLabel: UILabel!
    @IBOutlet weak var topAlertConstrains: NSLayoutConstraint!

    static var addedServer: [NewVPN] = []
    static var statusToggle: Bool = true
    var player: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var statusVPN = false
    
    @IBOutlet weak var sceneView: SCNView!
    var modelNode: SCNNode!

    
    
    
    let imgFlags = ["Нидерланды", "uae"]
    
    
    
    var servers = [
        ServerLocation(country: "Нидерланды", city: "Амстердам", imgFlag: "netherlands")
    ]
    
  
    
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSceneViewModel()
        
        animationTopAlertView(isShow: true)
        
        getDataVPN().getDataFromJSON()
        
        checkStatusSwith()
        
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        
        connect.layer.cornerRadius = 25
        topAlertView.layer.cornerRadius = 30
        
        
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
    
    
    func checkStatusSwith() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] Timer in
            if Main.statusToggle == true {
                connect.isEnabled = true
            } else {
                let status = VPN().vpnManager.connection.status
                
                switch status {
                case NEVPNStatus.connected:
                    VPN().disconnectVPN()
                    statusVPN = false
                    rotateModel(status: false)
                    self.connect.backgroundColor = .systemGray2
                default:
                    break
                }
                
                connect.isEnabled = false
            }
        }
    }
    
   
    
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
    
    
    
    // MARK: - Создание 3D модели
    func addSceneViewModel() {
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = false
        
        // Загружаем модель
        let modelScene = SCNScene(named: "earth.dae")
        modelNode = modelScene?.rootNode.childNode(withName: "earth", recursively: true)
   
     
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

    
    // MARK: - Уведомление TopView
    func animationTopAlertView(isShow: Bool) {
        
        self.view.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            UIView.animate(withDuration: 0.6) {
              
                self.topAlertConstrains.constant = 65
                self.view.layoutSubviews()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    UIView.animate(withDuration: 0.6) {
                        self.topAlertConstrains.constant = -100
                        self.view.layoutSubviews()
                    }
                })
            }
        })
        
        self.view.layoutIfNeeded()
    }
    
}

    






@available(iOS 13.0, *)
extension Main: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.textColor = .white // any color
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Доступные серверы"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MainCell
        
        cell.country.text = servers[0].country
        cell.city.text = servers[0].city
        cell.picture.image = UIImage(named: servers[0].imgFlag!)
        cell.onVPN.isOn = true
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(hexString: "1E1E1E")
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    
}








