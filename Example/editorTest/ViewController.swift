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
        photoEditor.templateCategories = ["test 1", "test 2", "test 3"]
        
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        let note =       "{\"backgroundSize\":{\"width\":1242,\"height\":2688},\"originalFrame\":{\"width\":414,\"height\":736},\"backgroundImage\":\"default_bg_v2\",\"layers\":[{\"zIndex\":0,\"textStyle\":\"HelveticaNeue-Medium\",\"center\":{\"x\":748.99996948242188,\"y\":1385.0000152587891},\"textAlign\":\"left\",\"textSize\":20,\"text\":\"Asdasdasdasda\",\"textColor\":\"#000000\",\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0}},{\"size\":{\"width\":170,\"height\":221},\"zIndex\":1,\"transform\":{\"d\":1.8462539438695713,\"b\":0,\"ty\":0,\"c\":0,\"a\":1.8462539438695713,\"tx\":0},\"contentUrl\":\"https:\\/\\/media3.giphy.com\\/media\\/9bc43u6nFOxgpfoPyF\\/giphy.gif?cid=cac7b245wett1h8dwqzgrpw01948k376wmihm65a6wcgvhu9&rid=giphy.gif\",\"center\":{\"x\":621,\"y\":1344}}]}"
        
        let note2 =       "{\"backgroundSize\":{\"width\":1242,\"height\":2688},\"originalFrame\":{\"width\":414,\"height\":736},\"backgroundImage\":\"bg_98\",\"layers\":[{\"zIndex\":0,\"textStyle\":\"HelveticaNeue-Medium\",\"center\":{\"x\":748.99996948242188,\"y\":1385.0000152587891},\"textAlign\":\"left\",\"textSize\":20,\"text\":\"Asdasdasdasda\",\"textColor\":\"#000000\",\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0}},{\"size\":{\"width\":190,\"height\":106},\"zIndex\":1,\"transform\":{\"d\":1.8462539438695713,\"b\":0,\"ty\":0,\"c\":0,\"a\":1.8462539438695713,\"tx\":0},\"contentUrl\":\"https:\\/\\/media2.giphy.com\\/media\\/cySZBmM8EFurhcGtEy\\/giphy-downsized.gif?cid=cac7b245mvxa2xo4qph09ku6zopnbhwiwy37ugeiuf6urgvb&rid=giphy-downsized.gif\",\"center\":{\"x\":621,\"y\":1344}}]}"
        
        photoEditor.bgColors = bgColors
//        photoEditor.initialData = note
        photoEditor.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2F303.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
//        photoEditor.initialBgUrl = "https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_98.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"
        present(photoEditor, animated: true, completion: nil)
        
        // Expression preview view
        let preview = ExpressionScalablePreview.init(frame: CGRect.init(x: 0, y: 0, width: 168, height: 241))
        preview.data = note
//
        preview.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2F303.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
        
        let preview2 = ExpressionScalablePreview.init(frame: CGRect.init(x: 170, y: 0, width: 168, height: 241))
        preview2.data = note2
//
        preview2.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_98.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
        self.view.addSubview(preview)
        self.view.addSubview(preview2)
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
    
    func canceledEditing(edited: Bool) {
        print("Canceled", edited)
    }
}
