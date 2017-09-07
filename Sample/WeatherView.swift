//
//  WeatherView.swift
//  Sample
//
//  Created by Erik Bean on 9/7/17.
//  Copyright © 2017 Erik Bean. All rights reserved.
//

import UIKit

class WeatherView: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var descript: UITextView!
    
    var json: [String: Any]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = JSON(object: self.json)
        
        // Get the weather description
        if let description = json["weather"][0]["description"].string{
            self.descript.text = description
        }
        
        // The temperature
        if let temp = json["main"]["temp"].double {
            self.temp.text = "\(self.fixTempForDisplay(temp))°"
            
        }
        
        // The minimum temperature
        if let minTemp = json["main"]["temp_min"].double {
            self.low.text = "\(self.fixTempForDisplay(minTemp))"
        }
        
        // The maximum temperature
        if let maxTemp = json["main"]["temp_max"].double {
            self.high.text = "\(self.fixTempForDisplay(maxTemp))"
        }
        
        // City name
        if let city = json["name"].string {
            name.text = city
        }
        
        if let weatherImage = json["weather"][0]["icon"].string {
            self.picture.image = UIImage(named: weatherImage)
        }
        
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        return dateFormatter.string(from: date)
    }
    
    func fixTempForDisplay(_ temp: Double) -> String {
        let tempC = temp - 272.15
        let tempF = (tempC * 1.8) + 32
        let tempR = round(tempF)
        let tempString = String(format: "%.0f", tempR)
        return tempString
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
