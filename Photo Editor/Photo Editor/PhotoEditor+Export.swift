//
//  PhotoEditor+Export.swift
//  appcenter-analytics
//
//  Created by Adam Podsiadlo on 28/07/2020.
//

import Foundation
import UIKit
import KMPlaceholderTextView

struct GifImage {
    let image: UIImageView
    var url: String
    
    init(image: UIImageView, url: String) {
        self.image = image
        self.url = url
    }
}

struct Size: Codable, Hashable {
    let height: CGFloat
    let width: CGFloat
    
    init(width: CGFloat = 0, height: CGFloat = 0) {
        self.width = width
        self.height = height
    }
}

struct Point: Codable, Hashable {
    var x: CGFloat
    var y: CGFloat
    
    init(x: CGFloat = 0, y: CGFloat = 0) {
        self.x = x
        self.y = y
    }
}

struct Transform: Codable, Hashable {
    var a: CGFloat
    var b: CGFloat
    var c: CGFloat
    var d: CGFloat
    var tx: CGFloat
    var ty: CGFloat
    
    init(a: CGFloat = 0, b: CGFloat = 0, c: CGFloat = 0, d: CGFloat = 0, tx: CGFloat = 0, ty: CGFloat = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx
        self.ty = ty
    }
}

struct ExpressionLayer: Codable, Hashable {
    var size: Size?
    var transform: Transform?
    var center: Point
    var aspectRatio: Int?
    var zIndex: Int
    var angle: Int?
    var text: String?
    var textColor: String?
    var textStyle: String?
    var textAlign: String?
    var textSize: CGFloat?
    var contentUrl: String?
    
    init(size: Size? = nil, center: Point = Point(), aspectRatio: Int? = nil, zIndex: Int = 0, angle: Int? = nil,
         text: String? = nil, textColor: String? = nil, textSize: CGFloat? = nil, textStyle: String? = nil, textAlign: String? = nil, contentUrl: String? = nil, transform: Transform? = nil) {
        self.size = size
        self.center = center
        self.aspectRatio = aspectRatio
        self.zIndex = zIndex
        self.angle = angle
        self.text = text
        self.textColor = textColor
        self.textStyle = textStyle
        self.textSize = textSize
        self.contentUrl = contentUrl
        self.transform = transform
        self.textAlign = textAlign
    }
}

struct OriginalFrame: Codable, Hashable {
    var width: CGFloat
    var height: CGFloat
    
    init(height: CGFloat = 0, width: CGFloat = 0) {
        self.height = height
        self.width = width
    }
}

public struct Expression: Codable, Hashable {
    var backgroundColor: String?
    var backgroundImage: String?
    var backgroundSize: OriginalFrame?
    var originalFrame: OriginalFrame?
    var layers: [ExpressionLayer]
    
    init(originalFrame: OriginalFrame? = nil, backgroundSize: OriginalFrame? = nil, backgroundColor: String? = nil, backgroundImage: String? = nil, layers: [ExpressionLayer] = []) {
        self.originalFrame = originalFrame
        self.backgroundSize = backgroundSize
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.layers = layers
    }
}

extension PhotoEditorViewController {
    func pointFromAspectFill(for point: CGPoint, in view: UIImageView) -> Point {
        guard let img = view.image else {
            return Point.init(x: point.x, y: point.y)
        }

        let imgSize = img.size
        let viewSize = view.frame.size
        let aspectRatio = imgSize.width / viewSize.width
        let yOffset = ((imgSize.height / aspectRatio) - viewSize.height) / 2.0
        
        return Point.init(
            x: (point.x * aspectRatio),
            y: (point.y + yOffset) * aspectRatio)
    }
    
    func pointToAspectFill(for point: Point, in bgSize: OriginalFrame) -> Point {
        let aspectRatio = bgSize.width / self.view.frame.width
        let yOffset = ((bgSize.height / aspectRatio) - self.view.frame.height) / 2.0
        
        return Point.init(
            x: (point.x / aspectRatio),
            y: (point.y / aspectRatio) - yOffset)
    }
    
