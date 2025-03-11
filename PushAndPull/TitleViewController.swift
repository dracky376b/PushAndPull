//
//  TitleViewController.swift
//  VsBingo
//
//  Created by 結城 竜矢 on 2017/05/25.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit

class TitleViewController: UIViewController {

    override func loadView() {
        self.view = SKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if var scene: TitleScene = Optional.some(TitleScene()) {
            if let skView: SKView = self.view as? SKView {
                // Configure the view.
                let screensize = UIScreen.main.bounds.size
                skView.frame = CGRect(x: 0, y: 0, width: screensize.width, height: screensize.height)
                print("screensize w=\(screensize.width), h=\(screensize.height)")
                skView.showsFPS = false
                skView.showsNodeCount = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .aspectFill
                
                skView.allowsTransparency = true
                skView.presentScene(scene)  //sceneをskviewに重ねます
                
//                self.view.addSubview(skView) //skviewをuiviewに重ねます
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    /*
     UITextFieldが編集開始された直後に呼ばれる.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    /*
     テキストが編集された際に呼ばれる.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 文字数最大を決める.
        let maxLength: Int = 3
        
        // 入力済みの文字と入力された文字を合わせて取得.
        let str = textField.text! + string
        
        // 文字数がmaxLength以下ならtrueを返す.
        if (str.utf8.count <= maxLength) {
            return true
        }
        return false
    }
    
    /*
     UITextFieldが編集終了する直前に呼ばれる.
     */
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    /*
     改行ボタンが押された際に呼ばれる.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

}
