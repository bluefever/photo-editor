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
    
    var slides:[WelcomeSlide] = [];
    var currentPage = 0;
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        dialogBoxView.layer.cornerRadius = 16.0
        
        dialogBoxView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        dialogBoxView.layer.shadowOpacity = 1.0
        dialogBoxView.layer.shadowRadius = 8.0
        dialogBoxView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dialogBoxView.layer.masksToBounds = false
        
        continueButton.backgroundColor = UIColor(hexString: "#4150BE")
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 25.0
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        self.view.bringSubviewToFront(pageControl)
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
        slide1.label.numberOfLines = 0
        slide1.label.textAlignment = .center
        slide1.label.attributedText = attributedText(withString: "Blue Fever is a 100% anonymous + judgment-free space for you to\nexpress your thoughts, feelings and\n experiences.\n", boldString: "100% anonymous + judgment-free", font: UIFont.init(name: "Cheria", size: 16)!)
        
        let slide2:WelcomeSlide = bundle.loadNibNamed("WelcomeSlideView_1", owner: nil, options: nil)?.first as! WelcomeSlide
        slide2.imageView.image = UIImage(named: "slide_2", in: imgBundle, compatibleWith: nil)
//        slide2.label.text = "Blue Fever is a 100% anonymous + judgment-free space for you to express your thoughts, feelings and experiences."
        
        return [slide1, slide2]
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    func setupSlideScrollView(slides : [WelcomeSlide]) {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[i])
        }
        
        print(scrollView.subviews.count)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
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


