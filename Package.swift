// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "UIView-WZB",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "UIViewWZB",
            targets: ["UIViewWZB"]
        )
    ],
    targets: [
        .target(
            name: "UIViewWZB",
            path: "Source/Swift/UIView+WZB"
        )
    ]
)
