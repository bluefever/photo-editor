//
//  NormalPopup.swift
//  CustomDialogBox
//
//  Created by Shubham Singh on 01/04/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

public final class WelcomeDialogViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var dialogBoxView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var container: UIView!
    
    var slides:[WelcomeSlide] = [];
    var currentPage = 0;
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        dialogBoxView.layer.cornerRadius = 16.0
        dialogBoxView.backgroundColor = .white
        
        dialogBoxView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        dialogBoxView.layer.shadowOpacity = 1.0
        dialogBoxView.layer.shadowRadius = 8.0
        dialogBoxView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dialogBoxView.layer.masksToBounds = false
        
        continueButton.backgroundColor = UIColor(hexString: "#4150BE")
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 25.0
        
        slides = createSlides()
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        self.view.bringSubviewToFront(pageControl)
    }
    
    public override func viewDidLayoutSubviews() {
        
        setupSlideScrollView(slides: slides)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if (currentPage == 0) {
            scrollView.setCurrentPage(position: 1)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func createSlides() -> [WelcomeSlide] {
        let bundle = Bundle(for: WelcomeSlide.self)
        let imgBundle = Bundle(for: type(of: self))
        
        let slide1:WelcomeSlide = bundle.loadNibNamed("WelcomeSlideView_1", owner: nil, options: nil)?.first as! WelcomeSlide
        slide1.imageView.image = UIImage(named: "slide_1", in: imgBundle, compatibleWith: nil)
        slide1.label.numberOfLines = 5
        slide1.label.textAlignment = .center
        slide1.label.attributedText = attributedText(withString: "Blue Fever is a 100% anonymous +\njudgment-free space for you to\nexpress your thoughts, feelings and  experiences.\n", boldString: "100% anonymous +\njudgment-free", font: UIFont.init(name: "DMSans-Regular", size: 15)!, withColor: false)
        
        
        let slide2:WelcomeSlide = bundle.loadNibNamed("WelcomeSlideView_1", owner: nil, options: nil)?.first as! WelcomeSlide
        slide2.imageView.image = UIImage(named: "slide_2", in: imgBundle, compatibleWith: nil)
        slide2.label.numberOfLines = 5
        slide2.label.textAlignment = .center
        slide2.label.attributedText = attributedText(withString: "In order to maintain a supportive space for all, if sensitive topics are mentioned, we may add a simple TW on your page or default it to private. Learn more.\n", boldString: "Learn more.", font: UIFont.init(name: "DMSans-Regular", size: 15)!, withColor: true)
        slide2.label.isUserInteractionEnabled = true
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        slide2.label.lineBreakMode = .byWordWrapping
        slide2.label.addGestureRecognizer(tapgesture)

        
        return [slide1, slide2]
    }
    
    //MARK:- tappedOnLabel
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: self.slides[1].label, targetText: "Learn more.") {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
            
            let backgroundViewController = BackgroundViewController(nibName: "BackgroundViewController", bundle: Bundle(for: BackgroundViewController.self))
            
            self.addChild(backgroundViewController)
            self.view.addSubview(backgroundViewController.view)
            backgroundViewController.didMove(toParent: self)
            let height = view.frame.height
            let width  = view.frame.width
            backgroundViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY , width: width, height: height)
        }
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont, withColor: Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        
        let colorAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#4150BE")]
        
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        if (withColor) {
            attributedString.addAttributes(colorAttribute, range: range)
        }
        
        return attributedString
    }
    
    func setupSlideScrollView(slides : [WelcomeSlide]) {
        scrollView.contentSize = CGSize(width: container.frame.width * CGFloat(slides.count), height: container.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: container.frame.width * CGFloat(i), y: 0, width: container.frame.width, height: container.frame.height)
            scrollView.addSubview(slides[i])
        }
        
        print(scrollView.subviews.count)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / container.frame.width)
        pageControl.currentPage = Int(pageIndex)
    
        currentPage = Int(pageIndex)
        
        if (currentPage == 1) {
            continueButton.setTitle("sounds good", for: .normal)
        } else {
            continueButton.setTitle("next", for: .normal)
        }
    }
}

extension UIScrollView {
    func setCurrentPage(position: Int) {
        var frame = self.frame;
        frame.origin.x = frame.size.width * CGFloat(position)
        frame.origin.y = 0
        scrollRectToVisible(frame, animated: true)
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
            guard let attributedString = label.attributedText, let lblText = label.text else { return false }
            let targetRange = (lblText as NSString).range(of: targetText)
            //IMPORTANT label correct font for NSTextStorage needed
            let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
            mutableAttribString.addAttributes(
                [NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize],
                range: NSRange(location: 0, length: attributedString.length)
            )
            // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: CGSize.zero)
            let textStorage = NSTextStorage(attributedString: mutableAttribString)

            // Configure layoutManager and textStorage
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)

            // Configure textContainer
            textContainer.lineFragmentPadding = 0.0
            textContainer.lineBreakMode = label.lineBreakMode
            textContainer.maximumNumberOfLines = label.numberOfLines
            let labelSize = label.bounds.size
            textContainer.size = labelSize

            // Find the tapped character location and compare it to the specified range
            let locationOfTouchInLabel = self.location(in: label)
            let textBoundingBox = layoutManager.usedRect(for: textContainer)
            let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
            let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
                locationOfTouchInLabel.y - textContainerOffset.y);
            let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

            return NSLocationInRange(indexOfCharacter, targetRange)
        }
}

