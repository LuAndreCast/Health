//
//  NumberCell.swift
//  HKTutorialPrototype
//

import UIKit

class NumberCell: UITableViewCell {
    
    @IBOutlet var numberTextField:UITextField!
    
    var doubleValue:Double {
        
        get {
            let numberString:NSString = NSString(string:numberTextField.text!)
            return numberString.doubleValue;
        }
    }
}


