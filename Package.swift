// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "LCD1602",
    products: [
        .library(name: "LCD1602", targets: ["LCD1602"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tib/SwiftIO", .branch("master")),
    ],
    targets: [
        .target(name: "LCD1602", dependencies: [
            .product(name: "SwiftIO", package: "SwiftIO"),
        ]),
        .testTarget(name: "LCD1602Tests", dependencies: [
            .target(name: "LCD1602"),
        ]),
    ]
)
