//
//  HFParser.swift
//  HuggingFaceMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// Parses Hugging Face Hub JSON responses into the library's models.
enum HFParser {

    // MARK: - Papers

    static func papers(from data: Data) -> [HFPaper] {
        guard let array = json(data) as? [[String: Any]] else { return [] }
        return array.compactMap { entry in
            // The arXiv paper lives under `paper`; the outer object carries the
            // daily-list metadata (comments, submitter).
            let paper = (entry["paper"] as? [String: Any]) ?? entry
            guard let id = string(paper["id"]) else { return nil }
            return HFPaper(
                id: id,
                title: string(paper["title"]) ?? string(entry["title"]) ?? "",
                summary: string(paper["summary"]) ?? string(entry["summary"]) ?? "",
                authors: (paper["authors"] as? [[String: Any]] ?? []).compactMap { string($0["name"]) },
                upvotes: int(paper["upvotes"]) ?? 0,
                numComments: int(entry["numComments"]),
                publishedAt: date(paper["publishedAt"]) ?? date(entry["publishedAt"]),
                submittedBy: string((entry["submittedBy"] as? [String: Any])?["user"]) ?? string(entry["submittedBy"])
            )
        }
    }

    // MARK: - Models

    static func models(from data: Data) -> [HFModel] {
        guard let array = json(data) as? [[String: Any]] else { return [] }
        return array.compactMap { dict in
            guard let id = string(dict["id"]) ?? string(dict["modelId"]) else { return nil }
            return HFModel(
                id: id,
                author: owner(of: id),
                likes: int(dict["likes"]) ?? 0,
                downloads: int(dict["downloads"]) ?? 0,
                pipelineTag: string(dict["pipeline_tag"]),
                library: string(dict["library_name"]),
                tags: stringArray(dict["tags"]),
                createdAt: date(dict["createdAt"])
            )
        }
    }

    // MARK: - Datasets

    static func datasets(from data: Data) -> [HFDataset] {
        guard let array = json(data) as? [[String: Any]] else { return [] }
        return array.compactMap { dict in
            guard let id = string(dict["id"]) else { return nil }
            return HFDataset(
                id: id,
                author: string(dict["author"]) ?? owner(of: id),
                likes: int(dict["likes"]) ?? 0,
                downloads: int(dict["downloads"]) ?? 0,
                description: string(dict["description"]),
                tags: stringArray(dict["tags"]),
                createdAt: date(dict["createdAt"])
            )
        }
    }

    // MARK: - Value helpers

    private static func json(_ data: Data) -> Any? {
        try? JSONSerialization.jsonObject(with: data)
    }

    private static func string(_ value: Any?) -> String? {
        (value as? String).flatMap { $0.isEmpty ? nil : $0 }
    }

    private static func int(_ value: Any?) -> Int? {
        if let i = value as? Int { return i }
        if let n = value as? NSNumber { return n.intValue }
        if let s = value as? String { return Int(s) }
        return nil
    }

    private static func stringArray(_ value: Any?) -> [String] {
        (value as? [Any])?.compactMap { $0 as? String } ?? []
    }

    /// The `owner` portion of an `owner/name` Hub ID.
    private static func owner(of id: String) -> String? {
        id.contains("/") ? String(id.split(separator: "/").first ?? "") : nil
    }

    /// Hub timestamps are ISO-8601 with fractional seconds and a `Z`.
    private static func date(_ value: Any?) -> Date? {
        guard let s = string(value) else { return nil }
        return isoFractional.date(from: s) ?? isoPlain.date(from: s)
    }

    nonisolated(unsafe) private static let isoFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    nonisolated(unsafe) private static let isoPlain: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()
}
