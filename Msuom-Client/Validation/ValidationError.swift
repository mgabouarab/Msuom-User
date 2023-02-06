//
//  ValidationError.swift
//
//  Created by MGAbouarab®
//

import Foundation

enum ValidationError: Error {
    //MARK: - Name -
    case emptyFirstName
    case shortFirstName
    case longFirstName
    case emptyLastName
    case shortLastName
    case longLastName
    case emptyFamilyName
    case shortFamilyName
    case longFamilyName
    case emptyFullName
    case shortFullName
    case longFullName
    case emptyName
    case shortName
    case longName

    //MARK: - Phone -
    case emptyPhoneNumber
    case incorrectPhoneNumber
    case incorrectWhatsAppNumber

    //MARK: - Verification Code -
    case emptyVerificationCode
    case incorrectVerificationCode

    //MARK: - Email -
    case emptyMail
    case wrongMail

    //MARK: - Passwords -
    case emptyPassword
    case shortPassword
    case emptyNewPassword
    case shortNewPassword
    case emptyOldPassword
    case shortOldPassword
    case emptyConfirmNewPassword
    case emptyConfirmPassword
    case notMatchPasswords
    case terms

    //MARK: - Locations -
    case emptyCountry
    case emptyGovernorate
    case emptyCity
    case floorNumbers
    case emptyArea
    case emptyStreet
    case addressType
    case emptyLocation
    case estateLocation
    case emptyAddressDetails

    //MARK: - Images -
    case coverPicture
    case profilePicture
    case licensePicture
    case productPicture
    case contractNumber

    //MARK: - carPalet -
    case carPicture
    case carPlate
    case carModel
    case carType

    //MARK: - Date -
    case emptyAge
    case youngAge
    case emptyDate
    case notOldDate
    case notNewDate

    //MARK: - Message -
    case emptyTitle
    case emptyMessage
    case emptyTitleType
    case emptyDetails

    //MARK: - Bank -
    case bankAccountHolder
    case bankName
    case bankTransferImage
    case fromBankName
    case bankAccountNumber

