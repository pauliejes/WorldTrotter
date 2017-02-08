//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Paul Jesukiewicz on 1/25/17.
//  Copyright © 2017 Paul Jesukiewicz. All rights reserved.
//


import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    //Update the Celsius label based on the fahrenheit value
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    //Take fahrenheitValue and convert it to celsius
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    //This lets you customize the display of a number
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    //Grab the current celsuis valuse and update the label
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    //Update celsuis label on view load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loded its view.")
        
        updateCelsiusLabel()
    }
    
    //Allows keyboard to dissappear when done with it
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        //Disable any non integer input
        let permittedInput = CharacterSet.decimalDigits
        let charSet = CharacterSet(charactersIn: string)
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        } else { //Rerurn the input if int value
            return permittedInput.isSuperset(of: charSet)
        }
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        let hour = NSCalendar.currentCalendar.component(NSCalendar.Unit.hour, from: NSDate())
//        if (hour > 18 || hour < 6) {
//            view.backgroundColor = UIColor.lightGray
//        } else {
//            view.backgroundColor = UIColor.white
//        }
//    }
    
    //Update fahrenheit value based on the input
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
}
