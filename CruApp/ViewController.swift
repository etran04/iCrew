//
//  ViewController.swift
//  CruApp
//
//  Created by Eric Tran on 11/3/15.
//  Copyright © 2015 iCrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextLabel.text = "Hello World!"
        print("Hello World!")
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "changeColor", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeColor() {
        let red = Float(arc4random()) / Float(UINT32_MAX)
        let green = Float(arc4random()) / Float(UINT32_MAX)
        let blue = Float(arc4random()) / Float(UINT32_MAX)
        myTextLabel.textColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }

}

