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
        crisisLabel.text = "Your page contains sensitive content\nand will default to private view to\nensure a safe space for all."
        crisisLabel.highlight(searchedText: "sensitive content")
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
        crisisLabel.text = "It looks like your page mentions a sensitive topic. To be mindful of others,\na TW label will be auto-enabled."
        crisisLabel.highlight(searchedText: "sensitive topic")
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
        clearUnderlines()
    }
    
    func clearCrisisViews () {
        crisisToast.isHidden = true
        alertButton.isHidden = true
        crisisToastMode = .toast
    }
    
    func clearUnderlines () {
        for view in canvasImageView.subviews {
            if view.subviews.count == 1 && view.subviews[0] is KMPlaceholderTextView {
                let textView = (view.subviews[0] as! KMPlaceholderTextView)
                textView.clearAttributes()
            }
        }
    }
    
    func verifyTextContent () -> [String:[String]] {
        var foundCrisisTerm: CrisisTerm? = nil
        var crisisTerms: [String:[String]] = ["private": [], "tw": [], "exempt": []]
        
        for view in canvasImageView.subviews {
            if view.subviews.count == 1 && view.subviews[0] is KMPlaceholderTextView {
                let textView = (view.subviews[0] as! KMPlaceholderTextView)
                
                if let text = textView.text {
                    for toxicWord in privateTerms {
                        let searchPattern = "\\b" + NSRegularExpression.escapedPattern(for: toxicWord) + "\\b"
                        let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)
                        
                        for _ in regex.matches(in: text, range: NSRange(0..<text.utf16.count)) {
                            if (!crisisTerms["private"]!.contains(toxicWord)) {
                                crisisTerms["private"]!.append(toxicWord)
                            }
                            
                            foundCrisisTerm = .toxic
                            
                            if (crisisToastMode == .toast) {
                                textView.highlight(searchedText: toxicWord)
                            }
                        }
                    }
                    
                    for twWord in twTerms {
                        let searchPattern = "\\b" + NSRegularExpression.escapedPattern(for: twWord) + "\\b"
                        let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)

                        for _ in regex.matches(in: text, range: NSRange(0..<text.utf16.count)) {
                            if (!crisisTerms["tw"]!.contains(twWord)) {
                                crisisTerms["tw"]!.append(twWord)
                            }
                            
                            if (foundCrisisTerm != .toxic) {
                                foundCrisisTerm = .active
                            }
                            
                            if (crisisToastMode == .toast) {
                                textView.highlight(searchedText: twWord)
                            }
                        }
                        
                        if twWord == "@" && text.contains("@") {
                            if (!crisisTerms["tw"]!.contains(twWord)) {
                                crisisTerms["tw"]!.append(twWord)
                            }
                            
                            if (crisisToastMode == .toast) {
                                textView.highlightAt(searchedText: twWord)
                            }
                            
                            if (foundCrisisTerm != .toxic) {
                                foundCrisisTerm = .active
                            }
                        }
                    }
                    
                    for exemptWord in exemptTerms {
                        let searchPattern = "\\b" + NSRegularExpression.escapedPattern(for: exemptWord) + "\\b"
                        let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)

                        for _ in regex.matches(in: text, range: NSRange(0..<text.utf16.count)) {
                            if (!crisisTerms["exempt"]!.contains(exemptWord)) {
                                crisisTerms["exempt"]!.append(exemptWord)
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
        verifyTextContent()

        if (crisisTerm == .toxic) {
            photoEditorDelegate?.onAnalyticsEvent(event: "pc_0020")
            showToxicTermToast()
        } else {
            photoEditorDelegate?.onAnalyticsEvent(event: "pc_0023")
            showActiveTermToast()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        closeToastButton.blink()
        hideToast()
        
        if (crisisTerm == .active) {
            self.photoEditorDelegate?.onAnalyticsEvent(event: "pc_0018")
        } else {
            self.photoEditorDelegate?.onAnalyticsEvent(event: "pc_0021")
        }
    }
}
