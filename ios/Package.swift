// swift-tools-version: 5.9
//
// Package.swift — LuxApp SPM dependency manifest
//
// This file declares third-party Swift packages used by LuxApp.
// When opening in Xcode, add these packages via File > Add Package Dependencies
// using the URLs and version constraints listed here.
//
// WhisperKit: on-device speech-to-text via Core ML / Apple Neural Engine
//   https://github.com/argmaxinc/WhisperKit
//   Minimum: 0.9.0  (first release with the async transcribe(audioArray:) API)

import PackageDescription

let package = Package(
    name: "LuxApp",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "LuxApp", targets: ["LuxApp"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/argmaxinc/WhisperKit",
            from: "0.9.0"
        ),
    ],
    targets: [
        .target(
            name: "LuxApp",
            dependencies: [
                .product(name: "WhisperKit", package: "WhisperKit"),
            ],
            path: "LuxApp"
        ),
    ]
)
