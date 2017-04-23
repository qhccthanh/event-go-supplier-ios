//
//  EVMapPopupViewController.swift
//  EventGoS
//
//  Created by Quach Ha Chan Thanh on 4/23/17.
//  Copyright © 2017 Event Go. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit
import STPopup

class EVMapPopupViewController: UIViewController {

    var mapView: GMSMapView!
    var geocode: EVGeocode?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        STPopupNavigationBar.appearance().barTintColor = UIColor(red: CGFloat(0.20), green: CGFloat(0.60), blue: CGFloat(0.86), alpha: CGFloat(1.0))
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName: UIColor.white]
        
        mapView = GMSMapView()
        self.view.addSubview(mapView)
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if let geocode = geocode {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: geocode.coordinate.lat, longitude: geocode.coordinate.lng))
            marker.title = geocode.formatted_address
            marker.map = mapView
            
            mapView.camera = GMSCameraPosition(target: marker.position, zoom: 17, bearing: 0, viewingAngle: 0)
        }
        
        let rootSize = self.view.frame.size
        let popupWidth = rootSize.width * 0.9
        contentSizeInPopup = CGSize(width: popupWidth, height: popupWidth * 1.2)
        
        self.title = "Bản đổ"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
