//
//  ViewController.swift
//  Task_Project
//
//  Created on 01/09/20.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var btnView: UIView!

    let userDefults = UserDefaults.standard

    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.center = self.btnView.center
        activityIndicator = UIActivityIndicatorView(style: .medium)
        self.viewPageSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    self.loginBtn.setTitle("Login", for: .normal)

    }
    func viewPageSetup() {
        self.userNameView.layer.cornerRadius = 10
              self.userNameView.backgroundColor =  UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
              self.userNameView.layer.borderWidth = 0.2
              
              self.passwordView.layer.cornerRadius = 10
              self.passwordView.backgroundColor =  UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1)
              self.passwordView.layer.borderWidth = 0.2
        
        let sampleWidth: CGFloat = (self.view.frame.size.width/2)-40
        activityIndicator.frame = CGRect(x: sampleWidth-50, y: 2, width: 46, height: 46)

    }
   @objc func login() {
        
    self.loginBtn.setTitle("Loading", for: .normal)

        var dic:Dictionary<String, Any> = [
        "username":"patient" as AnyObject,
        "password":"Test@123" as AnyObject,
        "device_id":"55c3389cb5ddd720dc0297617f3561c43a36218a277c974c8d43d545a643f45c" as AnyObject,
        "os_id":"b93a9204-ee21-4cf9-8a94-cf5eeabf7301" as AnyObject,
        "role_id":"143f37f2-ca38-0ab1-2489-1e47113655fc" as AnyObject,
        "time_zone":"Asia/Calcutta" as AnyObject]
                
                NetworkManager.sharedInstance.requestPOSTData(urlString: kUrlLogin, str: "", parameterToBePassed: &dic , completion:
                    { (resultDictionary, error) -> () in
                        if resultDictionary != nil
                        {
                            self.loginBtn.setTitle("Login Success", for: .normal)
                            self.userNameTF.text = ""
                            self.passwordTF.text = ""
                            self.activityIndicator.stopAnimating()
                         let dicarray = resultDictionary?["data"] as! Dictionary<String,AnyObject>
                            self.userDefults.set(dicarray.stringValueForKey("access_token"), forKey: kAccessToken)
                            let view: HomePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
                            self.navigationController?.pushViewController(view, animated: true)

                        }
                        else
                        {
                            print(error!)
                        }
                })
            
    }
   
    @IBAction func loginBtn(_ sender: Any) {
        activityIndicator.startAnimating()
        loginBtn.addSubview(activityIndicator)
        self.perform(#selector(login), with: nil, afterDelay: 0.5)
    }
}

extension Dictionary {
        func hasValueForKey(_ key:Key) -> Bool{
        
        if let value = self[key] {
            if value is NSNull {
                return false
            }
            else {
                return true
            }
            
        }
        else {
            return false
        }
    }
    func hasStringForKey(_ key:Key) -> Bool{
        
        if let value = self[key] {
            if value is NSNull {
                return false
            }
            else {
                var strValue = ""
                if let object = self[key] {
                    if object is String {
                        strValue = object as! String
                    }
                    else if object is NSNumber || object is Float || object is Int || object is Double {
                        strValue = String(describing: object)
                    }
                }
                strValue = strValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                if strValue.count > 0 {
                    return true
                }
                else {
                    return false
                }
                
            }
            
        }
        else {
            return false
        }
    }
    
    func stringValueForKey(_ key:Key) -> String {
        var strValue = ""
        
        if let object = self[key] {
            if object is String {
                strValue = object as! String
            }
            else if object is NSNumber || object is Float || object is Int || object is Double {
                strValue = String(describing: object)
            }
        }
        strValue = strValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return strValue
    }
    
    
    var jsonString: String {
        if let dict = (self as? AnyObject) as? Dictionary<String, AnyObject> {
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
                if let string = String(data: data, encoding: String.Encoding.utf8) {
                    return string
                }
            } catch {
                
            }
        }
        return ""
    }

}
extension ViewController {
    //MARK:- textfield delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField ==  userNameTF {
            
        }else if textField == passwordTF {
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == userNameTF
        {
            let _ = passwordTF.becomeFirstResponder()
        }
        else if textField == passwordTF
        {
            textField.resignFirstResponder()
        }
                return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (string == " ") {
            return false
        }
        return true
    }
}
