//
//  ForecastOverviewViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 13/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import Charts

class ForecastOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var forecastOverviewTable: UITableView!
    
    @IBOutlet weak var forecastIntervalLabel: UILabel!
    
    @IBOutlet weak var forecastSelectedMonthLabel: UILabel!
    
    @IBOutlet weak var forecastLineChart: LineChartView!
    
    @IBOutlet weak var currentMonthNext: UIButton!
    
    @IBOutlet weak var forecastPeriodNext: UIButton!
    
    @IBAction func currentMonthBack(_ sender: UIButton) {
        if currentMonth > 0 {
            currentMonth = currentMonth - 1
            reloadData()
        }else{
            if currentYear > (gregorian as NSCalendar).component(NSCalendar.Unit.year, from: Date()){
                currentMonth = 11 //december
                currentYear = currentYear - 1
                reloadData()
            }
        }
    }
    
    @IBAction func forecastPeriodBack(_ sender: UIButton) {
        switch chartPeriodInMonths {
        case 3:
            chartPeriodInMonths = 12
            break
        case 6:
            chartPeriodInMonths = 3
            break
        case 12:
            chartPeriodInMonths = 6
            break
        default:
            break
        }
        reloadData()
    }
    
    @IBAction func currentMonthNext(_ sender: UIButton) {
        if currentMonth < 11 {
            currentMonth = currentMonth + 1
            reloadData()
        }else{
            if currentYear < (gregorian as NSCalendar).component(NSCalendar.Unit.year, from: Date()) + 1{
                currentMonth = 0
                currentYear = currentYear + 1
                reloadData()
            }
        }
    }
    
    @IBAction func forecastPeriodNext(_ sender: UIButton) {
        switch chartPeriodInMonths {
        case 3:
            chartPeriodInMonths = 6
            break
        case 6:
            chartPeriodInMonths = 12
            break
        case 12:
            chartPeriodInMonths = 3
            break
        default:
            break
        }
        reloadData()
    }
    
    lazy var gregorian : Calendar = {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal
    }()
    
    var forecastService = ForecastService()
    var currentMonth = Calendar.current.component(.month, from: Date()) - 1
    var chartPeriodInMonths = 6 //3 //12
    var months: [String] = []
    
    var currentYear: Int = 2017 //hard set it for now, to avoid bloody optionals
    var income: [ChartDataEntry] = [ChartDataEntry]()
    var expenses: [ChartDataEntry] = [ChartDataEntry]()
    var life: [ChartDataEntry] = [ChartDataEntry]()
    var savings: [ChartDataEntry] = [ChartDataEntry]()
    var justLoaded: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentYear = (gregorian as NSCalendar).component(NSCalendar.Unit.year, from: Date())
        //fix alignment right button alignment
        currentMonthNext.semanticContentAttribute = .forceRightToLeft
        forecastPeriodNext.semanticContentAttribute = .forceRightToLeft
        reloadData()
        justLoaded = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !justLoaded{
            reloadData()
        }else{
            justLoaded = false
        }
        
    }
    
    func reloadData(){
        forecastSelectedMonthLabel.text = forecastService.monthNotationLong[currentMonth] + " \(currentYear)"
        forecastIntervalLabel.text = "\(chartPeriodInMonths) month breakdown"
        forecastIntervalLabel.adjustsFontSizeToFitWidth = true
        forecastService.reloadData(fromYear: currentYear)
        forecastOverviewTable.reloadData()
        renderChart()
    }
    
    func renderChart() {
        months = []
        income = []
        expenses = []
        life = []
        savings = []
        
        //populate month array of labels
        var thisMonth = currentMonth
        for _ in 0 ..< chartPeriodInMonths{
            months.append(forecastService.monthNotationShort[thisMonth])
            //print(forecastService.monthNotationShort[thisMonth])
            if thisMonth < 11 {
                thisMonth = thisMonth + 1
            }else{
                thisMonth = 0
            }
        }
        
        //plot totals
        thisMonth = currentMonth
        var thisYear = currentYear
        for i in 0 ..< chartPeriodInMonths{
            let totals = forecastService.getMonthTotals(month: thisMonth, year: thisYear)
            income.append(ChartDataEntry(x: Double(i), y: totals["income"]!))
            expenses.append(ChartDataEntry(x: Double(i), y: totals["expenses"]!))
            life.append(ChartDataEntry(x: Double(i), y: totals["life"]!))
            savings.append(ChartDataEntry(x: Double(i), y: totals["savings"]!))
            if thisMonth < 11 {
                thisMonth = thisMonth + 1
            }else{
                thisYear = thisYear + 1
                thisMonth = 0
            }
        }
        
        //plot lines
        let incomeSet: LineChartDataSet = chartSetHelper(LineChartDataSet(values: income, label: ""), color: forecastService.incomeColor)
        let expensesSet: LineChartDataSet = chartSetHelper(LineChartDataSet(values: expenses, label: ""), color: forecastService.expensesColor)
        let lifeSet: LineChartDataSet = chartSetHelper(LineChartDataSet(values: life, label: ""), color: forecastService.lifeColor)
        let savingsSet: LineChartDataSet = chartSetHelper(LineChartDataSet(values: savings, label: ""), color: forecastService.savingsColor)
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = []
        dataSets.append(incomeSet)
        dataSets.append(expensesSet)
        dataSets.append(lifeSet)
        dataSets.append(savingsSet)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(dataSets: dataSets)
        //data.setValueTextColor(UIColor.white)
        
        //5 - finally set our data
        forecastLineChart.data = data
        forecastLineChart.chartDescription?.text = ""
        forecastLineChart.leftAxis.drawLabelsEnabled = false
        forecastLineChart.rightAxis.drawLabelsEnabled = false
        forecastLineChart.rightAxis.drawGridLinesEnabled = false
        forecastLineChart.leftAxis.drawGridLinesEnabled = false //remove x  horizontal lines
        forecastLineChart.rightAxis.drawGridLinesEnabled = false
        forecastLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        forecastLineChart.xAxis.granularity = 1
        //forecastLineChart.xAxis.drawLabelsEnabled = false
        //forecastLineChart.xAxis.drawGridLinesEnabled = false
        //forecastLineChart.xAxis.drawAxisLineEnabled = false //TOP LINE
        forecastLineChart.drawGridBackgroundEnabled = false
        forecastLineChart.drawBordersEnabled = true
        forecastLineChart.borderColor = GlobalVariables.borderGrey
        forecastLineChart.borderLineWidth = 0.5
        forecastLineChart.legend.enabled = false
        forecastLineChart.notifyDataSetChanged()
        forecastLineChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInCirc)
    }
    
    func chartSetHelper(_ chartDataSet: LineChartDataSet, color: UIColor) -> LineChartDataSet{
        chartDataSet.setColor(color.withAlphaComponent(0.5))
        chartDataSet.setCircleColor(color)
        chartDataSet.axisDependency = .left // Line will correlate with left axis values
        chartDataSet.circleHoleColor = color
        chartDataSet.fillColor = color
        chartDataSet.lineWidth = 4.0
        chartDataSet.circleRadius = 6.0
        chartDataSet.drawValuesEnabled = false
        chartDataSet.fillAlpha = 65 / 255.0
        chartDataSet.highlightColor = UIColor.white
        chartDataSet.drawCircleHoleEnabled = true
        return chartDataSet
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        //  forecastLineChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier = "ForecastOverviewTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ForecastOverviewTableViewCell
        
        //current month will always be the 0 indexed element of the respective totals key array
        if indexPath.row == 0{
            cell.segmentLabel.text = forecastService.incomeLabel
            let total = income[0]
            cell.segmentAmount.text = "$" + String(format: "%.2f", total.y)
            cell.segmentLabel.textColor = forecastService.incomeColor
        }
        if indexPath.row == 1{
            cell.segmentLabel.text = forecastService.expensesLabel
            let total = expenses[0]
            cell.segmentAmount.text = "$" + String(format: "%.2f", total.y)
            cell.segmentLabel.textColor = forecastService.expensesColor
        }
        if indexPath.row == 2{
            cell.segmentLabel.text = forecastService.lifeLabel
            let total = life[0]
            cell.segmentAmount.text = "$" + String(format: "%.2f", total.y)
            cell.segmentLabel.textColor = forecastService.lifeColor
            if forecastService.lifeExpenseError[currentYear]![currentMonth]!{
                cell.warningButtonIcon.isHidden = false
            }else{
                cell.warningButtonIcon.isHidden = true
            }
        }
        if indexPath.row == 3{
            cell.segmentLabel.text = forecastService.savingsLabel
            let total = savings[0]
            cell.segmentAmount.text = "$" + String(format: "%.2f", total.y)
            cell.segmentLabel.textColor = forecastService.savingsColor
            if forecastService.savingsExpenseError[currentYear]![currentMonth]!{
                cell.warningButtonIcon.isHidden = false
            }else{
                cell.warningButtonIcon.isHidden = true
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSegment" {
            if let indexPath = self.forecastOverviewTable.indexPathForSelectedRow {
                let controller = segue.destination as? ForecastSegmentViewController
                controller?.forecastSegmentLabel = forecastService.segments[indexPath.row]
                let segmentText = forecastService.segmentText[indexPath.row]
                controller?.forecastSegmentText = segmentText
                controller?.forecastMonth = forecastService.monthNotationLong[currentMonth]
                var monthData = forecastService.getMonthData(month: currentMonth, year: currentYear)
                var segmentBreakdown: [ForecastStruct] = []
                switch indexPath.row {
                case 0:
                    controller?.forecastSegmentText = segmentText + forecastService.monthNotationLong[currentMonth] + "."
                    segmentBreakdown = monthData["income"]!
                    break
                case 1:
                    segmentBreakdown = monthData["expenses"]!
                    break
                case 2:
                    //change
                    segmentBreakdown = monthData["life"]!
                    break
                case 3:
                    segmentBreakdown = monthData["savings"]!
                    break
                default:
                    break
                }
                controller?.forecastSegmentBreakdown = segmentBreakdown
            }
        }
    }
    
    
}
