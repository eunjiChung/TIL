//
//  ViewController.swift
//  PickerViewToolBar
//
//  Created by CHUNGEUNJI on 07/09/2019.
//  Copyright © 2019 CHUNGEUNJI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var myTextField: UITextField!
    var myPickerView: UIPickerView!
    var pickerData = ["Hitesh Modi" , "Kirit Modi" , "Ganesh Modi" , "Paresh Modi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didSelectButton(_ sender: Any) {
        
    }
    
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.myTextField.text = pickerData[row]
    }
    
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("EEE")
        pickUp(myTextField)
    }
    
    // MARK: - Private
    func pickUp(_ myField: UITextField) {
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        myField.inputView = self.myPickerView
        
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        myField.inputAccessoryView = toolBar
    }
    
    //MARK:- Button
    @objc func doneClick() {
        myTextField.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        myTextField.resignFirstResponder()
    }
    
    
    
}

