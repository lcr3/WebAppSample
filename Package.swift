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
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TopPageFeature",
            dependencies: [
            ]
        )
    ]
)

// MARK: - Test Targets

//package.targets.append(contentsOf: [
//    .testTarget(
//        name: "SeedFeatureTests",
//        dependencies: ["SeedFeature"]
//    ),
//    .testTarget(
//        name: "CreateDairyFeatureTests",
//        dependencies: ["CreateDairyFeature", "Component"]
//    ),
//    .testTarget(
//        name: "DiaryDetailFeatureTests",
//        dependencies: ["DiaryDetailFeature"]
//    ),
//    .testTarget(
//        name: "SettingFeatureTests",
//        dependencies: ["SettingFeature"]
//    ),
//])
