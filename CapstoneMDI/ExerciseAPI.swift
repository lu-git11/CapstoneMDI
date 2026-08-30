//
//  ExerciseAPI.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/18/26.
//

import Foundation
 
enum ExerciseAPIError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int, body: String)
    case decodingFailed(String)

    var errorDescription: String? {
         switch self {
         case .invalidURL:
             return "Invalid URL"
         case .requestFailed(let statusCode, let body):
             return "Server returned \(statusCode): \(body.prefix(200))"
         case .decodingFailed(let details):
             return "Couldn't parse response: \(details)"
         }
     }
}
 
struct ExerciseAPIService {
    
    // wger's public exercise database - free, no API key required.
    // https://wger.de/api/v2/
    //
    // Note: wger doesn't have a stable, documented "search by name" endpoint.
    // /exerciseinfo/ is the officially listed endpoint with full exercise data
    // (including name translations), so we fetch a batch and filter locally.
    static func searchExercises(term: String) async throws -> [ExerciseInfo] {
        let trimmed = term.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return [] }
        
        var components = URLComponents(string: "https://wger.de/api/v2/exerciseinfo/")
        components?.queryItems = [
            URLQueryItem(name: "limit", value: "200"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = components?.url else {
            throw ExerciseAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ExerciseAPIError.requestFailed(statusCode: -1, body: "No HTTP response")
        }
        
        guard httpResponse.statusCode == 200 else {
            let body = String(data: data, encoding: .utf8) ?? "<no body>"
            throw ExerciseAPIError.requestFailed(statusCode: httpResponse.statusCode, body: body)
        }
        
        do {
            let decoded = try JSONDecoder().decode(ExerciseInfoListResponse.self, from: data)
            let lowercasedTerm = trimmed.lowercased()
            return decoded.results.filter {
                $0.displayName.lowercased().contains(lowercasedTerm)
            }
        } catch {
            throw ExerciseAPIError.decodingFailed(error.localizedDescription)
        }
    }
}
