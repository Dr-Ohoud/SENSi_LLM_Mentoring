//
//  NetworkManager.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import Foundation

class NetworkManager {
    
    func sendRequest(_ request: URLRequest) async throws -> Data {
        let ( responseData, _ ) = try await URLSession.shared.data(for: request)
        return responseData
    }
}
