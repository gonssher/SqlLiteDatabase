//
//  ViewController.swift
//  MySqlLiteDatabaseApp
//
//  Created by Sherwin on 2020-03-22.
//  Copyright © 2020 Sherwin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var lblTable : UILabel!
    @IBOutlet var lblPicker : UILabel!
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfFood : UITextField!
    
    
    @IBAction func addPerson (sender : Any)
    {
        let person : Data = Data.init()
        person.initWithData(theRow: 0, theName: tfName.text!, theEmail: tfEmail.text!, theFood: tfFood.text!)
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let returnCode = mainDelegate.insertIntDatabase(person: person)
        
        var returnMsg : String = "Person Added"
        
        if returnCode == false
        {
           returnMsg = "P3erson Add Failed"
            
        }
        let alertController = UIAlertController(title: "SQl Lite Add", message: returnMsg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first!
        let touchPoint : CGPoint = touch.location(in: self.view!)
        
        let tableFrame : CGRect = lblTable.frame
        let pickerFrame : CGRect = lblPicker.frame
        
        if tableFrame.contains(touchPoint)
        {
            rememberEnterData()
            performSegue(withIdentifier: "HomeSegueToTable", sender: self)
            
        }
        if pickerFrame.contains(touchPoint)
        {
            rememberEnterData()
            performSegue(withIdentifier: "HomeSegueToPicker", sender: self)
            
        }
    }
    
    func rememberEnterData(){
        let defaults = UserDefaults.standard
        defaults.set(tfName.text, forKey: "lastname")
        
        defaults.set(tfEmail.text, forKey: "lastEmail")
        defaults.set(tfFood.text, forKey: "lastfood")
        defaults.synchronize()
        
    }
    
    @IBAction func unwindToHomeViewController(segue:UIStoryboardSegue)
    {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    let defaults = UserDefaults.standard
        
        if let name = defaults.object(forKey: "lastname") as? String {
            tfName.text = name
            
        }
        if let email = defaults.object(forKey: "lastEmail") as? String {
            tfEmail.text = email
            
        }
        if let food = defaults.object(forKey: "lastfood") as? String {
            tfFood.text = food
            
        }
        
        
    }


}

