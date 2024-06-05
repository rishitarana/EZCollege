//
//  ValidEmail.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 07/05/24.
//

import Foundation

//Check if email entered by user is belongs to same college entered by user
func isValidEmail(_ email: String, on college: College) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    let boolVal = emailPredicate.evaluate(with: email) && email.contains(college.domain)
    return boolVal
}
