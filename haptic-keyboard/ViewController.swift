//
//  ViewController.swift
//  haptic-keyboard
//
//  Created by Ryo Nakabayashi on 2019/05/02.
//  Copyright © 2019 Ryo Nakabayashi. All rights reserved.
//

/*
 メインと思しき場所
 DONE
 - forceを表示する(consoleに)
 https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/tracking_the_force_of_3d_touch_events
 
 注意点 シミュレータ上でも3dforce touchに対応した機体(例えばiphone8など)を選ばないと3d forceは使えない。
 
 TODO
 - tapticを動かす
 https://qiita.com/griffin_stewie/items/298f57ca3f1714ebe45c
 
 
 割と一般的なガイド
 https://github.com/hatena/Hatena-Textbook/blob/master/swift-development-apps.md
 
 */

import UIKit

class ViewController: UIViewController {
    
    var tapLocation: CGPoint = CGPoint()
    
    
    // virtual button state
    var pushed:Bool = false
    // taptic feedback
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // enable multi touch
        self.view.isMultipleTouchEnabled = true
        
        // forceに対応しているか？
        if traitCollection.forceTouchCapability != .available {
            Swift.print("force touch not available", traitCollection.forceTouchCapability)
        }
        
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 0, width: 2, height: 1000)
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.black
        view.addSubview(label)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        Swift.print("button pressed")
        
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
    }

    var touchStore:[CGPoint] = []
    var labelStore:[UILabel] = []
    var SIZE:CGFloat = 100
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (_, touch) in touches.enumerated() {
            let pos = touch.preciseLocation(in: self.view)
            touchStore.append(pos)
            
            let label = UILabel()
            label.text = "hoge"
            label.frame = CGRect(x: pos.x - SIZE/2, y: pos.y - SIZE/2, width: SIZE, height: SIZE)
            label.textColor = UIColor.red
            label.backgroundColor = UIColor.gray
            view.addSubview(label)
            labelStore.append(label)
        }
        //label.text = touchStore.count.description
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (_, touch) in touches.enumerated() {
            let currPos = touch.preciseLocation(in: self.view)
            let prevPos = touch.precisePreviousLocation(in: self.view)
            for (j, storedPos) in touchStore.enumerated() {
                if prevPos.equalTo(storedPos) {
                    touchStore[j] = currPos
                    labelStore[j].frame = CGRect(x: currPos.x - SIZE/2, y: currPos.y - SIZE/2, width: SIZE, height: SIZE)
                    
                    break
                }
            }
            
            if (currPos.x >= 100 && prevPos.x <= 100) || (currPos.x < 100 && prevPos.x >= 100) {
                generator.prepare()
                generator.impactOccurred()
            }
        }
        //let force = (touch?.force)!/(touch?.maximumPossibleForce)!
        //Swift.print("moved", pos, prevPos)
        /*
        if force >= 0.3 && pushed == false {
            Swift.print("push")
            pushed = true
            // inpact
            generator.prepare()
            generator.impactOccurred()
        }
        if force < 0.3 && pushed == true {
            Swift.print("released")
            pushed = false
        }
        */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (_, touch) in touches.enumerated() {
            let prevPos = touch.precisePreviousLocation(in: self.view)
            for (j, storedPos) in touchStore.enumerated() {
                if prevPos.equalTo(storedPos) {
                    touchStore.remove(at: j)
                    labelStore[j].removeFromSuperview()
                    labelStore.remove(at: j)
                    break
                }
            }
            //label.text = touchStore.count.description
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for (_, touch) in touches.enumerated() {
            let prevPos = touch.preciseLocation(in: self.view)
            for (j, storedPos) in touchStore.enumerated() {
                if prevPos.equalTo(storedPos) {
                    touchStore.remove(at: j)
                    labelStore[j].removeFromSuperview()
                    labelStore.remove(at: j)
                    break
                }
            }
        }
    }
}