    public func exportExpression () -> String? {
        var expression = Expression()
        
        expression.originalFrame = OriginalFrame.init(height: UIScreen.main.bounds.height, width:
            UIScreen.main.bounds.width)
        
        if let imageName = imageBgName {
            expression.backgroundImage = imageName
            expression.backgroundSize = OriginalFrame.init(height: imageBg.image!.size.height, width: imageBg.image!.size.width)
        } else {
            expression.backgroundColor = imageBg.backgroundColor?.hexString
        }
        
        for view in canvasImageView.subviews {
            if view.subviews.count == 1 && view.subviews[0] is KMPlaceholderTextView {
                let textView = (view.subviews[0] as! KMPlaceholderTextView)
                let center = self.view.convert(textView.superview!.center, from: canvasImageView)
                
                var textLayer = ExpressionLayer()
                textLayer.textColor = textView.textColor?.hexString
                textLayer.textStyle = textView.font?.fontName
                textLayer.textSize = textView.font?.pointSize
                textLayer.textAlign = textView.alignmentToString()
                textLayer.zIndex = canvasImageView.subviews.index(of: view)!
                textLayer.text = textView.text
                textLayer.transform = Transform(a: view.transform.a, b: view.transform.b, c: view.transform.c,d: view.transform.d, tx: view.transform.tx, ty: view.transform.ty)
                
                if (expression.backgroundImage != nil) {
                    textLayer.center = pointFromAspectFill(for: center, in: imageBg)
                } else {
                    textLayer.center = Point(x: center.x, y: center.y)
                }
                
                if (textLayer.text != nil && !textLayer.text!.isEmpty) {
                    expression.layers.append(textLayer)
                }
            }
        }
        
        
        for gif in gifsSources {
            var gifLayer = ExpressionLayer()
            let center = self.view.convert(gif.image.center, from: canvasImageView)
            
            gifLayer.contentUrl = gif.url
            gifLayer.zIndex = canvasImageView.subviews.index(of: gif.image)!
            gifLayer.size = Size(width: gif.image.bounds.width, height: gif.image.bounds.height)
            gifLayer.transform = Transform(a: gif.image.transform.a, b: gif.image.transform.b, c: gif.image.transform.c,d: gif.image.transform.d, tx: gif.image.transform.tx, ty: gif.image.transform.ty)
            
            if (expression.backgroundImage != nil) {
                gifLayer.center = pointFromAspectFill(for: center, in: imageBg)
            } else {
                gifLayer.center = Point(x: center.x, y: center.y)
            }
            
            expression.layers.append(gifLayer)
        }
        
        var jsonData: String? = nil
        
        do {
            let encoder = JSONEncoder()
            
            
            let data = try encoder.encode(expression)
            jsonData = String(data: data, encoding: .utf8)
        } catch {
            print(error)
        }
        
        return jsonData
    }
    
