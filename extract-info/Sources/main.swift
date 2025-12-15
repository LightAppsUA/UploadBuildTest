import Foundation
import XcodeProj
import PathKit

guard CommandLine.arguments.count == 2 else {
    let arg0 = Path(CommandLine.arguments[0]).lastComponent
    fputs("usage: \(arg0) <project.xcodeproj>\n", stderr)
    exit(1)
}

let projectPath = Path(CommandLine.arguments[1])
let xcodeproj = try XcodeProj(path: projectPath)

// Берём первый application target (обычно основной)
guard let target = xcodeproj.pbxproj.nativeTargets.first(where: { $0.productType == .application }) ??
                   xcodeproj.pbxproj.nativeTargets.first else {
    fputs("❌ No suitable target found\n", stderr)
    exit(1)
}

// Используем первую конфигурацию (обычно Debug или Release)
guard let config = target.buildConfigurationList?.buildConfigurations.first else {
    fputs("❌ No build configuration found\n", stderr)
    exit(1)
}

let settings = config.buildSettings
let bundleID = settings["PRODUCT_BUNDLE_IDENTIFIER"]?.stringValue
let version = settings["MARKETING_VERSION"]?.stringValue

// Формируем JSON
let dict: [String: String?] = [
    "bundle_id": bundleID,
    "version": version
]

let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
if let json = String(data: data, encoding: .utf8) {
    print(json)
}