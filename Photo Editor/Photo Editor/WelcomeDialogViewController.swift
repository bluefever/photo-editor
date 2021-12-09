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
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides:[WelcomeSlide] = [];
    
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
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        self.view.bringSubviewToFront(pageControl)
    }
    
    @IBAction func okayButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createSlides() -> [WelcomeSlide] {
        let slide1:WelcomeSlide = Bundle.main.loadNibNamed("WelcomeSlide", owner: self, options: nil)?.first as! WelcomeSlide
        slide1.imageView.image = UIImage(named: "text_off")
        slide1.label.text = "Blue Fever is a 100% anonymous + judgment-free space for you to express your thoughts, feelings and experiences."
        
        let slide2:WelcomeSlide = Bundle.main.loadNibNamed("WelcomeSlide", owner: self, options: nil)?.first as! WelcomeSlide
        slide2.imageView.image = UIImage(named: "text_off")
        slide2.label.text = "Blue Fever is a 100% anonymous + judgment-free space for you to express your thoughts, feelings and experiences."
        
        let slide3:WelcomeSlide = Bundle.main.loadNibNamed("WelcomeSlide", owner: self, options: nil)?.first as! WelcomeSlide
        slide3.imageView.image = UIImage(named: "text_off")
        slide3.label.text = "Blue Fever is a 100% anonymous + judgment-free space for you to express your thoughts, feelings and experiences."
        
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [WelcomeSlide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
}



