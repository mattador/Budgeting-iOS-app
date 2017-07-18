//
//  ForecastService.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 22/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

//struct for income/expense calculations
//MARK: todo - reduce verbosity, I couldn't think of a better pragmatic approach while developing this application
class ForecastService: NSObject {
    
    
    //year month bool flag
    var lifeExpenseError: [Int: [Int: Bool]] = [:]
    //year month bool flag
    var savingsExpenseError: [Int: [Int: Bool]] = [:]
    
    var segments: [String] = ["Income", "Monthly expenses", "Life account", "Savings account"]
    
    var segmentText = [
        "This is your forecasted income for the month of ",
        "This is your everyday cash account, where you keep your monthly expenses – use your ATM debt card to pay for your everyday expenses (within your budget!). From this account and have all your fortnightly/ monthly expenses come out of this account via direct debit. Living off cash will help keep you out of debt.",
        "This is your savings account where you build up cash for those quarterly, biannual or annual expenses. This is also where you have a buffer for those expenses that cost more than you planned for as well as have some emergency money for things that just happen in life. This will help you feel in control of your cash and help you keep out of debt if a sudden nasty unexpected bill catches you by surprise.",
        "This is optional but advisable, it is where you park your savings for your short to medium term goals or where you put money that you would like to eventually invest while you decide where and how you want to invest it."
    ]
    
    var monthNotationLong = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var monthNotationShort = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    //Monthly expenses
    var expensesLabel:String = "Monthly expenses"
    var expensesColor:UIColor = GlobalVariables.pinkRed
    var expensesBreakdown: [Int: [Int: [ForecastStruct]]] = [:]
    
    //Income
    var incomeLabel:String = "Income"
    var incomeColor:UIColor = GlobalVariables.purple
    var incomeBreakdown: [Int: [Int: [ForecastStruct]]] = [:]
    
    //Life account
    var lifeLabel:String = "Life account"
    var lifeColor:UIColor = GlobalVariables.pastelYellow
    var lifeBreakdown: [Int: [Int: [ForecastStruct]]] = [:]
    
    //Savings account
    var savingsLabel:String = "Savings account"
    var savingsColor:UIColor = GlobalVariables.pastelGreen
    var savingsBreakdown: [Int: [Int: [ForecastStruct]]] = [:]
    
    func getMonthTotals(month: Int, year: Int) -> [String:Double]{
        var totals = [
            "income": 0.0,
            "expenses": 0.0,
            "life": 0.0,
            "savings": 0.0
        ]
        for forecastStruct in incomeBreakdown[year]![month]!{
            totals["income"] = totals["income"]! + forecastStruct.amount
        }
        for forecastStruct in expensesBreakdown[year]![month]!{
            totals["expenses"] = totals["expenses"]! + forecastStruct.amount
        }
        for forecastStruct in lifeBreakdown[year]![month]!{
            totals["life"] = totals["life"]! + forecastStruct.amount
        }
        for forecastStruct in savingsBreakdown[year]![month]!{
            totals["savings"] = totals["savings"]! + forecastStruct.amount
        }
        return totals
    }
    
    func getMonthData(month: Int, year: Int) -> [String:[ForecastStruct]]{
        return [
            "income": incomeBreakdown[year]![month]!,
            "expenses": expensesBreakdown[year]![month]!,
            "life": lifeBreakdown[year]![month]!,
            "savings": savingsBreakdown[year]![month]!
        ]
    }
    
    func getMonthlyIntervals(startMonth: Int, intervalsPerYear: Int) -> [Int]{
        let monthsBetweenIntervals = 12 / intervalsPerYear
        var calculatedMonthlyIntervals: [Int] = [startMonth]
        var currentMonth = startMonth
        repeat{
            var nextOffset = currentMonth + monthsBetweenIntervals
            if nextOffset >= 12{
                //if 12 for instance this would be rewound back to february being that the month are zero indexed i.e. 0 - 11
                nextOffset = nextOffset - 12
            }
            currentMonth = nextOffset
            calculatedMonthlyIntervals.append(nextOffset)
        }while calculatedMonthlyIntervals.count < intervalsPerYear
        return calculatedMonthlyIntervals
    }
    
