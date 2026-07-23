//
//  HFModel.swift
//  HuggingFaceMetadata
//
//  Created by David Sherlock on 2026.
//

import Foundation

/// A model on the Hugging Face Hub.
public struct HFModel: Sendable, Codable, Identifiable {

    /// The model ID, `owner/name` (e.g. `"baidu/Unlimited-OCR"`).
    public let id: String

    /// The owning org/user (the `owner` portion of ``id``).
    public let author: String?

    /// The number of likes.
    public let likes: Int

    /// The all-time download count.
    public let downloads: Int

    /// The task the model performs (e.g. `"image-text-to-text"`), when tagged.
    public let pipelineTag: String?

    /// The primary library (e.g. `"transformers"`), when known.
    public let library: String?

    /// Free-form tags.
    public let tags: [String]

    /// When the model was first created.
    public let createdAt: Date?

    public init(
        id: String,
        author: String? = nil,
        likes: Int = 0,
        downloads: Int = 0,
        pipelineTag: String? = nil,
        library: String? = nil,
        tags: [String] = [],
        createdAt: Date? = nil
    ) {
        self.id = id
        self.author = author
        self.likes = likes
        self.downloads = downloads
        self.pipelineTag = pipelineTag
        self.library = library
        self.tags = tags
        self.createdAt = createdAt
    }

    /// The model's page on Hugging Face.
    public var url: String { "https://huggingface.co/\(id)" }
}

/// A dataset on the Hugging Face Hub.
public struct HFDataset: Sendable, Codable, Identifiable {

    /// The dataset ID, `owner/name`.
    public let id: String

    /// The owning org/user.
    public let author: String?

    /// The number of likes.
    public let likes: Int

    /// The all-time download count.
    public let downloads: Int

    /// A short description, when provided.
    public let description: String?

    /// Free-form tags.
    public let tags: [String]

    /// When the dataset was first created.
    public let createdAt: Date?

    public init(
        id: String,
        author: String? = nil,
        likes: Int = 0,
        downloads: Int = 0,
        description: String? = nil,
        tags: [String] = [],
        createdAt: Date? = nil
    ) {
        self.id = id
        self.author = author
        self.likes = likes
        self.downloads = downloads
        self.description = description
        self.tags = tags
        self.createdAt = createdAt
    }

    /// The dataset's page on Hugging Face.
    public var url: String { "https://huggingface.co/datasets/\(id)" }
}
