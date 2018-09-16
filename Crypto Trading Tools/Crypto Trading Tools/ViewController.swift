//
//  ViewController.swift
//  Crypto Trading Tools
//
//  Created by Dennis Li on 8/10/18.
//  Copyright © 2018 Dennis Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts



class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var globalHTTPRequest = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    var tokenHTTPRequest = "https://apiv2.bitcoinaverage.com/indices/tokens/ticker/"
    

    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var coinPickerView: UIPickerView!
    @IBOutlet weak var priceChart: LineChartView!
    
    
    var coinList = ["BTCUSD", "ETHUSD","OMGUSD"]
    override func viewDidLoad() {
        super.viewDidLoad()
        httpRequest(coin: "ICXBTC")
        coinPickerView.delegate = self
        coinPickerView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
        coinLabel.isUserInteractionEnabled = true
        coinLabel.addGestureRecognizer(tap)
        coinLabel.textColor = UIColor.green
        
        coinPickerView.isHidden = true
        setChart()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Networking
    func httpRequest(coin : String){
        var finalHTTPRequest : String
        if (coin == "BTCUSD" || coin == "ETHUSD" || coin == "LTCUSD" ){
            finalHTTPRequest = globalHTTPRequest + coin
        }
        else{
            finalHTTPRequest = tokenHTTPRequest + coin
        }
        Alamofire.request(finalHTTPRequest).responseJSON { response in
            if response.result.isSuccess{
                self.coinLabel.text = coin
                self.updatePrice(data: JSON(response.data))
            }
            else{
                print("Failure")
            }
        }
    }
    // MARK: Update Data
    func updatePrice(data : JSON){

        let price = data["last"].doubleValue
        let percentChange = data["changes"]["percent"]["day"].doubleValue
        if (price != nil && percentChange != nil){
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 8
            
            
            priceLabel.text = numberFormatter.string(for: price)
            percentLabel.text = String(percentChange) + "%"
            if (percentChange>0){
                percentLabel.textColor = UIColor.green
            }
            else{
                percentLabel.textColor = UIColor.red
            }
        }
    }
    
    // MARK: Set Chart
    func setChart(){
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<5{
            var point = ChartDataEntry.init(x: Double(i), y: Double(i^2))
            lineChartEntry.append(point)
        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Price")
        line1.drawIconsEnabled = false
        line1.highlightLineDashLengths = [5, 2.5]
        line1.setColor(UIColor.green)
        line1.setCircleColor(UIColor.green)
        line1.lineWidth = 2
        line1.circleRadius = 3
        line1.drawCircleHoleEnabled = false
        line1.valueFont = .systemFont(ofSize: 9)
        line1.formLineDashLengths = [5, 2.5]
        line1.formLineWidth = 1
        line1.formLineWidth = 15
        line1.drawValuesEnabled = false
        line1.drawCirclesEnabled = false
        
        let gradientColors = [UIColor.green.withAlphaComponent(0.0).cgColor, UIColor.green.withAlphaComponent(0.3).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        line1.fillAlpha = 1
        line1.fill = Fill(linearGradient: gradient, angle: 90)
        line1.drawFilledEnabled = true
        
        line1.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        priceChart.xAxis.drawLabelsEnabled = false
        priceChart.xAxis.drawGridLinesEnabled = false
        priceChart.xAxis.drawAxisLineEnabled = false
        
        priceChart.rightAxis.drawAxisLineEnabled = false
        priceChart.leftAxis.drawGridLinesEnabled = false
        priceChart.rightAxis.drawGridLinesEnabled = false
        priceChart.rightAxis.drawLabelsEnabled = false
        
    
        
        priceChart.data = data
        
        priceChart.chartDescription?.text = "My awesome chart"
        
    

        
        
        

    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        if (coinPickerView.isHidden == false){
            coinPickerView.isHidden = true
            priceChart.isHidden = false
            coinLabel.backgroundColor = UIColor.white
            
        }
        else{
            coinPickerView.isHidden = false
            priceChart.isHidden = true
            coinLabel.backgroundColor = UIColor.black
            coinPickerView.backgroundColor = UIColor.black
        }
    }
    
    
    // MARK : PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = coinList[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: UIColor.green])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        httpRequest(coin: coinList[row])
    }
    
    
    
    
    
    
    // MARK: Crypto Trading Tools
}
//
//    var tradeAmount : [Double] = [0,0,0,0,0]
//    var tradePrice : [Double] = [0,0,0,0,0]
//    var tradeTotals : [Double] = [0,0,0,0,0]
//
//
//    @IBOutlet weak var breakEvenPoint: UILabel!
//
//    @IBOutlet weak var tradeTotal1: UILabel!
//    @IBOutlet weak var tradeTotal2: UILabel!
//    @IBOutlet weak var tradeTotal3: UILabel!
//    @IBOutlet weak var tradeTotal4: UILabel!
//    @IBOutlet weak var tradeTotal5: UILabel!
//    var tradeTotalArray = [UILabel]()
//
//    @IBAction func amountChanged(_ sender: UITextField) {
//        if(Double(sender.text!) != nil){
//            tradeAmount[sender.tag-1] = Double(sender.text!)!
//        }
//
//    }
//
//    @IBAction func priceChanged(_ sender: UITextField){
//        if(Double(sender.text!) != nil){
//            tradePrice[sender.tag-1] = Double(sender.text!)!
//        }
//    }
//
//
//
//
//
//    @IBAction func calculateBreakEven(_ sender: Any) {
//        var totalBTC : Double = 0.0;
//        var totalAmount : Double = 0.0;
//        var BEPoint : Double = 0.0;
//        for i in 0..<5{
//            if(tradeAmount[i] != nil && tradePrice[i] != nil){
//
//                //Find Total BTC and Trade Totals
//                tradeTotals[i] = tradeAmount[i] * tradePrice[i]
//                tradeTotalArray[i].text = String(tradeTotals[i])
//                totalBTC = totalBTC + tradeTotals[i]
//
//
//                //Find Total Amount
//                totalAmount = totalAmount + tradeAmount[i]
//                BEPoint = totalBTC/totalAmount
//                breakEvenPoint.text = String(BEPoint)
//
//                print("Total Amount" + String(totalAmount))
//                print("Total BTC" + String(totalBTC))
//
//            }
//        }
//
//
//
//    }
//
//    func showError(){
//        var inputError = UIAlertController.init(title: "ERROR", message: "Please Only Input Numbers", preferredStyle: UIAlertControllerStyle.alert);
//        var resolveAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
//        inputError.addAction(resolveAction)
//        show(inputError, sender: nil)
//
//    }
//


