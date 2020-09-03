//
//  HomePageVC.swift
//  Task_Project
//
//  Created  on 01/09/20.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class HomePageVC: UIViewController {
    
    @IBOutlet weak var datePicke: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!

    private(set) var listCell: ListCell?
    var arrayEventList :Array<Dictionary<String,AnyObject>> = []
    
    var datePicker : UIDatePicker!
    var dates:String = ""
    var date: NSDate?
    var timePicker: UIDatePicker?
    var selectedIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getQuestions()
        self.datepick()
        datePickerView.isHidden = true
//        IQKeyboardManager.shared.enable = false

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target:
            self, action: #selector(myAction))
    }
    @objc func myAction(){
        self.alertLog(title:"Logout",message:"Do you want to logout?")
    }
    //MARK:- alert action
    func alertLog(title:String,message:String){
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler:
        { action in
            self.logoutBtnTapped()
        })
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default,
                                   handler: { action in
        })
        alert.addAction(ok)
        if title == "Logout" {
            alert.addAction(cancel)
        }
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    @objc func logoutBtnTapped() {
        var dic:Dictionary<String, AnyObject> = [:]
        NetworkManager.sharedInstance.requestPOST(urlString: kUrlLogout, str: "", parameterToBePassed: &dic, completion:
            { (resultDictionary, error) -> () in
                if resultDictionary != nil
                {
                    print(resultDictionary!)
                    self.alertLog(title: "Logout Successfully", message: "Your device is deactivated")
                    self.navigationController?.popViewController(animated: false)

                }
                else
                {
                    print(error!)
                }
        })
        
    }
    
    @objc func getQuestions() {
        var dic:Dictionary<String, AnyObject> = [
            "id":"40a7138d-b335-d799-916e-61a7f9b659ca" as AnyObject,
            "spec_type":"precall" as AnyObject
        ]
        NetworkManager.sharedInstance.requestPOST(urlString: kUrlGetQuestions, str: "", parameterToBePassed: &dic, completion:
            { (resultDictionary, error) -> () in
                if resultDictionary != nil
                {
                    let getProfileData = resultDictionary!["data"]!["questionType"] as! Array<AnyObject>
                    if getProfileData.count >= 1 {
                        for i in 0 ..< getProfileData.count {
                            let strfreq_ask = getProfileData[i]["questions"]!! as! Array<AnyObject>
                            print(strfreq_ask)
                            for i in 0 ..< strfreq_ask.count {
                                let dic1 = strfreq_ask[i] as? Dictionary<String,AnyObject>
                                self.arrayEventList.append([
                                    "inputType": dic1!.stringValueForKey("input_type") as AnyObject,
                                    "title" : dic1!.stringValueForKey("name") as AnyObject,
                                    "isRequired" : dic1!.stringValueForKey("is_required") as AnyObject,
                                    "placeholder" : dic1!.stringValueForKey("placeholder") as AnyObject])
                            }
                        }
                        self.perform(#selector(self.toCall), with: nil, afterDelay: 0.5)
                    }
                }
                else
                {
                    print(error!)
                }
        })
    }
    @objc func toCall() {
        self.listTableView.reloadData()
    }
    
}
extension HomePageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowCount = 0
        //            if (indexPath.row == 0) {
        //                rowCount = 180
        //            }
        //            else if (indexPath.row == 1) {
        rowCount = 80
        //            }
        //            else {
        //                rowCount = 50
        //            }
        return CGFloat(rowCount);
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayEventList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.listTableView.deselectRow(at: indexPath, animated: true)
        
        listCell = (self.listTableView.dequeueReusableCell(withIdentifier: "radioCell") as! ListCell)
        if indexPath.row < self.arrayEventList.count {
            let dict = self.arrayEventList[indexPath.row]
            if dict.stringValueForKey("inputType") == "radio" {
                listCell!.questionLbl.text = dict.stringValueForKey("title")
            if dict.stringValueForKey("isRequired") == "no"{
                listCell?.btnYes.setImage(#imageLiteral(resourceName: "UnCheck"), for: .normal)
                listCell?.btnNo.setImage(#imageLiteral(resourceName: "Check"), for: .normal)
            } else {
                 listCell?.btnNo.setImage(#imageLiteral(resourceName: "UnCheck"), for: .normal)
            listCell?.btnYes.setImage(#imageLiteral(resourceName: "Check"), for: .normal)

            }
                   listCell!.btnNo.tag = indexPath.row
                listCell!.btnYes.tag = indexPath.row

                              listCell!.btnNo.addTarget(self, action: #selector(likeUnlike), for: .touchUpInside)
                listCell!.btnYes.addTarget(self, action: #selector(likeUnlike), for: .touchUpInside)

            }  else if dict.stringValueForKey("inputType") == "checkbox" {
                listCell = (self.listTableView.dequeueReusableCell(withIdentifier: "checkboxCell") as! ListCell)
                
                listCell!.titleLbl.text = dict.stringValueForKey("title")
                   if dict.stringValueForKey("isRequired") == "no"{
                             
                             listCell?.btnCheckBox.setImage(#imageLiteral(resourceName: "UncheckBox"), for: .normal)
                             listCell?.btnUnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox"), for: .normal)

                             print("not selected")
                         } else {
                             
                              listCell?.btnUnCheckBox.setImage(#imageLiteral(resourceName: "UncheckBox"), for: .normal)
                         listCell?.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox"), for: .normal)

                         }
                                listCell!.btnUnCheckBox.tag = indexPath.row
                             listCell!.btnCheckBox.tag = indexPath.row

                                           listCell!.btnCheckBox.addTarget(self, action: #selector(likeUnlike1), for: .touchUpInside)
                             listCell!.btnUnCheckBox.addTarget(self, action: #selector(likeUnlike1), for: .touchUpInside)
                return listCell!
                
            }else if dict.stringValueForKey("inputType") == "textbox" || dict.stringValueForKey("inputType") == "textarea"
            
            
            {

                listCell = (self.listTableView.dequeueReusableCell(withIdentifier: "textCell") as! ListCell)
                listCell?.txtField.delegate = self

                if dict.stringValueForKey("inputType") == "textbox" {
                    listCell!.txtField.placeholder = dict.stringValueForKey("placeholder")
                    if dict.stringValueForKey("placeholder") == "" {
                        listCell!.txtField.placeholder = dict.stringValueForKey("title")
                        
                    }
                }
                if dict.stringValueForKey("inputType") == "textarea" {
                    if dict.stringValueForKey("placeholder") == "" {
                        listCell!.txtField.placeholder = dict.stringValueForKey("title")
                        
                    }
                }
                
                return listCell!
                
            }
           
            else if dict.stringValueForKey("inputType") == "file" {
                              listCell = (self.listTableView.dequeueReusableCell(withIdentifier: "radioCell") as! ListCell)
                listCell?.btnNo.isHidden = true
                listCell?.btnYes.isHidden = true
                listCell?.questionLbl.text = dict.stringValueForKey("title")
            return listCell!
                                  
                              
            }
            else if dict.stringValueForKey("inputType") == "date" {
                listCell = (self.listTableView.dequeueReusableCell(withIdentifier: "pickerCell") as! ListCell)
                listCell?.dateTF.delegate = self

                if dict.stringValueForKey("placeholder") == "" {
                    listCell!.dateTF.placeholder = "Date"
                }
                return listCell!
            }
            
            
        }
        return listCell!
        
    }
    @objc func likeUnlike(sender:UIButton) {
           
           let buttonRow = sender.tag
        var dic = self.arrayEventList[buttonRow]
         
        var strFav = ""
        if dic.stringValueForKey("isRequired") == "no" {
            strFav = "yes"
        }else if dic.stringValueForKey("isRequired") == "yes" {
            strFav = "no"
        }
        dic["isRequired"] = strFav as AnyObject
        self.arrayEventList[(buttonRow)] = (dic as AnyObject) as! Dictionary<String, AnyObject>
        let indexPath = IndexPath(item: buttonRow, section: 0)
        self.listTableView.reloadRows(at: [indexPath], with: .fade)
    }
    @objc func likeUnlike1(sender:UIButton) {
           
           let buttonRow = sender.tag
        var dic = self.arrayEventList[buttonRow]
        var strFav = ""
        if dic.stringValueForKey("isRequired") == "no" {
            strFav = "yes"
        }else if dic.stringValueForKey("isRequired") == "yes" {
            strFav = "no"
        }
        dic["isRequired"] = strFav as AnyObject
        self.arrayEventList[(buttonRow)] = (dic as AnyObject) as! Dictionary<String, AnyObject>
        let indexPath = IndexPath(item: buttonRow, section: 0)
        self.listTableView.reloadRows(at: [indexPath], with: .fade)
    }
   func pickUpDate(_ textField : UITextField){

        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
    self.datePicker.datePickerMode = UIDatePicker.Mode.date
        textField.inputView = self.datePicker

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar

    }
   @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
    listCell?.txtField.text = dateFormatter1.string(from: datePicker.date)
    listCell?.txtField.resignFirstResponder()

    }
    @objc func cancelClick() {
        listCell?.txtField.resignFirstResponder()

    }
    @IBAction func cancelBtn(sender: AnyObject) {
        datePickerView.isHidden = true
    }
    @IBAction func doneBtn(sender: AnyObject) {
        datePickerView.isHidden = true
        let dateFormatter = DateFormatter()
                   dateFormatter.dateStyle = .short
                   dateFormatter.timeStyle = .none
        print(dateFormatter.string(from: sender.date))
               listCell?.dateLbl.text = dateFormatter.string(from: sender.date)
//        listCell?.dateLbl.text = date.string(from: sender.date)
       }
    @IBAction func BtnClicked(sender: UIButton) {
        let buttonRow = sender.tag
selectedIndex = buttonRow
        
        self.datepick()
//        datePickerView.isHidden = false
//        let currentDate: NSDate = NSDate()
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneTapped))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneTapped))
//
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//
////        listCell?.dateTF.inputView = datePicke
//        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//        // let calendar: NSCalendar = NSCalendar.currentCalendar()
//        calendar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//
//        let components: NSDateComponents = NSDateComponents()
//        components.calendar = calendar as Calendar
//
//        components.year = 0
//        let minDate: NSDate = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
//
//        components.year = 5
//        let maxDate: NSDate = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
//
//        self.datePicke.minimumDate = minDate as Date
//        self.datePicke.maximumDate = maxDate as Date
//
//
//        self.view.addSubview(datePickerView)
    }
    //MARK:- datepicker methods
    func datepick(){

        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let currentDate: Date = Date()
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -80
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        datePickerView.maximumDate = currentDate
        
        datePickerView.minimumDate = minDate
        let doneButton = UIBarButtonItem(title: "Done   ", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleDatePicker(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
       
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        self.listTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)

        self.listCell?.dateTF.inputView = datePickerView

               self.listCell?.dateTF.isUserInteractionEnabled = true

    }
    //MARK:- done btn action
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.listCell?.dateTF.text = dateFormatter.string(from: sender.date)
    }

    @objc func doneTapped() {
//           self.toolbarDelegate?.didTapDone()
       }

       @objc func cancelTapped() {
//           self.toolbarDelegate?.didTapCancel()
       }
    @objc func dueDateChanged(sender:UIDatePicker){
       let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
        listCell?.dateLbl.text = dateFormatter.string(from: sender.date)
    }
}

extension HomePageVC : UITextFieldDelegate {
    //MARK:- textfield delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.placeholder!)
        if textField == listCell!.dateTF {
                self.pickUpDate((listCell?.dateTF)!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == listCell?.txtField
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
        if string.count != 0 {
            listCell?.txtField.text = string
        }
        return true
    }
}
