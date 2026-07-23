//
//  HuggingFaceMetadataError.swift
//  HuggingFaceMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// Errors that can occur when calling the Hugging Face Hub API.
///
/// ```swift
/// do {
///     let papers = try await HuggingFaceMetadata.dailyPapers()
/// } catch HuggingFaceMetadataError.rateLimited {
///     print("Slow down and try again")
/// } catch {
///     print(error.localizedDescription)
/// }
/// ```
public enum HuggingFaceMetadataError: Error, LocalizedError, Equatable, Sendable {

    /// Hugging Face is rate-limiting requests.
    case rateLimited

    /// A network request failed.
    case networkError(String)

    /// Failed to parse the response data.
    case parsingError(String)

    public var errorDescription: String? {
        switch self {
        case .rateLimited:
            return "Hugging Face is rate-limiting requests. Try again later."
        case .networkError(let message):
            return "Network error: \(message)"
        case .parsingError(let message):
            return "Parsing error: \(message)"
        }
    }
}
