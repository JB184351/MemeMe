//
//  BottomTextFieldDelegate.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/12/22.
//

import Foundation
import UIKit

class BottomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
