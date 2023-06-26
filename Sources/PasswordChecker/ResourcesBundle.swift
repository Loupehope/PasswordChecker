import class Foundation.Bundle
import struct Foundation.URL

private class BundleFinder {}

extension Foundation.Bundle {
    /// Returns the resource bundle associated with the resources.
    static let resources: Bundle? = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        let bundleName = "PasswordCheckerResources"
        let candidate = Bundle(for: BundleFinder.self).resourceURL
        let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")

        if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
            return bundle
        }

        assertionFailure("unable to find bundle named PasswordCheckerResources")
        return nil
        #endif
    }()
}
