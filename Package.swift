// swift-tools-version:5.5.0
import PackageDescription

var package = Package(
    name: "WebAppSamplePackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "TopPageFeature",
            targets: [
                "TopPageFeature",
            ]
        ),
        .library(
            name: "WebViewKit",
            targets: [
                "WebViewKit",
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/kylehickinson/SwiftUI-WebView.git",
            .exact("0.3.0")
        )
    ],
    targets: [
        .target(
            name: "TopPageFeature",
            dependencies: [
//                .target(name: "WebViewKit"),
                .product(name: "WebView", package: "SwiftUI-WebView"),
            ]
        ),
        .target(
            name: "WebViewKit",
            dependencies: [
            ]
        ),
    ]
)

// MARK: - Test Targets

package.targets.append(
    contentsOf: [
        .testTarget(
            name: "TopPageFeatureTests",
            dependencies: ["TopPageFeature"]
        ),
        .testTarget(
            name: "WebViewKitTests",
            dependencies: ["WebViewKit"]
        )
    ]
)
