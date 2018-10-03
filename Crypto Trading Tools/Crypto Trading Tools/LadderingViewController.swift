//
//  LadderingViewController.swift
//  Crypto Trading Tools
//
//  Created by Dennis Li on 10/3/18.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

class LadderingViewController : UIViewController{
    
    
    @IBOutlet weak var riskRatio: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!
    
    let numberFormatter = NumberFormatter()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(LadderingViewController.swipeRight))
        recognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view .addGestureRecognizer(recognizer)
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
    }

    @IBAction func percentSlider(_ sender: UISlider) {
        riskRatio.text = numberFormatter.string(for: sender.value)
        var percent = Double(sender.value)
        
        if let price = Double(priceTextField.text!){
            if let min = Double(minTextField.text!){
                var loss = price - min
                lossLabel.text = numberFormatter.string(for: loss)
                lossLabel.textColor = UIColor.red
                
                var profit = min*percent
                profitLabel.text = numberFormatter.string(for: price + profit)
                profitLabel.textColor = UIColor.green
                
                
                
            }
            
            
            
        }
    }
    
    @objc
    func swipeRight(recognizer : UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
