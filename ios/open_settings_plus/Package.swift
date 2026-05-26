// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "open_settings_plus",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "open-settings-plus", targets: ["open_settings_plus"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "open_settings_plus",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
