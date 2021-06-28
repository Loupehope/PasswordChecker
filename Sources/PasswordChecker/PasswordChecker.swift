import JavaScriptCore

public enum PasswordCheckerError: Error {
    case unableToCreateJSContext
    case unableToGetScript
    case unableToParseResult
}

// For more, available properties - https://github.com/dropbox/zxcvbn#usage

public struct PasswordInfo {
    public init(guessesLog10: Double, crackTimesDisplay: String, score: Int32, calcTime: Int32) {
        self.guessesLog10 = guessesLog10
        self.crackTimesDisplay = crackTimesDisplay
        self.score = score
        self.calcTime = calcTime
    }

    public let guessesLog10: Double
    public let crackTimesDisplay: String
    public let score: Int32
    public let calcTime: Int32

    public static let zero = PasswordInfo(guessesLog10: 0, crackTimesDisplay: "", score: 0, calcTime: 0)
}

public class PasswordChecker {

    private let jsContext: JSContext

    public init() throws {
        guard let jsContext = JSContext() else {
            throw PasswordCheckerError.unableToCreateJSContext
        }

        guard let passwordCheckerPath = Bundle.module.path(forResource: JSScript.scriptName, ofType: JSScript.scriptType),
              let passwordCheckerJS = try? String(contentsOfFile: passwordCheckerPath, encoding: String.Encoding.utf8) else {

            throw PasswordCheckerError.unableToGetScript
        }

        jsContext.exceptionHandler = { _, exception in
            assertionFailure(exception?.toString() ?? JSScript.unknownError)
        }

        jsContext.evaluateScript(passwordCheckerJS)

        self.jsContext = jsContext
    }

    public func getPasswordScore(_ password: String, userInputs: [String] = []) -> Result<PasswordInfo, PasswordCheckerError> {

        let result = jsContext.objectForKeyedSubscript(JSScript.scriptName)?
            .call(withArguments: [password, userInputs])

        guard let guesses_log10 = result?.objectForKeyedSubscript(JSKey.guesses_log10.rawValue)?.toDouble() else {
            return .failure(PasswordCheckerError.unableToParseResult)
        }

        guard let crack_times_display = result?.objectForKeyedSubscript(JSKey.crack_times_display.rawValue)?.toString() else {
            return .failure(PasswordCheckerError.unableToParseResult)
        }

        guard let score = result?.objectForKeyedSubscript(JSKey.score.rawValue)?.toInt32() else {
            return .failure(PasswordCheckerError.unableToParseResult)
        }

        guard let calc_time = result?.objectForKeyedSubscript(JSKey.calc_time.rawValue)?.toInt32() else {
            return .failure(PasswordCheckerError.unableToParseResult)
        }

        let passwordInfo = PasswordInfo(guessesLog10: guesses_log10, crackTimesDisplay: crack_times_display, score: score, calcTime: calc_time)

        return .success(passwordInfo)
    }
}

private extension PasswordChecker {

    enum JSKey: String, RawRepresentable {
        case guesses_log10, crack_times_display, score, calc_time
    }

    enum JSScript {
        static let scriptName = "zxcvbn"
        static let scriptType = "js"
        static let unknownError = "Unknown JSError"
    }
}
