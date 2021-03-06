//
//  AddItemViewController.swift
//  DoughFlow
//
//  Created by admin on 3/12/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class AddItemViewController: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var itemText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    
    func isStringADouble(string: String) -> Bool {
        return Double(string) != nil
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        if itemText.text! == "" {
            displayAlert("Please enter a valid item")
        } else if Int(priceText.text!) == 0 || !isStringADouble(string: priceText.text!) {
            displayAlert("Please enter a valid price")
        } else {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = itemText.text!
                    newItem.price = Double(priceText.text!)!
                    newItem.dateCreated = Date()
                    newItem.backgroundColor = UIColor.flatGreen.hexValue()
                    self.realm.add(newItem)
                    
                    navigationController?.popViewController(animated: true)
                }
            } catch {
                displayAlert("Error saving item: \(error)")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - textField data model method
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        
    }
    
}
