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
    var fullName: String
    var email: String
    var bio: String
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components) }
        return "" }
    var milestones: [Milestone]?
    var eduactionLevel: eduactionLevelEnums
    var experienceLevel: experienceLevelEnums
    var careerGoal: String
}
// MARK: - MOCK User

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString,
                                fullName: "Shahad Abdullah",
                                email: "Shahad@gmail.com",
                                bio: "Aspiring Software Engineer | AI Enthusiast | Swiftui developer",
                                eduactionLevel: .masterDegree,
                                experienceLevel: .earlyCareer,
                                careerGoal: "Machine Learning Engineer"
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
