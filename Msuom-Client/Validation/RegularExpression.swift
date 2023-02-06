//
//  RegularExpression.swift
//
//  Created by MGAbouarab®
//

import Foundation

enum RegularExpression {
    case egyptPhone
    case saudiArabiaPhone
    case password(min: Int = 8, max: Int = 8) //Minimum 8 characters at least 1 Alphabet and 1 Number:
    case email
}

extension RegularExpression {
    var value: String {
        switch self {
        case .egyptPhone:
            return #"^(00201|201|\+201|01)(0|1|2|5)([0-9]{8})$"#
        case .saudiArabiaPhone:
            return #"^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$"#
        case .password(min: let min, max: let max):
            if min >= max{
                return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min),}$"
            }else{
                return "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min),\(max)}$"
            }
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        }
    }
}
