//
//  ViewController.swift
//  editorTest
//
//  Created by Mohamed Hamed on 5/4/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit
import iOSPhotoEditor

class ViewController: UIViewController {
    let bgColors: [String] = ["#4282F7","#538EF7","#669AF8","#739FEE","#8CB3F9","#9EC0FA","#B2CDFB","#C4D8FB","#D9E6FD","#ECF2FE","#DCC7C6","#DFCCCB","#E3D2D1","#E6D8D6","#EADEDC","#EDE2E2","#F1E8E8","#F4EDED","#FBF9F9","#EED5BB","#EFD9C2","#F2DEC9","#F2E0CF","#F4E5D6","#4282F7","#538EF7","#669AF8","#739FEE","#8CB3F9","#9EC0FA","#B2CDFB","#C4D8FB","#D9E6FD","#ECF2FE","#DCC7C6"]
    
  
    
    func showPhotoEditor () {
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        let dataXSMAX =       "{\"layers\":[{\"zIndex\":0,\"textStyle\":\"HelveticaNeue-Medium\",\"center\":{\"x\":157,\"y\":214},\"textSize\":20,\"text\":\"ABCD\",\"textColor\":\"#000000\",\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0}},{\"zIndex\":3,\"textStyle\":\"HelveticaNeue-Medium\",\"center\":{\"x\":138.50000000000003,\"y\":436},\"textSize\":48.645255435653823,\"text\":\"ROTATE\",\"textColor\":\"#000000\",\"transform\":{\"d\":0.65870712317434199,\"b\":-0.75239944569316597,\"ty\":0,\"c\":0.75239944569316597,\"a\":0.65870712317434199,\"tx\":0}}],\"originalFrame\":{\"width\":414,\"height\":896}, \"backgroundImage\": \"bg_2\"}"
    
        
        let dataIphone8 = "{\"layers\":[{\"zIndex\":0,\"text\":\"Testing xs max\",\"textColor\":\"#000000\",\"textStyle\":\"HelveticaNeue-Medium\",\"textSize\":30,\"center\":{\"x\":109.5,\"y\":102.33333333333331}},{\"size\":{\"width\":172.10144927536231,\"height\":92.308035714285722},\"zIndex\":1,\"transform\":{\"d\":-0.038622025806129258,\"b\":2.01691546498978,\"ty\":0,\"c\":-2.01691546498978,\"a\":-0.038622025806129258,\"tx\":0},\"contentUrl\":\"https:\\/\\/media0.giphy.com\\/media\\/NI4FNMb4tJEYM\\/giphy.gif?cid=cac7b245d36426c41415695caa971f445f2efa7832a95a87&rid=giphy.gif\",\"center\":{\"x\":89.830913267273615,\"y\":527.37257048629579}}],\"originalFrame\":{\"width\":375,\"height\":667}, \"backgroundImage\": \"bg_21\"}"
        
        photoEditor.bgColors = bgColors
//        photoEditor.initialData = dataXSMAX
        photoEditor.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_2.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        photoEditor.initialBgUrl = "https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_2.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"
        present(photoEditor, animated: true, completion: nil)
        
        // Expression preview view
//        let preview = ExpressionPreview.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        preview.data = dataXSMAX
//
//        preview.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_2.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
//        self.view.addSubview(preview)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        showPhotoEditor()
    }
}

extension ViewController: PhotoEditorDelegate {
    
    func doneEditing(expression: String, image: UIImage) {
        print(expression)
    }
    
    func canceledEditing() {
        print("Canceled")
    }
}
