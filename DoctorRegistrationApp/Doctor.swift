import Foundation

struct DoctorResponse: Codable {
    let d: DoctorResults
}

struct DoctorResults: Codable {
    let results: [Doctor]
}

struct Doctor: Codable {

    let name: String
    let nameUpper: String
    let phoneNo: String
    let whatsappNo: String
    let countryCode: String
    let email: String
    let gender: String
    let age: String
    let ageUnit: String
    let practiceFrom: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case nameUpper = "NameUpper"
        case phoneNo = "PhoneNo"
        case whatsappNo = "WhatsappNo"
        case countryCode = "CountryCode"
        case email = "Email"
        case gender = "Gender"
        case age = "Age"
        case ageUnit = "AgeUnit"
        case practiceFrom = "PracticeFrom"
    }
}
