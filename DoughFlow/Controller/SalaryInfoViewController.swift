//
//  SalaryInfoViewController.swift
//  DoughFlow
//
//  Created by admin on 3/8/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit

class SalaryInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dollarsPerYearText: UITextField!
    @IBOutlet weak var hoursPerWeekText: UITextField!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dollarsPerYearText.keyboardType = .numberPad
        hoursPerWeekText.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dollarsSet = defaults.object(forKey: "dollarsPerYear") as! String! {
            dollarsPerYearText.text = dollarsSet
        }
        
        if let hoursSet = defaults.object(forKey: "hoursPerWeek") as! String! {
            hoursPerWeekText.text = hoursSet
        }
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }

    @IBAction func submitButton(_ sender: UIButton) {
        
        if Int(dollarsPerYearText.text!) == 0 || !isStringAnInt(string: dollarsPerYearText.text!) {
            displayAlert("Please enter a valid salary")
        } else if Int(hoursPerWeekText.text!) == 0 || !isStringAnInt(string: hoursPerWeekText.text!){
            displayAlert("Please enter a valid hours/week worked")
        } else {
            defaults.set(dollarsPerYearText.text, forKey: "dollarsPerYear")
            defaults.set(hoursPerWeekText.text, forKey: "hoursPerWeek")
            navigationController?.popViewController(animated: true)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - textField data model method
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        
    }

}

