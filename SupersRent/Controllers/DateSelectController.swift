//
//  DateController.swift
//  SupersRent
//
//  Created by ivrylobs on 6/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit
import KDCalendar

class DateSelectController: UIViewController {
    
    var groupSelect: GroupModel?
    var locationSelect: LocationModel?
    var dateSelect: [DateModel]?
    
    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let style = CalendarView.Style()
        
        style.cellShape                = .bevel(20.0)
        style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.headerTextColor = UIColor.black
        style.weekdaysTextColor = UIColor.black
        style.cellSelectedTextColor = UIColor.yellow
        style.weekdaysBackgroundColor  = UIColor(rgb: 0xFECA1E)
        style.headerBackgroundColor = UIColor(rgb: 0xFECA1E)
        style.cellColorDefault          = UIColor(rgb: 0x393E46)
        style.cellTextColorToday       = UIColor.orange
        style.cellTextColorDefault     = UIColor.white
        style.firstWeekday             = .sunday
        style.locale                   = Locale(identifier: "th_TH")
        
        self.calendarView.style = style
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        
        //Setup Calendar style after initialized.
        self.calendarView.marksWeekends = true
        self.calendarView.direction = .horizontal
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Date()
        self.calendarView.setDisplayDate(today, animated: false)
    }
    @IBAction func backToHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DateSelectController: CalendarViewDataSource {
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 12
        let today = Date()
        let nextYear = self.calendarView.calendar.date(byAdding: dateComponents, to: today)
        print(nextYear!)
        if let dayEnd = nextYear {
            return dayEnd
        } else {
            return Date()
        }
    }
    
    func headerString(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "th_TH")
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
}

extension DateSelectController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        if calendar.selectedDates.count == 2 {
            
            if self.calendarView.selectedDates[0] > self.calendarView.selectedDates[1] {
                self.calendarView.deselectDate(self.calendarView.selectedDates[0])
            } else {
                let dateFormatter = DateFormatter()
                let presenter = self.presentingViewController as? HomeController
                
                dateFormatter.locale = Locale(identifier: "th_TH")
                dateFormatter.dateFormat = "d LLLL yyyy"
                let dateStringFormatted = "\(dateFormatter.string(from: self.calendarView.selectedDates[0])) - \(dateFormatter.string(from: self.calendarView.selectedDates[1]))"
                presenter?.dateButton.setTitle(dateStringFormatted, for: .normal)
                presenter?.searchDate = DateModel(firstDate: self.calendarView.selectedDates[0], finalDate: self.calendarView.selectedDates[1])
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        
    }
}
