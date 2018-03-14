//
//  AddItemViewController.swift
//  DoughFlow
//
//  Created by admin on 3/12/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemViewController: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var itemText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        if itemText.text! == "" {
            displayAlert("Please enter a valid item")
        } else if priceText.text! == "" || Int(priceText.text!)! == 0 {
            displayAlert("Please enter a valid price")
        } else {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = itemText.text!
                    newItem.price = priceText.text!
                    self.realm.add(newItem)
                    
                    navigationController?.popViewController(animated: true)
                }
            } catch {
                print("Error saving item: \(error)")
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
