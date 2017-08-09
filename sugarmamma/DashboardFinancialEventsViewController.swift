//
//  DashboardFinancialEventsViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 16/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class DashboardFinancialEventsViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate{
    
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var eventTypes = ["Income", "Expense"]
    var blurredEffect: UIVisualEffectView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        // change the code to get a vertical calender.
        calendarView.direction = .horizontal
        self.calendarView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.loadEventsInCalendar()
        
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        let today = Date()
        print(today) //timezone bug? shows yesterday not today
        print("//timezone bug? shows yesterday not today")
        
        if let tomorrow = (self.calendarView.calendar as NSCalendar).date(byAdding: tomorrowComponents, to: today, options: NSCalendar.Options()) {
            self.calendarView.selectDate(tomorrow)
            //self.calendarView.deselectDate(date)
            
        }
        
        self.calendarView.setDisplayDate(today, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsHelper.notifyScreen("Dashboard Financial Events")
    }
    
    // MARK : KDCalendarDataSource
    
    func startDate() -> Date? {
        //@todo redo leveraging self.calendarView
        
        //set start date to beginning of this year
        var dateComponent = DateComponents()
        dateComponent.year = Calendar.current.dateComponents([.year], from: Date()).year
        dateComponent.month = 1
        dateComponent.day = 1
        //dateComponent.timeZone = TimeZone(abbreviation: DateHelper.getTimezoneAbbreviation())
        return Calendar.current.date(from: dateComponent)
        
    }
    
    func endDate() -> Date? {
        
        //project one year into the future from todya
        var dateComponents = DateComponents()
        
        dateComponents.year = 1;
        let today = Date()
        
        let twoYearsFromNow = (self.calendarView.calendar as NSCalendar).date(byAdding: dateComponents, to: today, options: NSCalendar.Options())
        
        return twoYearsFromNow
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.frame.size.width - 16.0 * 2
        let height = self.view.frame.size.height - 218 //60 for nav bar + 100 for header label and add button (approx)
        self.calendarView.frame = CGRect(x: 0, y: 30, width: width, height: height)
    }
    
    
    // MARK : KDCalendarDelegate
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        
        for _ in events {
            // print("You have an event starting at \(event.endDate) : \(event.title)")
        }
        //print("Did Select: \(date) with Events: \(events.count)")
        if events.count > 0{
            let dayController = UIStoryboard(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardFinancialDayViewController") as! DashboardFinancialDayViewController
            dayController.financialDayDate = date
            self.navigationController?.pushViewController(dayController, animated:true)
        }
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        self.datePicker.setDate(date, animated: true)
    }
    
    func loadEventsInCalendar() {
        
        if let startDate = self.startDate(),
            let endDate = self.endDate() {
            //print(startDate)
            //print(" to ")
            //print(endDate)
            self.calendarView.events = FinancialEventManager.fetchBetweenRange(start: startDate, end: endDate)
            //print(self.calendarView.events!)
            //print("----end------")
        }
    }
    
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        self.calendarView.setDisplayDate(picker.date, animated: true)
    }
    
    @IBAction func eventCreateAction(_ sender: UIButton) {
        let popupController = UIStoryboard(name: "Setup", bundle    : Bundle.main).instantiateViewController(withIdentifier: "FinancialEventsPopupViewController") as! FinancialEventsPopupViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.isNew = true
        self.present(popupController, animated: true)
    }
    
}
