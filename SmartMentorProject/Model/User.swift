//
//  User.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import Foundation

struct User: Identifiable, Codable {
    
    init() {
        self.id = NSUUID().uuidString
        self.fullName = ""
        self.email = ""
        self.bio = ""
        self.eduactionLevel = .highSchool
        self.skills = [""]
        self.experienceLevel = .stillStudent
        self.careerGoal = ""
        self.interests = ""
        self.skillGap = [""]
        self.currentInput = ""
    }
    
    init(id: String, fullName: String, email: String, bio: String, eduactionLevel: eduactionLevelEnums, skills: [String], experienceLevel: experienceLevelEnums, careerGoal: String, interests: String, skillGap: [String]) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.bio = bio
        self.eduactionLevel = eduactionLevel
        self.skills = skills
        self.experienceLevel = experienceLevel
        self.careerGoal = careerGoal
        self.interests = interests
        self.skillGap = skillGap
        self.currentInput = ""
    }
    
    // MARK: - General Information
    let id: String
    var fullName: String
    var email: String
    var bio: String
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    
    // MARK: - User Background Section
    var eduactionLevel: eduactionLevelEnums
    var skills: [String]
    var experienceLevel: experienceLevelEnums
    
    // MARK: - Career Aspirations Section
    var careerGoal: String
    var interests: String
    var skillGap: [String]
    
    var currentInput: String = "" // Temporarily holds user input before saving
    
    
}

//struct UserData: Identifiable, Codable {
//
//    var id: String = NSUUID().uuidString
//    var fullName: String = ""
//    var email: String = ""
//    var password: String = ""
//    var confirmPassword: String = ""
//    var educationLevel: String = ""
//    var skills: [String] = []
//    var experienceLevel: String = ""
//    var careerGoal: String = ""
//    var interests: String = ""
//    var skillGap: [String] = []
//    var bio: String = ""
//
//    var currentInput: String = "" // Temporarily holds user input before saving
//}
// MARK: - MOCK User

extension User {
    static var MOCK_USER = User(
        id: NSUUID().uuidString,
        fullName: "Shahad Abdullah",
        email: "Shahad@gmail.com",
        bio: "Aspiring Software Engineer | AI Enthusiast | Swiftui developer",
        eduactionLevel: .highSchool,
        skills: ["Swift Language", "Basic Coding"],
        experienceLevel: .freshGraduateStudent,
        careerGoal: "Machine Learning Engineer",
        interests: "AI Ethics",
        skillGap: ["Python Language", "TensorFlow Framework"]
    )
}

// MARK: - Enums
enum eduactionLevelEnums: String, CaseIterable, Identifiable, Codable, CustomStringConvertible{
    case highSchool = "High School"
    case BachelorDegree = "Bachelor Degree"
    case masterDegree = "Master Degree"
    case doctorDegree = "PhD Degree"
    
    var id: String { self.rawValue }
    
    var description: String {
        return self.rawValue
    }
}

enum experienceLevelEnums: String, CaseIterable, Identifiable, Codable, CustomStringConvertible {
    case stillStudent = "Still Student"
    case freshGraduateStudent = "Fresh Graduate Student"
    case earlyCareer = "Early Career"
    
    var id: String { self.rawValue }
    
    var description: String {
        return self.rawValue
    }
}
