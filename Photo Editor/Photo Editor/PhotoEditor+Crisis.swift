//
//  PhotoEditor+Crisis.swift
//
//  Created by Adam Podsiadlo on 18/12/2021.
//

import Foundation
import UIKit
import KMPlaceholderTextView

enum CrisisTerm {
    case toxic
    case active
}

enum CrisisToastMode {
    case collapsed
    case toast
}

extension PhotoEditorViewController {
    func showToxicTermToast () {
        crisisLabel.text = "I spotted some word(s) that our community flagged in the past, so this page can only be posted privately."
        toastBlueImage.image = UIImage(named: "toast_alert_red", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        alertButton.setImage(UIImage(named: "icon_alert_red", in: Bundle(for: type(of: self)), compatibleWith: nil)!, for: .normal)
        
        if (crisisToastMode == .collapsed) {
            alertButton.isHidden = false
            
            if (!crisisToast.isHidden) {
                crisisToast.fadeOut()
            }
        } else {
            alertButton.isHidden = true
            
            if (crisisToast.isHidden) { 
                crisisToast.fadeIn()
            }
        }
    }
    
    func showActiveTermToast () {
        crisisLabel.text = "It looks like your page mentions a sensitive topic. Pls note, there’ll be a special TW label if posted publicly 💙"
        toastBlueImage.image = UIImage(named: "toast_alert_blue", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        alertButton.setImage(UIImage(named: "icon_alert_blue", in: Bundle(for: type(of: self)), compatibleWith: nil)!, for: .normal)
        
        if (crisisToastMode == .collapsed) {
            alertButton.isHidden = false
            
            if (!crisisToast.isHidden) {
                crisisToast.fadeOut()
            }
        } else {
            alertButton.isHidden = true
            
            if (crisisToast.isHidden) {
                crisisToast.fadeIn()
            }
        }
    }
    
    func hideToast () {
        crisisToast.fadeOut()
        alertButton.isHidden = false
        crisisToastMode = .collapsed
    }
    
    func clearCrisisViews () {
        crisisToast.isHidden = true
        alertButton.isHidden = true
        crisisToastMode = .toast
    }
    
    func verifyTextContent () -> [String] {
        var foundCrisisTerm: CrisisTerm? = nil
        var crisisTerms: [String] = []
        
        for view in canvasImageView.subviews {
            if view.subviews.count == 1 && view.subviews[0] is KMPlaceholderTextView {
                let textView = (view.subviews[0] as! KMPlaceholderTextView)
                
                if let text = textView.text {
                    for toxicWord in activeToxicTerms {
                        let searchPattern = "\\b" + NSRegularExpression.escapedPattern(for: toxicWord) + "\\b"
                        let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)
                        
                        for _ in regex.matches(in: text, range: NSRange(0..<text.utf16.count)) {
                            if (!crisisTerms.contains(toxicWord)) {
                                crisisTerms.append(toxicWord)
                            }
                            
                            foundCrisisTerm = .toxic
                            
                            textView.highlight(searchedText: toxicWord)
                        }
                    }
                    
                    for term in activeTerms {
                        let searchPattern = "\\b" + NSRegularExpression.escapedPattern(for: term) + "\\b"
                        let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)

                        for _ in regex.matches(in: text, range: NSRange(0..<text.utf16.count)) {
                            if (!crisisTerms.contains(term)) {
                                crisisTerms.append(term)
                            }
                            
                            if (foundCrisisTerm != .toxic) {
                                foundCrisisTerm = .active
                            }

                        }
                        
                        if term == "@" {
                            if (!crisisTerms.contains(term)) {
                                crisisTerms.append(term)
                            }
                            
                            textView.highlightAt(searchedText: term)
                            
                            if (foundCrisisTerm != .toxic) {
                                foundCrisisTerm = .active
                            }
                        }
                    }
                }
            }
        }
        
        self.crisisTerm = foundCrisisTerm
        
        return crisisTerms
    }
    
    @IBAction func alertButtonTapped(_ sender: Any) {
        crisisToastMode = .toast

        if (crisisTerm == .toxic) {
            showToxicTermToast()
        } else {
            showActiveTermToast()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        closeToastButton.blink()
        hideToast()
    }
}
