//
//  NormalPopup.swift
//  CustomDialogBox
//
//  Created by Shubham Singh on 01/04/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

public final class WelcomeDialogViewController: UIViewController {
    @IBOutlet weak var dialogBoxView: UIView!
    @IBOutlet weak var okayButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        dialogBoxView.layer.cornerRadius = 16.0
        
        dialogBoxView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        dialogBoxView.layer.shadowOpacity = 1.0
        dialogBoxView.layer.shadowRadius = 8.0
        dialogBoxView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dialogBoxView.layer.masksToBounds = false
        
        okayButton.backgroundColor = UIColor(hexString: "#4150BE")
        okayButton.setTitleColor(UIColor.white, for: .normal)
        okayButton.layer.cornerRadius = 25.0
        
    }
    
    @IBAction func okayButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}



