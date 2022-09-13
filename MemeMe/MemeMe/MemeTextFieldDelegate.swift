//
//  TopTextFieldDelegate.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/12/22.
//

import Foundation
import UIKit

class MemeTextFieldDelegate:  NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
