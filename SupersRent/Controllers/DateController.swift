//
//  DateController.swift
//  SupersRent
//
//  Created by ivrylobs on 6/12/2562 BE.
//  Copyright © 2562 banraomaibab. All rights reserved.
//

import UIKit
import KDCalendar

class DateController: UIViewController {
    
    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.calendarView.style.locale = Locale(identifier: "th_TH")
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

extension DateController: CalendarViewDataSource {
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 3
        let today = Date()
        let threeMonthAhead = self.calendarView.calendar.date(byAdding: dateComponents, to: today)
        print(threeMonthAhead!)
        if let dayEnd = threeMonthAhead {
            return dayEnd
        } else {
            return Date()
        }
    }
    
    func headerString(_ date: Date) -> String? {
        return "Some Header"
    }
    
    
}

extension DateController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        print("didScrollToMonth")
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        print("didSelectDate: \(date)")
        print(calendar.selectedDates)
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        print("didDeselectDate")
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        print("didLongPressDate")
    }
    
    
}
