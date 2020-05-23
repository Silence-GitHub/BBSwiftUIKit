// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BBSwiftUIKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "BBSwiftUIKit", targets: ["BBSwiftUIKit"]),
    ],
    targets: [
        .target(
            name: "BBSwiftUIKit",
            path: "BBSwiftUIKit/BBSwiftUIKit"
        )
    ]
)
