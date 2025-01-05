// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "PasswordChecker",
    products: [
        .library(name: "PasswordChecker", targets: ["PasswordChecker"]),
    ],
    targets: [
        .target(
            name: "PasswordChecker",
            resources: [
                .process("zxcvbn"),
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
