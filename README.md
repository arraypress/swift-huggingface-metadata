# Swift Hugging Face Metadata

A dependency-free Swift package for pulling AI signal from the [Hugging Face](https://huggingface.co) Hub — **no API key required**. Surfaces the three highest-signal streams for keeping up with AI: the daily human-curated **top papers**, and the **trending models and datasets**.

## Features

- 📄 **Daily papers** — the human-curated "top AI papers today" list (behind [huggingface.co/papers](https://huggingface.co/papers)), each linked to arXiv
- 🤖 **Trending models** — what's hot on the Hub, by trending score (likes + downloads)
- 📊 **Trending datasets** — the same, for datasets
- 🔎 **Search** — models and datasets by free-text query
- 🤖 **No API key** — uses the Hub's public JSON API
- 📦 **Sendable & Codable** models

## Requirements

- macOS 13.0+ / iOS 16.0+ / tvOS 16.0+ / watchOS 9.0+
- Swift 6.0+

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-huggingface-metadata.git", from: "1.0.0")
]
```

## Usage

```swift
import HuggingFaceMetadata

// Today's curated top AI papers
for paper in try await HuggingFaceMetadata.dailyPapers(limit: 10) {
    print("▲\(paper.upvotes)  \(paper.title)")
    print(paper.authors.joined(separator: ", "))
    print(paper.arxivURL)          // → arxiv.org/abs/…
}

// What's trending on the Hub
let models   = try await HuggingFaceMetadata.trendingModels(limit: 10)
let datasets = try await HuggingFaceMetadata.trendingDatasets(limit: 10)

// Search
let whisper = try await HuggingFaceMetadata.searchModels("whisper")
```

## Models

| Type | Description |
|------|-------------|
| `HFPaper` | `id` (arXiv), `title`, `summary`, `authors`, `upvotes`, `numComments`, `publishedAt`, `submittedBy`, + `arxivURL` / `pdfURL` / `pageURL` |
| `HFModel` | `id`, `author`, `likes`, `downloads`, `pipelineTag`, `library`, `tags`, `createdAt`, + `url` |
| `HFDataset` | `id`, `author`, `likes`, `downloads`, `description`, `tags`, `createdAt`, + `url` |
| `HuggingFaceMetadataError` | Typed errors with `errorDescription` |

## License

MIT License — see LICENSE file for details.

## Author

Created by David Sherlock ([ArrayPress](https://github.com/arraypress)) in 2026.
