//
//  TutorialViewController.swift
//  Push&Pull
//
//  Created by 結城 竜矢 on 2017/07/07.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TutorialViewController: UIViewController {
    
    let skView = SKView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = TutorialScene(fileNamed:"TutorialScene") {
            // Configure the view.
            let screensize = UIScreen.main.bounds.size
            skView.frame = CGRect(x: 0, y: 0, width: screensize.width, height: screensize.height)
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.allowsTransparency = true
            skView.presentScene(scene)  //sceneをskviewに重ねます
            
            self.view.addSubview(skView) //skviewをuiviewに重ねます
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
