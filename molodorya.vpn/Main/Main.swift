//
//  ViewController.swift
//  molodorya.vpn
//
//  Created by Nikita Molodorya on 01.09.2024.
//

import UIKit
import MapKit
import CoreLocation
import NetworkExtension

class Main: UIViewController {
    
    static var addedServer: [NewVPN] = []
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var connect: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    

    
    let imgFlags = ["netherlands", "uae"]
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    let annotation = MKPointAnnotation()
    
    var servers = [
        ServerLocation(country: "Netherlands", city: "Amsterdam", imgFlag: "netherlands", lat: 55, long: 22),
//        ServerLocation(country: "UAE (Premium)", city: "Dubai", imgFlag: "uae", lat: 25.20, long: 55.27)
    ]
    
    var users = [
        UserLocation(name: "Netherlands", imageName: "netherlands", lat: 55, long: 22),
        UserLocation(name: "UAE (Premium)", imageName: "uae", lat: 25.20, long: 55.27)
    ]
    
    
    var swithStatus = [true, false]
    
    
    
    @IBOutlet weak var tableView: UITableView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        
        connect.layer.cornerRadius = 25
        mapView.delegate = self
        
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
        
//        title = "Gradient VPN"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        mapView.delegate = self

        locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }

        }
        
        
        checkLocationEnable()
        connect.titleLabel?.textAlignment = .center
        
       
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         
         let center = CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 0.0, longitude: location?.coordinate.longitude ?? 0.0)
         let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 70, longitudeDelta: 0.01))
         
         mapView.setRegion(region, animated: true)
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








extension Main: CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        location = locations.last
//        print("\(locValue.longitude)", "\(locValue.latitude)")

//        ViewController.locationSetting = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
    }
    
   
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let annotation = view.annotation
        let index = (self.mapView.annotations as NSArray).index(of: annotation!)
        
        

        print ("Annotation Index = \(index)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let customAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotationViewID")
        customAnnotationView.canShowCallout = true
        
        customAnnotationView.userLabel.text = annotation.title ?? "No name"
        
        customAnnotationView.userImage.image = UIImage(named: servers[0].imgFlag!)
        
       


        mapView.addAnnotations(users)
        
        
        // Убирает текст
        guard !(annotation is MKUserLocation) else { return nil }
       
        
        return customAnnotationView
    }
    
    
    func checkLocationEnable() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                
            } else {
                let alert = UIAlertController(title: "Нет доступа к геолокации", message: "Хотите включить?", preferredStyle: .alert)
                let settingAction = UIAlertAction(title: "Да", style: .default, handler: { alert in
                    if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                })
                let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
                
                alert.addAction(settingAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}




class CustomAnnotationView: MKAnnotationView {
    private let annotationFrame = CGRect(x: 0, y: 0, width: 70, height: 70)
    let sizeView = 70
    
    
    let viewing = UIView()
    let userImage = UIImageView()
    let userLabel = UILabel()
    
    
    
    @available(iOS 13.0, *)
    func naming(image: UIImage?, name: String?) {
        
        viewing.frame = CGRect(x: 0, y: 0, width: sizeView, height: sizeView)
        viewing.backgroundColor = .systemGray
        viewing.layer.borderWidth = 1
        viewing.layer.borderColor = UIColor.label.cgColor
        viewing.layer.cornerRadius = viewing.frame.height / 2
        
        
        userImage.frame = CGRect(x: 0, y: 0, width: sizeView, height: sizeView)
        userImage.backgroundColor = .systemGray6
        userImage.contentMode = .scaleAspectFill
        userImage.backgroundColor = .clear
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.masksToBounds = true
       
    
        // Если менять sizeView, то позицию y нужно отдельно калибровать
        userLabel.text = ""
        userLabel.font = UIFont.boldSystemFont(ofSize: 7)
        userLabel.textColor = .label
        userLabel.textAlignment = .center
        userLabel.frame = CGRect(x: 0, y: 30, width: sizeView, height: sizeView)
    }
    
  
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
     
       
        if #available(iOS 13.0, *) {
            naming(image: UIImage(named: "uae"), name: nil)
        } else {
            // Fallback on earlier versions
        }
       
      
        
        
        
        viewing.addSubview(userImage)
        viewing.addSubview(userLabel)
        
        
        
       
       
        self.frame = annotationFrame
    
         
        self.backgroundColor = .clear
        
        self.addSubview(viewing)
        
 
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }
}


 
