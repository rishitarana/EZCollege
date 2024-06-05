//
//  Mailverifier.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 10/05/24.
//

import Foundation

/// class for generating a opt function
class OTP
{
    var otp: String = ""
    init(otp: String) {
        self.otp = otp
    }
}

let otpClass = OTP(otp: "")

//Generate and return a 6 digit OTP
func generateOTP()->String
{
    let min = 100000
    let max = 999999
    let randomNum = Int(arc4random_uniform(UInt32(max - min + 1))) + min
    return String(randomNum)
}


/// function to send the email to a registered user
///
/// - Parameter recipient: the email of the recipient
/// - Parameter otp: the generated otp for the user
func sendEmail(recipient: String, otp: String) {
    guard let encodedRecipient = recipient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let encodedOTP = otp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return
    }
    
    let url = URL(string: "http://3.84.67.115/mail?recipient=\(encodedRecipient)&otp=\(encodedOTP)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        // Handle response if needed
        if let data = data {
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Response: \(responseJSON)")
            } else {
                let responseString = String(data: data, encoding: .utf8)
                print("Response: \(responseString ?? "")")
            }
        }
    }
    task.resume()
}
