//
//  PhotoEditor+Font.swift
//
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    static var fonts = ["Nunito-ExtraBold", "Nunito-SemiBold", "Nunito-Black",
                        "ShadowsIntoLight", "ZillaSlabHighlight-Bold",
                        "BowlbyOneSC-Regular"]
    
    //Resources don't load in main bundle we have to register the font
    func registerFont() {
        for font in PhotoEditorViewController.fonts {
            let bundle = Bundle(for: PhotoEditorViewController.self)
            let url =  bundle.url(forResource: font, withExtension: "ttf")
            
            guard let fontDataProvider = CGDataProvider(url: url! as CFURL) else {
                return
            }
            let font = CGFont(fontDataProvider)
            
            var error: Unmanaged<CFError>?
            guard CTFontManagerRegisterGraphicsFont(font!, &error) else {
                return
            }
        }
    }
    
    func fontIndex (fontName: String) -> Int {
        switch fontName {
        case "BowlbyOneSC-Regular":
            return 1
        case "ShadowsIntoLight":
            return 2
        case "ZillaSlabHighlight-Bold":
            return 3
        default:
            return 0
        }
    }
}
