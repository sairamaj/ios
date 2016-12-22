enum TimeIntervalUnit {
    case Seconds, Minutes, Hours, Days, Months, Years
    
    func dateComponents(interval: Int) -> NSDateComponents {
        var components:NSDateComponents = NSDateComponents()
        
        switch (self) {
        case .Seconds:
            components.second = interval
        case .Minutes:
            components.minute = interval
        case .Days:
            components.day = interval
        case .Months:
            components.month = interval
        case .Years:
            components.year = interval
        default:
            components.day = interval
        }
        return components
    }
}

struct TimeInterval {
    var interval: Int
    var unit: TimeIntervalUnit
    
    var ago: NSDate {
        var calendar = NSCalendar.currentCalendar()
        let today = NSDate()
        var components = unit.dateComponents(-self.interval)
        return calendar.dateByAddingComponents(components, toDate: today, options: nil)!
    }
    
    init(interval: Int, unit: TimeIntervalUnit) {
        self.interval = interval
        self.unit = unit
    }
}

extension Int {
    var seconds: TimeInterval {
        return TimeInterval(interval: self, unit: TimeIntervalUnit.Seconds)
    }
    var minutes: TimeInterval {
        return TimeInterval(interval: self, unit: TimeIntervalUnit.Minutes)
    }
    var days: TimeInterval {
        return TimeInterval(interval: self, unit: TimeIntervalUnit.Days)
    }
    var months: TimeInterval {
        return TimeInterval(interval: self, unit: TimeIntervalUnit.Months);
    }
    var years: TimeInterval {
        return TimeInterval(interval: self, unit: TimeIntervalUnit.Years)
    }
}

func - (let left:NSDate, let right:TimeInterval) -> NSDate {
    var calendar = NSCalendar.currentCalendar()
    var components = right.unit.dateComponents(-right.interval)
    return calendar.dateByAddingComponents(components, toDate: left, options: nil)!
}

func + (let left:NSDate, let right:TimeInterval) -> NSDate {
    var calendar = NSCalendar.currentCalendar()
    var components = right.unit.dateComponents(right.interval)
    return calendar.dateByAddingComponents(components, toDate: left, options: nil)!
}

func < (let left:NSDate, let right: NSDate) -> Bool {
    var result:NSComparisonResult = left.compare(right)
    var isEarlier = false
    if (result == NSComparisonResult.OrderedAscending) {
        isEarlier = true
    }
    return isEarlier
}

func > (let left:NSDate, let right: NSDate) -> Bool {
    var result:NSComparisonResult = left.compare(right)
    var isLater = false
    if (result == NSComparisonResult.OrderedDescending) {
        isLater = true
    }
    return isLater
}

func == (let left:NSDate, let right: NSDate) -> Bool {
    var result:NSComparisonResult = left.compare(right)
    var isEqual = false
    if (result == NSComparisonResult.OrderedSame) {
        isEqual = true
    }
    return isEqual
}

extension NSDate {
    class func yesterday() -> NSDate {
        return NSDate() - 1.days
    }
    
    func toS(let format:String) -> String? {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone()
        formatter.dateFormat = format
        
        return formatter.stringFromDate(self)
    }
}

extension String {
    
    func toDate(let format:String = "dd/MM/yyyy") -> NSDate? {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone()
        formatter.dateFormat = format
        
        return formatter.dateFromString(self)
    }
}


