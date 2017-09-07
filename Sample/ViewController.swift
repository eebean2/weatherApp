//
//  ViewController.swift
//  Sample
//
//  Created by Erik Bean on 9/7/17.
//  Copyright © 2017 Erik Bean. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var loadingView: UIView!
    
    var manager: CLLocationManager!
    var json: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.layer.cornerRadius = 7
        
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        }
        
        let weatherTap = UITapGestureRecognizer(target: self, action: #selector(weatherSegue(_:)))
        weatherTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(weatherTap)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Did Fail With Error: \(error.localizedDescription)")
    }
    
    func weatherSegue(_ sender: UITapGestureRecognizer) {
        loadingView.isHidden = false
        let tapLocation = sender.location(in: mapView)
        let coordinates = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&APPID=350fd3fd98416e598868a5d33e2245fb")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        self.json = json
                        self.performSegue(withIdentifier: "weather", sender: self)
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
        
        print("Tapped at lat: \(coordinates.latitude) long: \(coordinates.longitude)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! UINavigationController
        let weather = dest.topViewController as! WeatherView
        weather.json = self.json
        loadingView.isHidden = false
    }
}

