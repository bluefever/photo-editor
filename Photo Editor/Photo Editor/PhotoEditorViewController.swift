//
//  ViewController.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

public final class PhotoEditorViewController: UIViewController {
    
    //To hold background image
    @IBOutlet weak var imageBg: UIImageView!
    /** holding the 2 imageViews original image and drawing & stickers */
    @IBOutlet weak var canvasView: UIView!
    //To hold the image
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    //To hold the drawings and stickers
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var bottomToolbar: UIView!
    @IBOutlet weak var toolbars: TouchableStackView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var colorPickerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textSizeSlider: UISlider!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var controlsView: UIView!
    
    //Controls
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topTextSizeButton: UIButton!
    @IBOutlet weak var topTextStyleButton: UIButton!
    @IBOutlet weak var topTextColorButton: UIButton!
    @IBOutlet weak var topTextControl: UIStackView!
    @IBOutlet weak var bottomStyleContainer: UIView!
    @IBOutlet weak var bottomColorContainer: UIView!
    @IBOutlet weak var bottomSizeContainer: UIView!
    @IBOutlet weak var styleFont1Button: UIButton!
    @IBOutlet weak var styleFont2Button: UIButton!
    @IBOutlet weak var styleFont3Button: UIButton!
    @IBOutlet weak var styleFont4Button: UIButton!
    @IBOutlet weak var styleFont5Button: UIButton!
    @IBOutlet weak var styleFont6Button: UIButton!
    @IBOutlet weak var styleAlignButton: UIButton!
    
    @IBOutlet weak var centerHorizontalView: UIView!
    @IBOutlet weak var centerVerticalView: UIView!
    
    @objc public var image: UIImage?
    /**
     Array of Stickers -UIImage- that the user will choose from
     */
    @objc public var stickers : [UIImage] = []
    /**
     Array of Colors that will show while drawing or typing
     */
    @objc public var colors  : [UIColor] = []
    /**
     Array of Background colors  that the user will choose from
     */
    @objc public var bgColors : [String] = []
    /**
     Array of Background Images that the user will choose from
     */
    @objc public var bgImages : [String] = []
    /**
     Array of template categories
     */
    @objc public var backgroundCategoriesJson : String?
    /**
     Initial background template
     */
    @objc public var initialBgUrl : String?
    
    /**
     Dictionary of backgrounds by category
     */
    @objc public var backgroundsByCategoryJson : String?
    
    /**
    Json data to import expression
    */
    @objc public var initialData: String?
    
    @objc public var photoEditorDelegate: PhotoEditorDelegate?
    var colorsCollectionViewDelegate: ColorsCollectionViewDelegate!
    
    // list of controls to be hidden
    @objc public var hiddenControls : [NSString] = []
    
    var backgroundsByCategory: Dictionary<String, [Background]> = [:]
    var backgroundCategories: [BackgroundCategory] = []
    var imageBgName: String? = nil
    var backgroundVCIsVisible = false
    var gifsStickersVCIsVisible = false
    var drawColor: UIColor = UIColor.black
    var textColor: UIColor = UIColor.black
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var swiped = false
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: KMPlaceholderTextView?
    var imageViewToPan: UIImageView?
    var isTyping: Bool = false
    var gifsImages: [UIImageView] = []
    var gifsSources: [GifImage] = []
    
    var gifsStickersViewController: GifsStickersViewController!
    var backgroundViewController: BackgroundViewController!
    var renderCount: Int = 0
    var imported: Bool = false
    
    //Register Custom font before we load XIB
    public override func loadView() {
        registerFont()
        super.loadView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        importBackgroundsByCategory(data: backgroundsByCategoryJson!, categories: backgroundCategoriesJson!)
        prepareBackgrounds()
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
        gifsStickersViewController = GifsStickersViewController(nibName: "GifsStickersViewController", bundle: Bundle(for: GifsStickersViewController.self))
        
        backgroundViewController = BackgroundViewController(nibName: "BackgroundViewController", bundle: Bundle(for: BackgroundViewController.self))
        
        hideControls()
        configureCollectionView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        renderCount += 1
        
        if (renderCount > 1 && !imported) {
            imported = true
            
            if let expression = initialData {
                importExpression(data: expression)
                enableNextButton()
            }
        }
    }
    
    @IBAction func slider(_ sender: Any) {
        if let textView = activeTextView {
            lastTextViewFont = lastTextViewFont?.withSize(CGFloat(Int(textSizeSlider.value)))
            textView.font = lastTextViewFont
            
            var sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - 40, height:CGFloat.greatestFiniteMagnitude))
            
            if (textView.text.count == 0) {
                sizeToFit.height = 90
            }
            
