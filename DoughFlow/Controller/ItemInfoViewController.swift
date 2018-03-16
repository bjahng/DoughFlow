//
//  ItemInfoViewController.swift
//  DoughFlow
//
//  Created by admin on 3/12/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit

class ItemInfoViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var selectedItem: Item!
    var salary: Double?
    var hours: Double?
    var finalTime: String = ""
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateTime()
        
        infoLabel.text = "You have to work \(finalTime) for you to buy \(selectedItem.title)."
    }
    
    func calculateTime() {
        
        let price = Double(selectedItem.price)!
        
        let earnInOneSecond: Double = salary!/52/hours!/60/60
        
        let timeInSeconds: Double = Double(price)/earnInOneSecond
        let timeInMinutes: Double = timeInSeconds/60
        let timeInHours: Double = timeInSeconds/3600
        
        if timeInSeconds < 60 {
            let newTimeInSeconds = Int(timeInSeconds)
            if newTimeInSeconds == 0 {
                finalTime = "\n less than 1 second"
            } else {
                finalTime = "\n\(newTimeInSeconds) second(s)"
            }
        } else if timeInSeconds < 3600 {
            let newTimeInMinutes = Int(timeInMinutes)
            finalTime = "about \n\(newTimeInMinutes) minute(s)"
        } else {
            let newTimeInHours = Int(timeInHours)
            finalTime = "about \n\(newTimeInHours) hour(s)"
        }
    }
    
}