    public func importExpression (data: String) {
        let jsonData = data.data(using: .utf8)!
        var expression: Expression? = nil
        
        do {
            expression = try JSONDecoder().decode(Expression.self, from: jsonData)
        } catch {
            print(error)
        }
        
        if var expressionData = expression {
            let bounds = UIScreen.main.bounds
            var scaleX = CGFloat(1)
            var scaleY = CGFloat(1)
            
            if (expressionData.originalFrame != nil) {
                scaleX = bounds.width / expressionData.originalFrame!.width
                scaleY = bounds.height / expressionData.originalFrame!.height
            }

            if let bgColor = expressionData.backgroundColor {
                setBackgroundColor(color: bgColor)
            } else if let bgImage = expressionData.backgroundImage {
                var bgUrl: String?
                
                for url in bgImages {
                    if (url.matchingStrings(regex: bgImage + ".png").count > 0) {
                        bgUrl = url
                    }
                }
                
                if let url = bgUrl {
                    imageBg.load(url: url)
                } else {
                    setBackgroundImage(image:  UIImage(named: "default_bg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
                }
            } else {
                setBackgroundImage(image:  UIImage(named: "default_bg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
            }
            
            expressionData.layers.sort{ $0.zIndex < $1.zIndex }
            
            for layer in expressionData.layers {
                let center = self.view.convert(CGPoint.init(x: layer.center.x, y: layer.center.y), to: canvasImageView)
                var centerX = CGFloat(1)
                var centerY = CGFloat(1)
                
                if (expressionData.originalFrame != nil) {
                    centerX = center.x * scaleX
                    centerY = center.y * scaleY
                } else {
                    centerX = self.canvasImageView.bounds.width / 2
                    centerY = self.canvasImageView.bounds.height / 2
                }
                
               
                if let backgroundSize = expression?.backgroundSize {
                    let aspectPoint = pointToAspectFill(for: layer.center, in: backgroundSize)
                    let centerAspect = self.view.convert(CGPoint.init(x: aspectPoint.x, y: aspectPoint.y), to: canvasImageView)
                    
                    centerX = centerAspect.x
                    centerY = centerAspect.y
                }
                
                if let text = layer.text {
                    addTextObject(text: text, font: layer.textStyle!, color: UIColor.init(hexString: layer.textColor!), textSize: layer.textSize!, textAlignment: layer.textAlign, x: centerX, y: centerY, transform: layer.transform)
                } else if let gifUrl = layer.contentUrl {
                    addGifObject(contentUrl: gifUrl, x: centerX, y: centerY, size: CGSize.init(width: layer.size!.width, height: layer.size!.height),
                                 transform: layer.transform!)
                }
            }
        }
    }
    
    func addGifObject (contentUrl: String, x: CGFloat, y: CGFloat, size: CGSize, transform: Transform) {
        let imageView: UIImageView = UIImageView()
        let loader = UIActivityIndicatorView.init(style: .gray)
        
        imageView.setGifFromURL(URL.init(string: contentUrl)!, customLoader: loader)
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size = size
        imageView.center = CGPoint.init(x: x, y: y)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        imageView.transform = CGAffineTransform.init(a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
        
        self.canvasImageView.addSubview(imageView)
        addGestures(view: imageView)
        gifsImages.append(imageView)
        gifsSources.append(GifImage(image: imageView, url: contentUrl))
    }
    
    func addTextObject (text: String, font: String, color: UIColor, textSize: CGFloat, textAlignment: String?, x: CGFloat, y: CGFloat, transform: Transform?) {
        let textView = KMPlaceholderTextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 90))
        
        textColor = color
        textView.text = text
        textView.font = UIFont(name: font, size: textSize)
        textView.alignmentFromString(alignment: textAlignment)
        textView.textColor = color
        textView.placeholder = "Start typing here or skip by tapping ‘DONE’ and browse ‘Backgrounds’ for some inspo.."
        textView.placeholderColor = UIColor.init(hexString: "#fff")
        textView.placeholderFont = UIFont(name: "Nunito-SemiBold", size: 20)
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self

        let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - 40, height:CGFloat.greatestFiniteMagnitude))
        
        textView.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: sizeToFit.height)
        textView.setNeedsDisplay()
        
        let view = UIView.init(frame: CGRect(x: 0, y :0, width: UIScreen.main.bounds.size.width - 40, height: sizeToFit.height))
        
        view.center = CGPoint.init(x: x, y: y)
        view.addSubview(textView)
        if let trans = transform  {
            view.transform = CGAffineTransform.init(a: trans.a, b: trans.b, c: trans.c, d: trans.d, tx: trans.tx, ty: trans.ty)
        }
        
        self.canvasImageView.addSubview(view)
        addGestures(view: view)
    }
}
