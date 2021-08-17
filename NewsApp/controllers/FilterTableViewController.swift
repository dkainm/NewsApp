//
//  FilterTableViewController.swift
//  NewsApp
//
//  Created by Alex Rudoi on 12/8/21.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var dateFromLabel: UILabel!
    
    let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        return picker
    }()
    
    let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerDoneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancelTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }()
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setValues()
    }
    
    private func setup() {
        datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        
        picker.delegate = self
        picker.dataSource = self
        
        countryTextField.inputView = picker
        countryTextField.inputAccessoryView = toolBar
    }
    
    private func setValues() {
        countryTextField.text = userDefaults.string(forKey: userCountry)
    }
    
    @objc func datePicked() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datePicker.date)
        dateFromLabel.text = strDate
    }
    
    @objc func pickerDoneTapped() {
        userDefaults.setValue(countryTextField.text, forKey: userCountry)
        countryTextField.resignFirstResponder()
    }
    
    @objc func pickerCancelTapped() {
        countryTextField.text = userDefaults.string(forKey: userCountry)
        countryTextField.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            countryTextField.becomeFirstResponder()
//        case 1:
//            switch indexPath.row {
//            case 0:
//            //From
//
//            case 1:
//            //To
//
//            }
        default: break
        }
    }
    
    
}

//MARK: – Picker View Data Source & Delegate

extension FilterTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countriesArray().count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countriesArray()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = countriesArray()[row]
    }
    
}

