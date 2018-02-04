//
//  ThirdScreenViewController.swift
//  Assignment4
//
//  Created by Hitesh Bhatia on 10/19/17.
//  Copyright © 2017 Hitesh Bhatia. All rights reserved.
//

import UIKit

class ThirdScreenViewController: UIViewController {
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var progressSwitch: UISwitch! 
    
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var userTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.activity.transform = CGAffineTransform(scaleX: 3, y: 3)
        self.userTextView.layer.borderColor = UIColor.gray.cgColor
        self.userTextView.layer.borderWidth = 1.0
        self.userTextView.layer.cornerRadius = 8
        userTextView.isHidden = true
        
        self.alertButton.layer.cornerRadius = 10;
        self.alertButton.layer.borderColor = UIColor.gray.cgColor
        self.alertButton.layer.borderWidth = 1.0
        alertButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentSwitch(_ sender: Any) {
        switch segment.selectedSegmentIndex{
        case 0:
            activity.isHidden = false
            progressSwitch.isHidden = false
            userTextView.isHidden = true
            alertButton.isHidden = true
            userTextView.endEditing(true)
        case 1:
            activity.isHidden = true
            progressSwitch.isHidden = true
            userTextView.isHidden = false
            alertButton.isHidden = true
            userTextView.endEditing(false)
        case 2:
            activity.isHidden = true
            progressSwitch.isHidden = true
            userTextView.isHidden = true
            alertButton.isHidden = false
            userTextView.endEditing(true)
        default:
            break
        }
    }
    
    @IBAction func progressSwitchFunc(_ sender: UISwitch) {
        if progressSwitch.isOn{
            activity.startAnimating()
        }else{
            activity.stopAnimating()
        }
    }
    
    
    @IBAction func alertButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert Message", message: "Do you Like the iPhone", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
