//
//  CustomTextField.swift
//  iOSPhotoEditor
//
//  Created by Adam Podsiadlo on 10/08/2020.
//

import Foundation
import UIKit

class CustomTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()

        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = UIColor.init(hexString: "#4F5156")
            }
        }
    }
}
