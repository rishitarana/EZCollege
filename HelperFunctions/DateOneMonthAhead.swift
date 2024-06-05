//
//  DateOneMonthAhead.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 06/05/24.
//

import Foundation

/// function to return an expiry date for the listing
func dateOneMonthAhead(listingDate: Date) -> Date? {
    let calendar = Calendar.current

    if let dateOneMonthAhead = calendar.date(byAdding: .month, value: 1, to: listingDate) {
        return dateOneMonthAhead
    } else {
        return nil
    }
}