    //MARK: - category -
    case emptyCategory
    case emptyPriceBefore
    case emptyPriceAfter
    case priceBeforeSmallThanPriceAfter
    case emptyDescription
    
}
extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        //MARK: - Name -
        case .emptyFirstName:
            return "Please enter first name.".validationLocalized
        case .shortFirstName:
            return "First name is too short.".validationLocalized
        case .longFirstName:
            return "First name is too long.".validationLocalized
        case .emptyLastName:
            return "Please enter last name.".validationLocalized
        case .shortLastName:
            return "Last name is too short.".validationLocalized
        case .longLastName:
            return "Last name is too long.".validationLocalized
        case .emptyFamilyName:
            return "Please enter family name.".validationLocalized
        case .shortFamilyName:
            return "Family name is too short.".validationLocalized
        case .longFamilyName:
            return "Family name is too long.".validationLocalized
        case .emptyFullName:
            return "Please enter full name.".validationLocalized
        case .shortFullName:
            return "Full name is too short.".validationLocalized
        case .longFullName:
            return "Full name is too long.".validationLocalized
        case .emptyName:
            return "Please enter name.".validationLocalized
        case .shortName:
            return "Name is too short.".validationLocalized
        case .longName:
            return "Name is too long.".validationLocalized
        
        //MARK: - Phone -
        case .emptyPhoneNumber:
            return "Please enter your phone number.".validationLocalized
        case .incorrectPhoneNumber:
            return "Please enter correct phone number.".validationLocalized
        case .incorrectWhatsAppNumber:
            return "Please enter correct whatsApp number.".validationLocalized
        
        //MARK: - Verification Code -
        case .emptyVerificationCode:
            return "Please enter verification code".validationLocalized
        case .incorrectVerificationCode:
            return "Verification Code should be 6 digits.".validationLocalized
        case .estateLocation:
            return "Please enter estate location".validationLocalized
        case .contractNumber:
            return "Please enter contract number".validationLocalized
        //MARK: - Email -
        case .emptyMail:
            return "Please enter email field.".validationLocalized
        case .wrongMail:
            return "Please enter correct email address.".validationLocalized
            
        //MARK: - Passwords -
        case .emptyPassword:
            return "Please enter password field.".validationLocalized
        case .shortPassword:
            return "Password is too short, it should be 6 characters at least.".validationLocalized
        case .emptyNewPassword:
            return "Please enter new password field.".validationLocalized
        case .shortNewPassword:
            return "New password is too short, it should be 6 characters at least.".validationLocalized
        case .emptyOldPassword:
            return "Please enter old password field.".validationLocalized
        case .shortOldPassword:
            return "Old password is too short, it should be 6 characters at least.".validationLocalized
        case .emptyConfirmNewPassword:
            return "Please enter confirm new password field.".validationLocalized
        case .emptyConfirmPassword:
            return "Please enter confirm password field.".validationLocalized
        case .notMatchPasswords:
            return "Passwords not match.".validationLocalized
        case .terms:
            return "Please read and agree our terms and conditions first".validationLocalized

        //MARK: - Locations -
        case .emptyCountry:
            return "Please select country.".validationLocalized
        case .emptyGovernorate:
            return "Please select governorate".validationLocalized
        case .emptyCity:
            return "Please select city.".validationLocalized
        case .floorNumbers:
            return "Please select the floor".validationLocalized
        case .emptyArea:
            return "Please select area.".validationLocalized
        case .emptyStreet:
            return "Please enter street name.".validationLocalized
        case .addressType:
            return "Please enter address type.".validationLocalized
        case .emptyLocation:
            return "Please select the location.".validationLocalized
        case .emptyAddressDetails:
            return "Please write address details".validationLocalized

        //MARK: - Images -
        case .coverPicture:
            return "Please pick cover picture.".validationLocalized
        case .profilePicture:
            return "Please pick your profile picture.".validationLocalized
        case .licensePicture:
            return "Please pick license picture.".validationLocalized
        case .productPicture:
            return "Please pick product image.".validationLocalized

        //MARK: - Cars -
        case .carPicture:
            return "Please pick car picture".validationLocalized
        case .carPlate:
            return "Please enter car palet.".validationLocalized
        case .carModel:
            return "Please select car model.".validationLocalized
        case .carType:
            return "Please Select car type.".validationLocalized

        //MARK: - Date -
        case .emptyAge:
            return "Please enter the age.".validationLocalized
        case .youngAge:
            return "If it is your age, please grow up first =D.".validationLocalized
        case .notOldDate:
            return "Please select older date.".validationLocalized
        case .notNewDate:
            return "Please select newer date.".validationLocalized
        case .emptyDate:
            return "Please select the date.".validationLocalized

        //MARK: - Message -
        case .emptyTitle:
            return "You Must Send Subject Title".validationLocalized
        case .emptyMessage:
            return "Please enter your message".validationLocalized
        case .emptyTitleType:
            return "Please enter title type".validationLocalized
        case .emptyDetails:
            return "Please enter The Details".validationLocalized

        //MARK: - Bank -
        case .bankAccountHolder:
            return "Please enter bank account holder name".validationLocalized
        case .bankName:
            return "Please enter bank name".validationLocalized
        case .bankTransferImage:
            return "Please select bank transfer image".validationLocalized
        case .fromBankName:
            return "Please enter from bank name".validationLocalized
        case .bankAccountNumber:
            return "Please enter bank account number".validationLocalized

        //MARK: - category -
        case .emptyCategory:
            return "Please Select category".validationLocalized
        case .emptyPriceBefore:
            return "Please enter price before".validationLocalized
        case .emptyPriceAfter:
            return "Please enter price after".validationLocalized
        case .priceBeforeSmallThanPriceAfter:
            return "price before is smaller than price after".validationLocalized
        case .emptyDescription:
            return "Please enter description".validationLocalized
            
        }
    }
}
