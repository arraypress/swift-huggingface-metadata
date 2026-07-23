//
//  HFPaper.swift
//  HuggingFaceMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// A paper from Hugging Face's daily curated list.
///
/// Each entry links to an arXiv paper the community up-voted on the given day —
/// a high-signal shortlist of "what mattered in AI today".
public struct HFPaper: Sendable, Codable, Identifiable {

    /// The arXiv identifier (e.g. `"2607.20092"`).
    public let id: String

    /// The paper title.
    public let title: String

    /// The abstract.
    public let summary: String

    /// Author names, in listed order.
    public let authors: [String]

    /// The community up-vote count.
    public let upvotes: Int

    /// The number of comments on the paper's Hugging Face discussion.
    public let numComments: Int?

    /// When the paper was published.
    public let publishedAt: Date?

    /// The Hugging Face user who submitted it to the daily list, when known.
    public let submittedBy: String?

    public init(
        id: String,
        title: String,
        summary: String = "",
        authors: [String] = [],
        upvotes: Int = 0,
        numComments: Int? = nil,
        publishedAt: Date? = nil,
        submittedBy: String? = nil
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.authors = authors
        self.upvotes = upvotes
        self.numComments = numComments
        self.publishedAt = publishedAt
        self.submittedBy = submittedBy
    }

    /// The paper's page on Hugging Face.
    public var pageURL: String { "https://huggingface.co/papers/\(id)" }

    /// The arXiv abstract page.
    public var arxivURL: String { "https://arxiv.org/abs/\(id)" }

    /// The arXiv PDF.
    public var pdfURL: String { "https://arxiv.org/pdf/\(id)" }
}
