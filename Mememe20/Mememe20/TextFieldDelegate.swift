//
//  TextFieldDelegate.swift
//  PickingImages
//
//  Created by Jan Gundorf on 10/03/2019.
//  Copyright © 2019 Jan Gundorf. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate : NSObject, UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
    //If textfields are left empty reestablish their 'default texts'
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
        if (textField.accessibilityIdentifier == Constants.topLabel && textField.text == "")
        {
            textField.text = Constants.topLabel
        }
        
        if (textField.accessibilityIdentifier == Constants.bottomLabel && textField.text == "")
        {
            textField.text = Constants.bottomLabel
        }
        
    }
    //Resign their first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
