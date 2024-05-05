//
//  String+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/15/24.
//

import Foundation

extension String {
    func checkEmail(str: String) -> Bool {
        let regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        return  NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
    
    func addComma(to numberString: String) -> String {
        let cleanNumberString = numberString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        guard let number = Double(cleanNumberString) else {
            return numberString
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumberString = numberFormatter.string(from: NSNumber(value: number)) ?? ""
        
        let resultString = "\(formattedNumberString) 원"
        
        return resultString
    }
    
    func extractNumbers(from text: String) -> String {
        let textWithoutCommaAndWon = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let decimalCharacters = CharacterSet.decimalDigits
        let numberString = textWithoutCommaAndWon.components(separatedBy: decimalCharacters.inverted).joined()
        return numberString
    }
    
}
