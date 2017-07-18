//
//  BaseSetupControllerViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 23/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class BaseSetupControllerViewController: UIViewController {
    
    @IBOutlet weak var expensesAmount: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    @IBOutlet weak var surplusDeficitAmount: UILabel!
    
    var userModel: UserModel = UserManager.fetch()!
    
    func collectTotals() {
        let totals = BudgetManager.collectTotals()
        expensesAmount.text = CurrencyHelper.format(totals["expenses"]!, currencyCode: userModel.currency!)
        incomeAmount.text = CurrencyHelper.format(totals["income"]!, currencyCode: userModel.currency!)
        if totals["deficit"]! < 0.0 {
            surplusDeficitAmount.textColor = GlobalVariables.pinkRed
        }else{
            surplusDeficitAmount.textColor = GlobalVariables.pastelGreen
        }
        surplusDeficitAmount.text = CurrencyHelper.format(totals["deficit"]!, currencyCode: userModel.currency!)
    }
    
    func getIndexPathRelativeToUIView(_ prototypeCellElement: UIView) -> IndexPath?{
        //traverse through view structure to find indexPath, as alternative to setting in element .tag attribute
        var cellReference = prototypeCellElement
        var cell: UITableViewCell? = nil
        for _ in 1 ... 5{
            let classType = String(describing: type(of: cellReference))
            //print( classType)
            if classType.hasSuffix("TableViewCell"){
                cell = cellReference as? UITableViewCell
                break
            }
            cellReference = cellReference.superview!
        }
        if cell != nil{
            var tableReference = cell!.superview
            var table: UITableView
            for _ in 1 ... 5{
                if  (tableReference?.isKind(of: UITableView.classForCoder()))! {
                    table = tableReference as! UITableView
                    if let indexPath = table.indexPath(for: cell!){
                        return indexPath
                    }
                }
                tableReference = tableReference?.superview
            }
        }
        return nil
    }
}
