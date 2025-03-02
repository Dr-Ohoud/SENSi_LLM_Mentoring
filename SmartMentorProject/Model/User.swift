//
//  User.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import Foundation

struct User: Identifiable, Codable {
    
    // MARK: - General Information
    let id: String
    let fullName: String
    let email: String
    let bio: String
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    
    // MARK: - User Background Section
    let eduactionLevel: eduactionLevelEnums
    let skills: [String]
    let experienceLevel: experienceLevelEnums
    
    // MARK: - Career Aspirations Section
    let careerGoal: String
    let interests: String
    let skillGap: [String]

}

struct UserData: Identifiable, Codable {
    
    var id: String = NSUUID().uuidString
    var fullName: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var educationLevel: String = ""
    var skills: [String] = []
    var experienceLevel: String = ""
    var careerGoal: String = ""
    var interests: String = ""
    var skillGap: [String] = []
    var bio: String = ""

    var currentInput: String = "" // Temporarily holds user input before saving
}
// MARK: - MOCK User

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString,
                                fullName: "Shahad Abdullah",
                                email: "Shahad@gmail.com",
                                bio: "Aspiring Software Engineer | AI Enthusiast | Swiftui developer",
                                eduactionLevel: .masterDegree,
                                skills: ["Swift Language", "Basic Coding"],
                                experienceLevel: .freshGraduateStudent,
                                careerGoal: "Machine Learning Engineer",
                                interests: "AI Ethics",
                                skillGap: ["Python Language", "TensorFlow Framework"]
    )
}

// MARK: - Enums
enum eduactionLevelEnums: String, CaseIterable, Identifiable, Codable{
    case highSchool
    case BachelorDegree
    case masterDegree
    case doctorDegree
    
    var id: String { self.rawValue }
}

enum experienceLevelEnums: String, CaseIterable, Identifiable, Codable {
    case stillStudent
    case freshGraduateStudent
    case earlyCareer
    
    var id: String { self.rawValue }
}
