//
//  TitleScene.swift
//  Push&Pull
//
//  Created by 結城 竜矢 on 2017/07/17.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene : SKScene {

    var myWindow: UIWindow!;
    var myWindowButtonOk: UIButton!;
    var myWindowButtonCancel: UIButton!;
    
    var myLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:25))
    var button1 = UIButton.init(type: UIButtonType.custom);
    var button2 = UIButton.init(type: UIButtonType.custom);
    var button3 = UIButton.init(type: UIButtonType.custom);
    var button4 = UIButton.init(type: UIButtonType.custom);
    var stageLabel = UILabel.init();
    var stageText = UITextField.init();
    var stepper = UIStepper.init();
    
    func setup() {
        myWindow = UIWindow();
        myWindowButtonOk = UIButton();
        myWindowButtonCancel = UIButton();
        
        self.backgroundColor = UIColor.white;
        let centerX = UIScreen.main.bounds.size.width;
        
        myLabel.text = "=== PUSH & PULL ===";
        myLabel.backgroundColor = UIColor.white;
        myLabel.textColor = UIColor.blue;
        myLabel.shadowColor = UIColor.gray;
        myLabel.textAlignment = NSTextAlignment.center;
        myLabel.layer.position = CGPoint(x: centerX/2,y: 80);
        self.view?.addSubview(myLabel);

        button1.frame = CGRect(x:centerX/2-75, y:100, width:150, height:45);
        button1.setTitleColor(UIColor.black, for: UIControlState.normal);
        button1.setTitle("Game Start", for: UIControlState.normal);
        button1.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button1.setTitle("Game Start", for: UIControlState.highlighted);
        button1.backgroundColor = UIColor.green;
        button1.layer.cornerRadius = 10.0;
        button1.addTarget(self, action: #selector(gameStart), for: UIControlEvents.touchUpInside);
        self.view?.addSubview(button1);
        
        stageLabel.frame = CGRect(x:centerX/2-60, y:150, width:200, height:45);
        stageLabel.textColor = UIColor.black;
        stageLabel.text = "Start from the Stage ";
        self.view?.addSubview(stageLabel);
        
        stageText.frame = CGRect(x:centerX/2+140, y:150, width:30, height:45);
        stageText.allowsEditingTextAttributes = false;
        stageText.text = "1";
        self.view?.addSubview(stageText);
        
        stepper.frame = CGRect(x:centerX/2+170, y:150, width:150, height:50)
        self.view?.addSubview(stepper);
        stepper.minimumValue = 1;
        stepper.maximumValue = 1;
        stepper.value = 1;
        stepper.stepValue = 1;
        stepper.addTarget(self, action: #selector(TitleScene.stepperChanged), for: UIControlEvents.valueChanged);
        if (UserDefaults.standard.object(forKey: "Stage") != nil) {
            stepper.maximumValue = Double(UserDefaults.standard.integer(forKey: "Stage"));
        }
        
        button2.frame = CGRect(x:centerX/2-75, y:200, width:150, height:45);
        button2.setTitleColor(UIColor.black, for: UIControlState.normal);
        button2.setTitle("Tutorial", for: UIControlState.normal);
        button2.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button2.setTitle("Tutorial", for: UIControlState.highlighted);
        button2.backgroundColor = UIColor.green;
        button2.layer.cornerRadius = 10.0;
        button2.addTarget(self, action: #selector(tutorial), for: UIControlEvents.touchUpInside);
        self.view?.addSubview(button2);

        /*
        button3.frame = CGRect(x:centerX/2-75, y:250, width:150, height:45);
        button3.setTitleColor(UIColor.black, for: UIControlState.normal);
        button3.setTitle("Setting", for: UIControlState.normal);
        button3.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button3.setTitle("Setting", for: UIControlState.highlighted);
        button3.backgroundColor = UIColor.green;
        button3.layer.cornerRadius = 10.0
        button3.addTarget(self, action: #selector(setting), for: UIControlEvents.touchUpInside);
        self.view?.addSubview(button3);
 */
/*
        button4.frame = CGRect(x:centerX/2-75, y:250, width:150, height:45);
        button4.setTitleColor(UIColor.black, for: UIControlState.normal);
        button4.setTitle("Edit", for: UIControlState.normal);
        button4.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button4.setTitle("Edit", for: UIControlState.highlighted);
        button4.backgroundColor = UIColor.green;
        button4.layer.cornerRadius = 10.0
        button4.addTarget(self, action: #selector(edit), for: UIControlEvents.touchUpInside);
        self.view?.addSubview(button4);
 */
    }
    
    @objc func stepperChanged() {
        stageText.text = String(Int(stepper.value));
    }
    
    func onClickCancel() {
        self.myWindow.isHidden = true;
    }
    
    @objc func gameStart() {
        clearScreen()
        let scene = GameScene(size: self.size)
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0);
        scene.size = self.frame.size
        scene.scaleMode = SKSceneScaleMode.aspectFill
        scene.setStage(stage: Int(stepper.value));
        self.view?.presentScene(scene, transition: transition);
    }
    
    @objc func tutorial() {
        clearScreen()
        let scene = TutorialScene(size: self.size)
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0);
        scene.size = self.frame.size
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(scene, transition: transition)
    }
    
    func edit() {
        clearScreen()
        let scene = EditScene(size: self.size)
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0);
        scene.size = self.frame.size
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(scene, transition: transition)
    }
    
    func setting() {
        clearScreen()
    }

    func clearScreen() {
        self.myLabel.removeFromSuperview();
        self.button1.removeFromSuperview();
        self.button2.removeFromSuperview();
        self.button3.removeFromSuperview();
        self.button4.removeFromSuperview();
        self.stageLabel.removeFromSuperview();
        self.stageText.removeFromSuperview();
        self.stepper.removeFromSuperview();
    }
    
    override func didMove(to view: SKView) {
        self.setup()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began");
    }
    
    func touchPoint(toX: Int, toY:Int) {
        
    }
    
    //　ドラッグ時に呼ばれる
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチイベントを取得
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("End")
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
