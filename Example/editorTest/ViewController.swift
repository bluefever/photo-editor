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
        let photoEditor = PhotoEditorViewController.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        photoEditor.photoEditorDelegate = self
        
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        let note =       "{\"backgroundSize\":{\"width\":1242,\"height\":2688},\"originalFrame\":{\"width\":414,\"height\":896},\"backgroundImage\":\"bg_98\",\"layers\":[{\"zIndex\":1,\"textStyle\":\"HelveticaNeue-Medium\",\"center\":{\"x\":799.5,\"y\":1384.5},\"textAlign\":\"left\",\"textSize\":20,\"text\":\"Asdasdasdasda\",\"textColor\":\"#000000\",\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0}},{\"size\":{\"width\":170,\"height\":221},\"zIndex\":0,\"transform\":{\"d\":1.8462539438695713,\"b\":0,\"ty\":0,\"c\":0,\"a\":1.8462539438695713,\"tx\":0},\"contentUrl\":\"https:\\/\\/media3.giphy.com\\/media\\/9bc43u6nFOxgpfoPyF\\/giphy.gif?cid=cac7b245wett1h8dwqzgrpw01948k376wmihm65a6wcgvhu9&rid=giphy.gif\",\"center\":{\"x\":621,\"y\":1890}}]}"
        
        photoEditor.bgColors = bgColors
        photoEditor.initialData = note
        photoEditor.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_98.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
//        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
//        photoEditor.initialBgUrl = "https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_98.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"
//        present(photoEditor, animated: true, completion: nil)
        self.view.addSubview(photoEditor)
        // Expression preview view
        let preview = ExpressionPreview.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        preview.data = note
//
        preview.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_98.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
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
