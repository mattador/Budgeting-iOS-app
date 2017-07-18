//
//  CurrencyControl.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 1/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

@IBDesignable class CurrencyControl: UIStackView {
    
    var currentOption = "$"
    
    //MARK: Properties
    private var currencyButtons = [UIButton]()
    var currencies = ["$", "€", "£"]
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    open var currencyChanged: ((_ currency: String) -> ())?
    
    private func setupButtons() {
        for currencyCode in currencies{
            // Create the button
            let button = UIButton()
            button.clipsToBounds = true
            button.layer.cornerRadius = 5
            button.layer.borderColor = GlobalVariables.borderGrey.cgColor
            button.layer.borderWidth = CGFloat(0.5)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
            button.addTarget(self, action: #selector(CurrencyControl.currencyOptionTapped(button:)), for: .touchUpInside)
            button.setTitle(currencyCode, for: .normal)
            button.titleLabel?.font = UIFont(name: "SFDisplay-Text Light", size: 12)
            button.backgroundColor = UIColor.white
            button.setTitleColor(GlobalVariables.lightTextGrey, for: .normal)
            // Add the button to the stack
            addArrangedSubview(button)
            currencyButtons.append(button)
        }
    }
    
    func selectCurrency(_ currency: String){
        currentOption = currency
        for btn in currencyButtons{
            if currency == btn.titleLabel?.text{
                btn.setTitleColor(UIColor.white, for: .normal)
                btn.backgroundColor = GlobalVariables.pastelGreen
            }else{
                
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(GlobalVariables.lightTextGrey, for: .normal)
            }
            
        }
    }
    
    //MARK: Button Action
    func currencyOptionTapped(button: UIButton){
        let currentOption = button.titleLabel!.text!
        selectCurrency(currentOption)
        currencyChanged?(currentOption)
    }
}
