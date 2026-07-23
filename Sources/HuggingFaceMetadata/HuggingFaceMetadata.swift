//
//  HuggingFaceMetadata.swift
//  HuggingFaceMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Fetch AI signal from the [Hugging Face](https://huggingface.co) Hub without
/// authentication.
///
/// Surfaces the three highest-signal streams for keeping up with AI: the daily
/// human-curated **top papers**, and the **trending models and datasets**. Uses
/// the Hub's public JSON API — no API key required.
///
/// ## Quick Start
///
/// ```swift
/// import HuggingFaceMetadata
///
/// // Today's curated top AI papers
/// for paper in try await HuggingFaceMetadata.dailyPapers(limit: 10) {
///     print("▲\(paper.upvotes)  \(paper.title)")
///     print(paper.arxivURL)
/// }
///
/// // What's trending
/// let models = try await HuggingFaceMetadata.trendingModels(limit: 10)
/// let datasets = try await HuggingFaceMetadata.trendingDatasets(limit: 10)
/// ```
public enum HuggingFaceMetadata {

    private static let base = "https://huggingface.co/api"

    private static let userAgent = "HuggingFaceMetadata/1.0 (Swift; +https://github.com/arraypress)"

    // MARK: - Papers

    /// Returns the daily human-curated "top papers" list (the feed behind
    /// [huggingface.co/papers](https://huggingface.co/papers)).
    ///
    /// - Parameter limit: Maximum papers to return (default 20).
    public static func dailyPapers(limit: Int = 20) async throws -> [HFPaper] {
        let data = try await get("/daily_papers", query: ["limit": String(limit)])
        return HFParser.papers(from: data)
    }

    // MARK: - Models

    /// Returns the trending models on the Hub, most trending first.
    public static func trendingModels(limit: Int = 20) async throws -> [HFModel] {
        let data = try await get("/models", query: ["sort": "trendingScore", "direction": "-1", "limit": String(limit)])
        return HFParser.models(from: data)
    }

    /// Searches models by free-text query, most downloaded first.
    public static func searchModels(_ query: String, limit: Int = 20) async throws -> [HFModel] {
        let data = try await get("/models", query: ["search": query, "sort": "downloads", "direction": "-1", "limit": String(limit)])
        return HFParser.models(from: data)
    }

    // MARK: - Datasets

    /// Returns the trending datasets on the Hub, most trending first.
    public static func trendingDatasets(limit: Int = 20) async throws -> [HFDataset] {
        let data = try await get("/datasets", query: ["sort": "trendingScore", "direction": "-1", "limit": String(limit)])
        return HFParser.datasets(from: data)
    }

    /// Searches datasets by free-text query, most downloaded first.
    public static func searchDatasets(_ query: String, limit: Int = 20) async throws -> [HFDataset] {
        let data = try await get("/datasets", query: ["search": query, "sort": "downloads", "direction": "-1", "limit": String(limit)])
        return HFParser.datasets(from: data)
    }

    // MARK: - Networking

    private static func get(_ path: String, query: [String: String]) async throws -> Data {
        var components = URLComponents(string: base + path)
        components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else {
            throw HuggingFaceMetadataError.networkError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw HuggingFaceMetadataError.networkError(error.localizedDescription)
        }

        if let http = response as? HTTPURLResponse {
            if http.statusCode == 429 { throw HuggingFaceMetadataError.rateLimited }
            if http.statusCode != 200 { throw HuggingFaceMetadataError.networkError("HTTP \(http.statusCode)") }
        }
        return data
    }
}
