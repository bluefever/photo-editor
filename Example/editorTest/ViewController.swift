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
        let dataXSMAX =       "{\"layers\":[{\"zIndex\":0,\"textStyle\":\"ZillaSlabHighlight-Bold\",\"center\":{\"x\":201.33332824707031,\"y\":146.66667175292969},\"textAlign\":\"left\",\"textSize\":20,\"text\":\"Asdasdasdasdasdasd\",\"textColor\":\"#000000\",\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0}},{\"size\":{\"width\":190,\"height\":190},\"zIndex\":1,\"transform\":{\"d\":1.3513035389150252,\"b\":-0.85909046914171194,\"ty\":0,\"c\":0.85909046914171194,\"a\":1.3513035389150252,\"tx\":0},\"contentUrl\":\"https:\\/\\/media0.giphy.com\\/media\\/YQG834ZaTPgMlK9qdp\\/giphy.gif?cid=cac7b245s8n93jrq9016thm3pi9pcfg6zg88poh3hk0zmfpu&rid=giphy.gif\",\"center\":{\"x\":207.66667175292974,\"y\":691}}],\"originalFrame\":{\"width\":414,\"height\":896}}"

    
        
        let dataIphone8 = "{\"backgroundSize\":{\"width\":1242,\"height\":2688},\"originalFrame\":{\"width\":375,\"height\":667},\"backgroundImage\":\"bg_66\",\"layers\":[{\"zIndex\":0,\"textStyle\":\"HelveticaNeue-Medium\",\"center\":{\"x\":1043.28,\"y\":944.904},\"textAlign\":\"left\",\"textSize\":20,\"text\":\"Jkhjkjljlj\",\"textColor\":\"#000000\",\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0}},{\"size\":{\"width\":170,\"height\":170},\"zIndex\":1,\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0},\"contentUrl\":\"https:\\/\\/media3.giphy.com\\/media\\/i340Scmnq6MZZpqsX8\\/giphy.gif?cid=cac7b245uupuvy175su915b3lada4t0pvowexn2gaygdfypy&rid=giphy.gif\",\"center\":{\"x\":882.64799999999991,\"y\":1199.9279999999999}},{\"size\":{\"width\":170,\"height\":102},\"zIndex\":2,\"transform\":{\"d\":1,\"b\":0,\"ty\":0,\"c\":0,\"a\":1,\"tx\":0},\"contentUrl\":\"https:\\/\\/media3.giphy.com\\/media\\/l0HlvtIPzPdt2usKs\\/giphy.gif?cid=cac7b245rkcd4mapvnoqeidxqduvumkkhebv0thjwy42h9f9&rid=giphy.gif\",\"center\":{\"x\":293.11199999999997,\"y\":540.84000000000003}},{\"size\":{\"width\":170,\"height\":170},\"zIndex\":3,\"transform\":{\"d\":2.0654916565646579,\"b\":0.027353271355441459,\"ty\":0,\"c\":-0.027353271355441459,\"a\":2.0654916565646579,\"tx\":0},\"contentUrl\":\"https:\\/\\/media1.giphy.com\\/media\\/3o6Ztgqvc8lPSy1jFK\\/giphy.gif?cid=cac7b245rkcd4mapvnoqeidxqduvumkkhebv0thjwy42h9f9&rid=giphy.gif\",\"center\":{\"x\":630.93599999999992,\"y\":1840.8000000000004}}]}"
        
        photoEditor.bgColors = bgColors
        photoEditor.initialData = dataXSMAX
        photoEditor.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_2.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
//        photoEditor.initialBgUrl = "http`s://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_66.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"
        present(photoEditor, animated: true, completion: nil)
        
        // Expression preview view
        let preview = ExpressionPreview.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        preview.data = dataXSMAX
//
        preview.bgImages = ["https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/backgrounds%2Fbg_66.png?alt=media&token=f067203c-3268-405e-9717-26071f94a673"]
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
