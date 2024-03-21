//
//  EmojiTextField.swift
//  Honnaeng
//
//  Created by Rarla on 3/22/24.
//

import UIKit

class EmojiTextField: UITextField {
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
