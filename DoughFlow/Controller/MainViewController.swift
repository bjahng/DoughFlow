//
//  MainViewController.swift
//  DoughFlow
//
//  Created by admin on 3/8/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

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
        subscribeToKeyboardNotifications()
        
        if let dollarsSet = defaults.object(forKey: "dollarsPerYear") as! String! {
            dollarsPerYearText.text = dollarsSet
        }
        
        if let hoursSet = defaults.object(forKey: "hoursPerYear") as! String! {
            hoursPerWeekText.text = hoursSet
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func submitButton(_ sender: UIButton) {
        
        if dollarsPerYearText.text! == "" || Int(dollarsPerYearText.text!)! == 0 {
            displayAlert("Please enter a valid salary")
        } else if hoursPerWeekText.text! == "" || Int(hoursPerWeekText.text!)! == 0 {
            displayAlert("Please enter a valid hours/week worked")
        } else {
            defaults.set(dollarsPerYearText.text, forKey: "dollarsPerYear")
            defaults.set(hoursPerWeekText.text, forKey: "hoursPerYear")
            displayAlert("Salary and hours/week data saved!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - keyboard control methods
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if hoursPerWeekText.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - textField data model method
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        
    }

}

