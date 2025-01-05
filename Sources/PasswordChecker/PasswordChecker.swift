import JavaScriptCore

public enum PasswordCheckerError: Error {
    case unableToCreateJSContext
    case unableToGetScript
    case unableToParseResult
}

// For more, available properties - https://github.com/dropbox/zxcvbn#usage

public struct PasswordInfo: Sendable, Decodable {
    public let guesses: Int32
    public let guessesLog10: Double
    public let crackTimesSeconds: [String: Double]
    public let crackTimesDisplay: [String: String]
    public let score: Int32
    public let calcTime: Int32

    public init(
        guesses: Int32 = 0,
        guessesLog10: Double = 0.0,
        crackTimesSeconds: [String: Double] = [:],
        crackTimesDisplay: [String: String] = [:],
        score: Int32 = 0,
        calcTime: Int32 = 0
    ) {
        self.guesses = guesses
        self.guessesLog10 = guessesLog10
        self.crackTimesSeconds = crackTimesSeconds
        self.crackTimesDisplay = crackTimesDisplay
        self.score = score
        self.calcTime = calcTime
    }
    
    public static let empty = PasswordInfo()
    
    enum CodingKeys: String, CodingKey {
        case guesses = "guesses"
        case guessesLog10 = "guesses_log10"
        case crackTimesSeconds = "crack_times_seconds"
        case crackTimesDisplay = "crack_times_display"
        case score
        case calcTime = "calc_time"
    }
}

public final class PasswordChecker {
    private let jsContext: JSContext

    public init() throws {
        guard let jsContext = JSContext() else {
            throw PasswordCheckerError.unableToCreateJSContext
        }

        guard let passwordCheckerPath = Bundle.resources?.path(forResource: JSScript.scriptName, ofType: JSScript.scriptType),
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
        guard let script = jsContext.objectForKeyedSubscript(JSScript.scriptName),
              let result = script.call(withArguments: [password, userInputs]).toDictionary() else {
            return .failure(.unableToParseResult)
        }
        
        if let dataResult = try? JSONSerialization.data(withJSONObject: result),
           let parsedResult = try? JSONDecoder().decode(PasswordInfo.self, from: dataResult) {
            return .success(parsedResult)
        } else {
            return .failure(.unableToParseResult)
        }
    }
}

private extension PasswordChecker {
    enum JSScript {
        static let scriptName = "zxcvbn"
        static let scriptType = "js"
        static let unknownError = "Unknown JSError"
    }
}
