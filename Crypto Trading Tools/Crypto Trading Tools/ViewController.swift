//
//  ViewController.swift
//  Crypto Trading Tools
//
//  Created by Dennis Li on 8/10/18.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tradeAmount : [Double] = [0,0,0,0,0]
    var tradePrice : [Double] = [0,0,0,0,0]
    var tradeTotals : [Double] = [0,0,0,0,0]
    
    
    @IBOutlet weak var breakEvenPoint: UILabel!
    
    @IBOutlet weak var tradeTotal1: UILabel!
    @IBOutlet weak var tradeTotal2: UILabel!
    @IBOutlet weak var tradeTotal3: UILabel!
    @IBOutlet weak var tradeTotal4: UILabel!
    @IBOutlet weak var tradeTotal5: UILabel!
    var tradeTotalArray = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Inefficient, possible to use UICollection to store these as array
        tradeTotalArray.append(tradeTotal1)
        tradeTotalArray.append(tradeTotal2)
        tradeTotalArray.append(tradeTotal3)
        tradeTotalArray.append(tradeTotal4)
        tradeTotalArray.append(tradeTotal5)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func amountChanged(_ sender: UITextField) {
        if(Double(sender.text!) != nil){
            tradeAmount[sender.tag-1] = Double(sender.text!)!
        }
        
    }
    
    @IBAction func priceChanged(_ sender: UITextField){
        if(Double(sender.text!) != nil){
            tradePrice[sender.tag-1] = Double(sender.text!)!
        }
    }
    
    


    
    @IBAction func calculateBreakEven(_ sender: Any) {
        var totalBTC : Double = 0.0;
        var totalAmount : Double = 0.0;
        var BEPoint : Double = 0.0;
        for i in 0..<5{
            if(tradeAmount[i] != nil && tradePrice[i] != nil){
               
                //Find Total BTC and Trade Totals
                tradeTotals[i] = tradeAmount[i] * tradePrice[i]
                tradeTotalArray[i].text = String(tradeTotals[i])
                totalBTC = totalBTC + tradeTotals[i]
                
                
                //Find Total Amount
                totalAmount = totalAmount + tradeAmount[i]
                BEPoint = totalBTC/totalAmount
                breakEvenPoint.text = String(BEPoint)
                
                print("Total Amount" + String(totalAmount))
                print("Total BTC" + String(totalBTC))
                
            }
        }
    

        
    }
    
    func showError(){
        var inputError = UIAlertController.init(title: "ERROR", message: "Please Only Input Numbers", preferredStyle: UIAlertControllerStyle.alert);
        var resolveAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        inputError.addAction(resolveAction)
        show(inputError, sender: nil)
        
    }
    
}

