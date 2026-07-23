//
//  HuggingFaceMetadataTests.swift
//  HuggingFaceMetadata
//
//  Created by David Sherlock on 2026.
//

import XCTest
@testable import HuggingFaceMetadata

final class HuggingFaceMetadataTests: XCTestCase {

    func testParsePapers() {
        let json = """
        [{
          "paper": {"id":"2607.20092","title":"A Taxonomic Probe","summary":"We study X.",
            "authors":[{"name":"Karan Goyal"},{"name":"Afreen Hossain"}],
            "upvotes":42,"publishedAt":"2026-07-22T00:00:00.000Z"},
          "numComments":3,"publishedAt":"2026-07-21T20:00:00.000Z",
          "submittedBy":{"user":"someone"}
        }]
        """
        let papers = HFParser.papers(from: Data(json.utf8))
        XCTAssertEqual(papers.count, 1)
        let p = papers[0]
        XCTAssertEqual(p.id, "2607.20092")
        XCTAssertEqual(p.title, "A Taxonomic Probe")
        XCTAssertEqual(p.authors, ["Karan Goyal", "Afreen Hossain"])
        XCTAssertEqual(p.upvotes, 42)
        XCTAssertEqual(p.numComments, 3)
        XCTAssertNotNil(p.publishedAt)
        XCTAssertEqual(p.arxivURL, "https://arxiv.org/abs/2607.20092")
        XCTAssertEqual(p.pageURL, "https://huggingface.co/papers/2607.20092")
    }

    func testParseModels() {
        let json = """
        [{"_id":"x","id":"baidu/Unlimited-OCR","modelId":"baidu/Unlimited-OCR","likes":2855,
          "downloads":2414259,"tags":["ocr","vision"],"pipeline_tag":"image-text-to-text",
          "library_name":"transformers","createdAt":"2026-07-01T10:00:00.000Z"}]
        """
        let models = HFParser.models(from: Data(json.utf8))
        let m = models[0]
        XCTAssertEqual(m.id, "baidu/Unlimited-OCR")
        XCTAssertEqual(m.author, "baidu")
        XCTAssertEqual(m.likes, 2855)
        XCTAssertEqual(m.downloads, 2414259)
        XCTAssertEqual(m.pipelineTag, "image-text-to-text")
        XCTAssertEqual(m.library, "transformers")
        XCTAssertEqual(m.tags, ["ocr", "vision"])
        XCTAssertEqual(m.url, "https://huggingface.co/baidu/Unlimited-OCR")
        XCTAssertNotNil(m.createdAt)
    }

    func testParseDatasets() {
        let json = """
        [{"id":"openbmb/UltraX-Preview","author":"openbmb","likes":260,"downloads":5591,
          "description":"A preview dataset.","tags":["text"],"createdAt":"2026-07-01T10:00:00.000Z"}]
        """
        let ds = HFParser.datasets(from: Data(json.utf8))
        let d = ds[0]
        XCTAssertEqual(d.id, "openbmb/UltraX-Preview")
        XCTAssertEqual(d.author, "openbmb")
        XCTAssertEqual(d.likes, 260)
        XCTAssertEqual(d.url, "https://huggingface.co/datasets/openbmb/UltraX-Preview")
    }

    func testEmptyAndGarbage() {
        XCTAssertTrue(HFParser.papers(from: Data("[]".utf8)).isEmpty)
        XCTAssertTrue(HFParser.models(from: Data("{}".utf8)).isEmpty)
        XCTAssertTrue(HFParser.datasets(from: Data("not json".utf8)).isEmpty)
    }
}
