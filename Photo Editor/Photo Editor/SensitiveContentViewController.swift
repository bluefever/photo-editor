//
//  SensitiveContentViewController.swift
//  iOSPhotoEditor
//
//  Created by Adam Podsiadlo on 17/07/2020.
//

import UIKit
import TTSegmentedControl

public final class SensitiveContentViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var holdView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var sendMessage: UILabel!
    
    let screenSize = UIScreen.main.bounds.size
    
    let fullView: CGFloat = 100 // remainder of screen height
    
    var bottomPadding: CGFloat {
        var topPadding:CGFloat? = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top
        }
        
        return topPadding!
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.showsVerticalScrollIndicator = false
          
       
        
        let underlineAttriString = NSAttributedString(string: "send us a message",
                                                  attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.attributedText = underlineAttriString
        
        let image = UIImage(named: "scg_content", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imageView = UIImageView.init(frame: CGRect(x:16, y:16, width: scrollView.frame.width, height: scrollView.frame.height))
        imageView.image = image
        imageView.frame.size = image?.size ?? .zero
        scrollView.contentSize = CGSize(width: image!.size.width, height: image!.size.height + 32)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.sendMessageOnClick))
        sendMessage.isUserInteractionEnabled = true
        sendMessage.addGestureRecognizer(tap)
    }
    
    @objc
    func sendMessageOnClick(sender:UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.bluefever.com/talk-to-us") else {
          return
        }
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let `self` = self else { return }
            let frame = self.view.frame

            self.view.frame = CGRect(x: 0,
                                     y: self.bottomPadding + 40,
                                     width: frame.width,
                                     height: UIScreen.main.bounds.height - self.bottomPadding - 40)
            
            if #available(iOS 11.0, *) {
                self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                let path = UIBezierPath(roundedRect: self.view.bounds,
                                        byRoundingCorners: [.topRight, .topLeft],
                                        cornerRadii: CGSize(width: 20, height: 20))
                
                let maskLayer = CAShapeLayer()
                
                maskLayer.path = path.cgPath
                self.view.layer.mask = maskLayer
            }
            
            self.holdView.layer.cornerRadius = 3
            let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(SensitiveContentViewController.panGesture))
            gesture.delegate = self
            self.view.addGestureRecognizer(gesture)
            
            self.view.layer.cornerRadius = 20
            self.view.layer.masksToBounds = true
            
            self.view.layer.shadowColor = UIColor.black.cgColor
            self.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.view.layer.shadowOpacity = 0.36
            self.view.layer.shadowRadius = 8.0
            self.view.layer.masksToBounds = false
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 0) {
            self.topLine.backgroundColor = UIColor.init(hexString: "#EEEEEE")
        } else {
            self.topLine.backgroundColor = .white
        }
            
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Pan Gesture
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if y + translation.y >= fullView {
            let newMinY = y + translation.y
            self.view.frame = CGRect(x: 0, y: newMinY, width: view.frame.width, height: UIScreen.main.bounds.height - newMinY )
            self.view.layoutIfNeeded()
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((bottomPadding - y) / velocity.y )
            duration = duration > 1.3 ? 1 : duration
            //velocity is direction of gesture
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    if y + translation.y >= self.bottomPadding  {
                        self.removeBottomSheetView()
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.bottomPadding, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.bottomPadding)
                        self.view.layoutIfNeeded()
                    }
                } else {
                    if y + translation.y >= self.bottomPadding  {
                        self.view.frame = CGRect(x: 0, y: self.bottomPadding, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.bottomPadding)
                        self.view.layoutIfNeeded()
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.fullView)
                        self.view.layoutIfNeeded()
                    }
                }
                
            }, completion: nil)
        }
    }
    
    func removeBottomSheetView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}