            textView.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 40,
                                          height: sizeToFit.height)
            textView.setNeedsDisplay()
        }
    }
    
    func prepareBackgrounds() {
        bgImages.shuffle()
        
        if let background = initialBgUrl {
            let matches = background.matchingStrings(regex: "(/backgroundThumbs%2F[a-zA-Z0-9_-]+).png")
            
            if (matches.count == 1 && matches[0].count == 2) {
                self.setBackgroundImage(image: background, internalId: (matches[0][1]).replacingOccurrences(of: "/backgroundThumbs%2F", with: ""))
            } else {
                let matches = background.matchingStrings(regex: "(/backgroundThumbs/[a-zA-Z0-9_-]+).png")

                if (matches.count == 1 && matches[0].count == 2) {
                    self.setBackgroundImage(image: background, internalId: (matches[0][1]).replacingOccurrences(of: "/backgroundThumbs/", with: ""))
                }
            }
        }
    }
    
    func prepareUI() {
        styleFont1Button.layer.cornerRadius = styleFont1Button.frame.size.height / 2
        styleFont1Button.backgroundColor = UIColor.white
        styleFont1Button.addShadow()
        styleFont2Button.layer.cornerRadius = styleFont1Button.frame.size.height / 2
        styleFont2Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont2Button.addShadow()
        styleFont3Button.layer.cornerRadius = styleFont1Button.frame.size.height / 2
        styleFont3Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont3Button.addShadow()
        styleFont4Button.layer.cornerRadius = styleFont1Button.frame.size.height / 2
        styleFont4Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont4Button.addShadow()
        styleFont5Button.layer.cornerRadius = styleFont1Button.frame.size.height / 2
        styleFont5Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont5Button.addShadow()
        styleFont6Button.layer.cornerRadius = styleFont1Button.frame.size.height / 2
        styleFont6Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont6Button.addShadow()
        styleAlignButton.addShadow()
        
        doneButton.layer.cornerRadius = continueButton.bounds.height / 2
        doneButton.clipsToBounds = true
        continueButton.layer.cornerRadius = continueButton.bounds.height / 2
        continueButton.clipsToBounds = true
        
        controlsView.layer.cornerRadius = 20
        controlsView.clipsToBounds = true
        
        controlsView.layer.shadowColor = UIColor.black.cgColor
        controlsView.layer.shadowOffset = CGSize(width: 0, height: 0)
        controlsView.layer.shadowOpacity = 0.16
        controlsView.layer.shadowRadius = 8.0
        controlsView.layer.masksToBounds = false
        
        if #available(iOS 11.0, *) {
            self.controlsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            let path = UIBezierPath(roundedRect: controlsView.bounds,
                                    byRoundingCorners: [.topRight, .topLeft],
                                    cornerRadii: CGSize(width: 20, height: 20))
            
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            controlsView.layer.mask = maskLayer
        }
        
        paintSafeAreaBottomInset(withColor: .white)
        
        textSizeSlider.setThumbImage(UIImage(named: "icon_thumb", in: Bundle(for: type(of: self)), compatibleWith: nil)!, for: .normal)
        textSizeSlider.value = 20
        textSizeSlider.minimumTrackTintColor = UIColor.white
        
        textSizeSlider.maximumTrackTintColor = UIColor.init(hexString: "#c1c1d1")
        
        setBackgroundImage(image: (UIImage(named: "default_bg_v2", in: Bundle(for: type(of: self)), compatibleWith: nil)!))
        
        prepareTopTextButtons()
    }
    
    
    func prepareTopTextButtons() {
        topTextSizeButton.addShadow()
    }
    
    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 24) / 10
        layout.itemSize = CGSize(width: width, height: 28)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        colorsCollectionView.collectionViewLayout = layout
        colorsCollectionViewDelegate = ColorsCollectionViewDelegate()
        colorsCollectionViewDelegate.initialColor = textColor
        colorsCollectionViewDelegate.colorDelegate = self
        colorsCollectionView.isScrollEnabled = false
        if !colors.isEmpty {
            colorsCollectionViewDelegate.colors = colors
        }
        colorsCollectionView.delegate = colorsCollectionViewDelegate
        colorsCollectionView.dataSource = colorsCollectionViewDelegate
        colorsCollectionView.layer.masksToBounds = false
        colorsCollectionView.clipsToBounds = false
        colorsCollectionView.register(
            UINib(nibName: "ColorCollectionViewCell", bundle: Bundle(for: ColorCollectionViewCell.self)),
            forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
    func setImageView(image: UIImage) {
        imageView.image = image
        let size = image.suitableSize(widthLimit: UIScreen.main.bounds.width)
        imageViewHeightConstraint.constant = (size?.height)!
    }
    
    func setBackgroundImage(image: UIImage) {
        imageBg.image = image
    }
    
    func setBackgroundColor(color: String) {
        self.imageBg.image = nil
        self.imageBgName = nil
        self.imageBg.backgroundColor = UIColor(hexString: color)
        
        enableNextButton()
    }
    
    func setBackgroundImage(image: String, internalId: String) {
        imageBgName = internalId
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: image)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageBg.image = image
                    }
                }
            }
        }
        
       enableNextButton()
    }
    
    func hideToolbar(hide: Bool) {
        toolbars.isHidden = hide
//        topToolbar.isHidden = hide
//        bottomToolbar.isHidden = hide
        continueButton.isHidden = isTyping ? true : hide
        view.viewWithTag(UIViewController.insetBackgroundViewTag)?.isHidden = hide
    }
}

extension PhotoEditorViewController: ColorDelegate {
    func didSelectColor(color: UIColor) {
        if isDrawing {
            self.drawColor = color
        } else if activeTextView != nil {
            activeTextView?.textColor = color
            textColor = color
        }
    }
}
