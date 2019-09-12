//
//  Date+CustomFormatter.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 10/09/2019.
//  Copyright © 2019 Genar Codina Reverter. All rights reserved.
//

import Foundation

extension Date {
    
    /// Returns the formatted strings according to
    /// the given patterns strings related to format.
    ///
    /// - Parameters:
    ///     - stringDate: The *stringDate* component to be formatted.
    ///     - stringFormatterOrigin: The *stringFormatterOrigin* component used as a pattern for the *stringDate*. i.e.:"yyyy-MM-dd'T'HH:mm:ssZ"
    ///     - stringFormatterTarget: The *stringFormatterTarget* component used as a patter for the returned formatted string. i.e.:"MMM dd,yyyy"
    static func getFormattedDate(stringDate: String, stringFormatterOrigin: String, stringFormatterTarget: String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = stringFormatterOrigin
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = stringFormatterTarget
        
        let date: Date? = dateFormatterGet.date(from: stringDate)
        if let date = date {
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }
}
