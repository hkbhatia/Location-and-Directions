//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Hitesh Bhatia on 10/12/17.
//  Copyright © 2017 Hitesh Bhatia. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var countryAndSports : Dictionary<String,Array<String>>?
    var sportsCountry : Array<String>?
    var selectedSport : String?
    var country : Array<String>?
    var sliderVal : Int = 0
    
    @IBOutlet weak var countryUIPicker: UIPickerView!
    @IBOutlet weak var countryLable: UILabel!
    @IBOutlet weak var sportsLabel: UILabel!
    @IBOutlet weak var sportsSlider: UISlider!
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        countryUIPicker.delegate = self
        countryUIPicker.dataSource = self
        
        let data : Bundle = Bundle.main
        let dataPlist : String? = data.path(forResource: "data", ofType: "plist")
        if dataPlist != nil{
            countryAndSports = (NSDictionary.init(contentsOfFile: dataPlist!) as! Dictionary)
            sportsCountry = countryAndSports?.keys.sorted()
            selectedSport = sportsCountry![0]
            country = countryAndSports![selectedSport!]!.sorted()
        }
    }
    
    @IBAction func sportsSlider(_ sender: UISlider) {
        sliderVal = Int(sportsSlider.value)
        countryUIPicker.selectRow(sliderVal, inComponent: 1, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            guard(sportsCountry != nil) && country != nil else {return 0}
            switch component{
                case 0 : return sportsCountry!.count
                case 1 :
                    sportsSlider.maximumValue = Float(country!.count) - 1.0
                    return country!.count
                default : return 0
            }
        }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard (sportsCountry != nil) && country != nil else{return "None"}
        
        switch component{
            case 0 : return sportsCountry![row]
            case 1 : return country![row]
            default : return "None"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard (sportsCountry != nil) && country != nil else {return}
        
        if component == 0{
            selectedSport = sportsCountry![row]
            country = countryAndSports![selectedSport!]!.sorted()
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            sportsSlider.value = 0
        }
        
        if component == 1{
            sportsSlider.value = Float(row)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