    func reloadData(fromYear: Int){
        //Reset data stores
        let toYear = fromYear + 1
        for y in fromYear...toYear{
            
            lifeExpenseError[y] = [:]
            savingsExpenseError[y] = [:]
            
            incomeBreakdown[y] = [:]
            expensesBreakdown[y] = [:]
            lifeBreakdown[y] = [:]
            savingsBreakdown[y] = [:]
            for i in 0 ..< 12{
                lifeExpenseError[y]![i] = false
                savingsExpenseError[y]![i] = false
                
                incomeBreakdown[y]![i] = []
                expensesBreakdown[y]![i] = []
                lifeBreakdown[y]![i] = []
                savingsBreakdown[y]![i] = []
            }
        }
        calculateIncomeExpenseBudget(fromYear: fromYear, toYear: toYear)
        calculateFinancialEvents() //life account
        calculateSavingsGoals() //goals set in the past (i.e. created date is after goal date) get lumped into one movement
    }
    
    
    func calculateIncomeExpenseBudget(fromYear:Int, toYear:Int){
        for item in BudgetManager.fetchAll(){
            //update - refactored to take into account start month and year
            let itemYear = Int(DateHelper.toString(item.start_date! as Date, dateFormat: "yyyy"))!
            let itemMonth = Int(DateHelper.toString(item.start_date! as Date, dateFormat: "MM"))! - 1
            for y in fromYear...toYear{
                
                if item.amount > 0 && y >= itemYear {
                    if let frequency = item.frequency{
                        var breakdown = ForecastStruct()
                        breakdown.label = item.label!
                        breakdown.category = item.category!
                        switch frequency {
                        case "Yearly":
                            breakdown.amount = item.amount
                            if item.type == "income"{
                                incomeBreakdown[y]![itemMonth]!.append(breakdown)
                            }else{
                                expensesBreakdown[y]![itemMonth]!.append(breakdown)
                            }
                            break
                        case "Half-yearly":
                            breakdown.amount = item.amount
                            //twice a year from start month and year
                            let monthlyIntervals = getMonthlyIntervals(startMonth: itemMonth, intervalsPerYear: 2)
                            //from start month onwards for start year
                            for i in monthlyIntervals{
                                if y == itemYear &&  i < itemMonth {
                                    continue
                                }
                                if item.type == "income"{
                                    incomeBreakdown[y]![i]!.append(breakdown)
                                }else{
                                    expensesBreakdown[y]![i]!.append(breakdown)
                                }
                            }
                            break
                        case "Quarterly":
                            breakdown.amount = item.amount
                            //four times a year from start month and year
                            let monthlyIntervals = getMonthlyIntervals(startMonth: itemMonth, intervalsPerYear: 4)
                            //from start month onwards for start year
                            for i in monthlyIntervals{
                                if y == itemYear && i < itemMonth {
                                    continue
                                }
                                if item.type == "income"{
                                    incomeBreakdown[y]![i]!.append(breakdown)
                                }else{
                                    expensesBreakdown[y]![i]!.append(breakdown)
                                }
                            }
                            break
                        case "Monthly":
                            breakdown.amount = item.amount
                            let monthlyIntervals = getMonthlyIntervals(startMonth: itemMonth, intervalsPerYear: 12)
                            //from start month onwards for start year
                            for i in monthlyIntervals{
                                if y == itemYear && i < itemMonth {
                                    //print("skipping \(i) < \(itemMonth) for year \(itemYear)")
                                    continue
                                }
                                if item.type == "income"{
                                    incomeBreakdown[y]![i]!.append(breakdown)
                                }else{
                                    expensesBreakdown[y]![i]!.append(breakdown)
                                }
                            }
                            break
                        case "Fortnightly":
                            breakdown.amount = (item.amount * 26) / 12
                            //twelve times a year from start month and year
                            breakdown.amount = item.amount
                            let monthlyIntervals = getMonthlyIntervals(startMonth: itemMonth, intervalsPerYear: 12)
                            //from start month onwards for start year
                            for i in monthlyIntervals{
                                if y == itemYear && i < itemMonth {
                                    continue
                                }
                                if item.type == "income"{
                                    incomeBreakdown[y]![i]!.append(breakdown)
                                }else{
                                    expensesBreakdown[y]![i]!.append(breakdown)
                                }
                            }
                            break
                        case "Weekly":
                            //twelve times a year from start month and year
                            breakdown.amount = (item.amount * 52) / 12
                            let monthlyIntervals = getMonthlyIntervals(startMonth: itemMonth, intervalsPerYear: 12)
                            //from start month onwards for start year
                            for i in monthlyIntervals{
                                if y == itemYear && i < itemMonth {
                                    continue
                                }
                                if item.type == "income"{
                                    incomeBreakdown[y]![i]!.append(breakdown)
                                }else{
                                    expensesBreakdown[y]![i]!.append(breakdown)
                                }
                            }
                            break
                        default:
                            break
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func calculateFinancialEvents(){
        
        let financialEvents = FinancialEventManager.fetch()
        for eventItem in financialEvents{
            if eventItem.type == "income" {
                //Financial event income is taken on face value and allocated to income on the very month it is due to be deposited
                var breakdown = ForecastStruct()
                breakdown.label = eventItem.event_name!
                breakdown.category = "Financial event"
                breakdown.amount = eventItem.amount
                
                let eventDate: Date = eventItem.event_date! as Date
                let eventYear: Int = Int(DateHelper.toString(eventDate, dateFormat: "YYYY"))!
                let eventMonth: Int = Int(DateHelper.toString(eventDate, dateFormat: "MM"))! - 1
                
                //conditional since might not be in forecastable range (2 years)
                incomeBreakdown[eventYear]?[eventMonth]?.append(breakdown)
            }
        }
        
        for eventItem in financialEvents{
            if eventItem.type == "expense" {
                //Now we deal with financial event expenses (AKA life account expenses)
                //This was developed following the logic provided by the client - see logic pdf file for details
                
                var breakdown = ForecastStruct()
                breakdown.label = eventItem.event_name!
                breakdown.category = "Financial event"
                //print("This is the amount \(eventItem.amount)")
                
                let eventDate: Date = eventItem.event_date! as Date
                let eventYear: Int = Int(DateHelper.toString(eventDate, dateFormat: "YYYY"))!
                let eventMonth: Int = Int(DateHelper.toString(eventDate, dateFormat: "MM"))! - 1
                
                let createdDate: Date = eventItem.event_creation_date! as Date
                let createdYear: Int = Int(DateHelper.toString(createdDate, dateFormat: "YYYY"))!
                let createdMonth: Int = Int(DateHelper.toString(createdDate, dateFormat: "MM"))! - 1
                
                if createdYear > eventYear || (createdMonth > eventMonth && createdYear == eventYear){
                    //event is set in the past so I just lump amount into the relative month, not sure if I should red flag this.....
                    //@todo log this - it shouldn't be accessible
                }else{
                    //print("Initiating debug...")
                    //calculate how many months exist between expense due date and creation date
                    var monthsToEventDue = monthsBetweenDates(startYear: createdYear, startMonth: createdMonth, endYear: eventYear, endMonth: eventMonth)
                    //print("The amount to distribute/calculate is \(eventItem.amount)")
                    //print("There are \(monthsToEventDue) months  between \(eventYear)-\(eventMonth) and \(createdYear)-\(createdMonth)")
                    
                    if monthsToEventDue == 0{
                        //print("Looks like we will need to lump the event expense into one month")
                        //event due on same month as created, this is easy as it is calculated just as a one off life account expense
                        breakdown.amount = eventItem.amount
                        lifeBreakdown[eventYear]![eventMonth]!.append(breakdown)
                        let monthDueData = getMonthTotals(month: eventMonth, year: eventYear)
                        let leftOver = monthDueData["income"]! - monthDueData["expenses"]! - monthDueData["life"]!
                        if leftOver < 0{
                            //red flag
                            lifeExpenseError[eventYear]![eventMonth] = true
                        }
                    }else{
                        //print("Looks like we are going to distribute the expense over several months")
                        //in this case the event expense is payable in more than one month from now and so needs to be "back loaded" as defined by the logic pdf file, and then distributed across the months between when the event was created and the month prior to being due accordingly
                        
                        //1. on month due calculate free funds and allocate them to expense
                        let monthDueData = getMonthTotals(month: eventMonth, year: eventYear)
                        var eventAmountLeft = eventItem.amount
                        let leftOver = monthDueData["income"]! - monthDueData["expenses"]! - monthDueData["life"]!
                        
                        if leftOver > 0{
                            //print("There is $\(leftOver) this on month to pay towards event")
                            var eventAmountLeftAfterSubtractingLeftOver = 0.0
                            if eventAmountLeft - leftOver > 0{
                                eventAmountLeftAfterSubtractingLeftOver = eventAmountLeft - leftOver
                            }else{
                                eventAmountLeftAfterSubtractingLeftOver = 0
                            }
                            let amountPayable = eventAmountLeft - eventAmountLeftAfterSubtractingLeftOver
                            eventAmountLeft = eventAmountLeftAfterSubtractingLeftOver
                            //print("EVent amount left is \(eventAmountLeft) while amount paid towards goal was \(amountPayable)")
                            
                            breakdown.amount = amountPayable
                            lifeBreakdown[eventYear]![eventMonth]!.append(breakdown)
                        }else{
                            //print("There were no funds: $\(leftOver), this on month to pay towards event")
                            //red flag? - no free funds to offset ab amount on initial month event expense payable
                            breakdown.amount = 0 //even though it's zero we should still indicate that it's due on this month
                            lifeBreakdown[eventYear]![eventMonth]!.append(breakdown)
                        }
                        if eventAmountLeft > 0{
                            //print("We still have \(eventAmountLeft) to distribute over the remaining months...")
                            //2. on the remaining months between the current month and the month PRIOR to due month, calculate the left over amount to be distributed evenly
                            let distributable = eventAmountLeft / Double(monthsToEventDue)
                            var currentMonth = eventMonth
                            var currentYear = eventYear
                            while monthsToEventDue > 0{
                                monthsToEventDue -= 1
                                if currentMonth - 1 < 0{
                                    currentMonth = 11
                                    currentYear -= 1
                                }else{
                                    currentMonth -= 1
                                }
                                
                                breakdown.amount = distributable
                                lifeBreakdown[currentYear]![currentMonth]!.append(breakdown)
                                let monthDueData = getMonthTotals(month: currentMonth, year: currentYear)
                                let leftOver = monthDueData["income"]! - monthDueData["expenses"]! - monthDueData["life"]!
                                if leftOver < 0{
                                    //red flag
                                    lifeExpenseError[currentYear]![currentMonth] = true
                                }
                            }
                        }
                    }
                    //print("Debugging complete")
                }
            }
        }
    }
    
    func calculateSavingsGoals(){
        let savingGoals = SavingGoalsManager.fetch()
        for goalItem in savingGoals{
            //NOTE! Only ONE goal is allowed for now as per clients request to simplify calculations, and the logic below factors this in...
            var breakdown = ForecastStruct()
            breakdown.label = goalItem.goal_name!
            breakdown.category = "Goals"
            
            let goalDate: Date = goalItem.goal_due_date! as Date
            let goalYear: Int = Int(DateHelper.toString(goalDate, dateFormat: "YYYY"))!
            let goalMonth: Int = Int(DateHelper.toString(goalDate, dateFormat: "MM"))! - 1
            
            let createdDate: Date = goalItem.goal_creation_date! as Date
            let createdYear: Int = Int(DateHelper.toString(createdDate, dateFormat: "YYYY"))!
            let createdMonth: Int = Int(DateHelper.toString(createdDate, dateFormat: "MM"))! - 1
            
            if createdYear > goalYear || (createdMonth > goalMonth && createdYear == goalYear){
                //@todo log this - it shouldn't be accessible
            }else{
                var monthsToGoalDue = monthsBetweenDates(startYear: createdYear, startMonth: createdMonth, endYear: goalYear, endMonth: goalMonth)
                if monthsToGoalDue == 0{
                    //print("SINGLE MONTH CALC")
                    //goal due on same month it was created
                    
                    let monthDueData = getMonthTotals(month: goalMonth, year: goalYear)
                    let leftOverThisMonth = monthDueData["income"]! - monthDueData["expenses"]! - monthDueData["life"]!
                    if leftOverThisMonth > 0{
                        //print("\(leftOverThisMonth) is free to pay off \(goalItem.amount)")
                        let saved = goalItem.amount - leftOverThisMonth
                        if saved > 0{
                            //red flag there were not enough funds to pay for entirity of goal
                            breakdown.amount = leftOverThisMonth
                            breakdown.goalProgressBar = leftOverThisMonth / goalItem.amount
                            breakdown.goalLastMonthAndNotComplete = true //mark as incomplete
                            savingsExpenseError[goalYear]![goalMonth] = true
                        }else{
                            //There were enough funds to pay off goal
                            breakdown.amount = goalItem.amount
                            breakdown.goalProgressBar = 1
                            breakdown.goalLastMonthAndNotComplete = false
                        }
                    }else{
                        //red flag as there are no left over savings to pay for goal
                        savingsExpenseError[goalYear]![goalMonth] = true
                        breakdown.amount = 0
                        breakdown.goalProgressBar = 0
                        breakdown.goalLastMonthAndNotComplete = true
                    }
                    savingsBreakdown[goalYear]![goalMonth]!.append(breakdown)
                }else{
                    //print("MULTIPLE MONTH CALC")
                    //multiple months to save for goal
                    var goalAmountLeft = goalItem.amount
                    
                    
                    //begin from creation date and count forward to due date
                    var currentMonth = createdMonth
                    var currentYear = createdYear
                    
                    //print("start at \(createdYear)-\(createdMonth) and end on goal date \(goalYear)-\(goalMonth)")
                    
                    //print("there are \(monthsToGoalDue) months to pay off, lets go....")
                    while monthsToGoalDue >= 0{
                        //print("processing \(createdYear)-\(currentMonth)")
                        //print("\(goalAmountLeft) left to pay")
                        if goalAmountLeft > 0{
                            let monthDueData = getMonthTotals(month: currentMonth, year: currentYear)
                            let leftOverThisMonth = monthDueData["income"]! - monthDueData["expenses"]! - monthDueData["life"]!
                            if leftOverThisMonth > 0{
                                if goalAmountLeft - leftOverThisMonth > 0{
                                    goalAmountLeft = goalAmountLeft - leftOverThisMonth
                                    breakdown.amount = leftOverThisMonth
                                    breakdown.goalProgressBar = (goalItem.amount - goalAmountLeft) / goalItem.amount
                                    if monthsToGoalDue == 0{
                                        breakdown.goalLastMonthAndNotComplete = true
                                        savingsExpenseError[goalYear]![goalMonth] = true
                                    }
                                    savingsBreakdown[currentYear]![currentMonth]!.append(breakdown)
                                }else{
                                    //goal reached
                                    breakdown.amount = goalAmountLeft
                                    breakdown.goalProgressBar = 1
                                    savingsBreakdown[currentYear]![currentMonth]!.append(breakdown)
                                    goalAmountLeft = 0
                                }
                            }
                        }else{
                            //goal paid off
                            breakdown.amount = 0
                            breakdown.goalProgressBar = 1
                            savingsBreakdown[currentYear]![currentMonth]!.append(breakdown)
                        }
                        if currentMonth + 1 > 11{
                            currentMonth = 0
                            currentYear += 1
                        }else{
                            currentMonth += 1
                        }
                        monthsToGoalDue -= 1
                    }
                }
                
            }
            //recall comment above about only one goal
            return
        }
    }
    
    func monthsBetweenDates(startYear: Int, startMonth:Int,endYear:Int, endMonth:Int ) -> Int {
        var finalDateFound = false
        var monthCount = 0
        var currentYear = endYear
        var currentMonth = endMonth
        while(!finalDateFound){
            if currentYear < startYear || currentYear == startYear && currentMonth < startMonth {
                break;
            }
            if currentYear == startYear && currentMonth == startMonth{
                finalDateFound = true
            }else{
                if currentMonth > 0{
                    currentMonth -= 1
                }else{
                    currentYear -= 1
                    currentMonth = 11
                }
                monthCount += 1
            }
        }
        return monthCount
    }
    
}



