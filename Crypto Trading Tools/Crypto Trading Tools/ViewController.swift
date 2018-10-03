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



class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    

    @IBOutlet weak var pickerViewPopUp: UIView!
    @IBOutlet weak var coinPickerView: UIPickerView!
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var priceChart: LineChartView!
    @IBOutlet weak var symbolLabel: UILabel!
    var coin = ""
    
    var abbreviations = ["BTCUSD": "Bitcoin",
                            "LTCUSD": "Litecoin",
                            "ETHUSD": "Ethereum"]
    
    var coinList = ["BTCUSD", "LTCUSD", "ETHUSD"]

    override func viewDidLoad() {
        super.viewDidLoad()
        coin = "BTCUSD"
        httpRequest(coin: coin)
        
        view.addSubview(pickerViewPopUp)
        
        coinPickerView.isHidden = true
        
        coinPickerView.delegate = self
        coinPickerView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
        coinLabel.isUserInteractionEnabled = true
        coinLabel.addGestureRecognizer(tap)
        
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeLeft))
        recognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view .addGestureRecognizer(recognizer)
        

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Networking
    func httpRequest(coin : String){
        
        //Current Price Request
        var market = ""
        var currentHTTPRequest : String
        var historicalHTTPRequest : String
        if (coin == "BTCUSD" || coin == "ETHUSD" || coin == "LTCUSD" ){
            market = "global"
        }
        else{
            market = "tokens"
        }
        currentHTTPRequest = "https://apiv2.bitcoinaverage.com/indices/\(market)/ticker/\(coin)"
        historicalHTTPRequest = "https://apiv2.bitcoinaverage.com/indices/\(market)/history/\(coin)?period=alltime&format=json"
        print(historicalHTTPRequest)
        Alamofire.request(currentHTTPRequest).responseJSON { response in
            if response.result.isSuccess{
                self.symbolLabel.text = coin
                self.coinLabel.text = self.abbreviations[coin]
                self.updatePrice(data: JSON(response.data))
            }
            else{
                print("Failure")
            }
        }
        Alamofire.request(historicalHTTPRequest).responseJSON { response in
            if response.result.isSuccess{
                print(JSON(response.data))
                self.updateChart(data: JSON(response.data))
            }
            else{
                print(response.result.description)
            }
        }
    }
    
    // MARK: Update Data
    func updatePrice(data : JSON){

        let price = data["last"].doubleValue
        let percentChange = data["changes"]["percent"]["day"].doubleValue
        if (price != nil && percentChange != nil){

            
            
            priceLabel.text = String(price)
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
    func updateChart(data : JSON){
        var lineChartEntry = [ChartDataEntry]()
        var index = 60
        for i in 0..<60{
            var yVal = data[index]["open"].doubleValue
            var point = ChartDataEntry.init(x: Double(i), y: Double(yVal))
            lineChartEntry.append(point)
            index = index - 1
        }
        let line1 =  LineChartDataSet(values: lineChartEntry, label: "Price")
        line1.drawIconsEnabled = false
        line1.highlightLineDashLengths = [5, 2.5]
        line1.setColor(UIColor.orange)
        line1.setCircleColor(UIColor.orange)
        line1.lineWidth = 2
        line1.circleRadius = 3
        line1.drawCircleHoleEnabled = false
        line1.valueFont = .systemFont(ofSize: 9)
        line1.formLineDashLengths = [5, 2.5]
        line1.formLineWidth = 1
        line1.formLineWidth = 15
        line1.drawValuesEnabled = false
        line1.drawCirclesEnabled = false
        
        let gradientColors = [UIColor.orange.withAlphaComponent(0.0).cgColor, UIColor.orange.withAlphaComponent(0.3).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        line1.fillAlpha = 1
        line1.fill = Fill(linearGradient: gradient, angle: 90)
        line1.drawFilledEnabled = true
        
        line1.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        
        // Price Chart Modifications
        
        priceChart.legend.enabled = false
        priceChart.chartDescription?.text = nil
        
        priceChart.xAxis.drawLabelsEnabled = false
        priceChart.xAxis.drawGridLinesEnabled = false
        priceChart.xAxis.drawAxisLineEnabled = false
        
        priceChart.leftAxis.drawAxisLineEnabled = false
        priceChart.leftAxis.drawGridLinesEnabled = false
        priceChart.leftAxis.drawLabelsEnabled = false
        
        priceChart.rightAxis.drawAxisLineEnabled = false
        priceChart.rightAxis.drawGridLinesEnabled = false
        priceChart.rightAxis.drawLabelsEnabled = false
        
    
        
        priceChart.data = data
        
        
        

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinList.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = coinList[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        httpRequest(coin: coinList[row])
    }
    
    

    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        //INSERT SEGUE
        if(coinPickerView.isHidden == false){
            coinPickerView.isHidden = true
        }
        else{
            coinPickerView.isHidden = false

        }
        
    }
    
    @objc
    func swipeLeft(recognizer : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "ladderingSegue", sender: self)
    }


}


