import Compute
import Foundation

private let baseURL = "https://aws.connect.psdb.cloud"

public actor PlanetscaleClient {

    private let username: String

    private let password: String

    public private(set) var session: QuerySession?

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    public func refresh() async throws -> QuerySession {
        // Request a new session
        let res = try await fetch("\(baseURL)/psdb.v1alpha1.Database/CreateSession", .options(
            method: .post,
            body: .json([:]),
            headers: [HTTPHeader.authorization.rawValue: basicAuthorizationHeader()]
        ))

        // Decode the session
        let data = try await res.decode(QuerySessionResponse.self)

        // Save the session
        self.session = data.session

        return data.session
    }

    private func basicAuthorizationHeader() -> String {
        let value = Data("\(username):\(password)".utf8).base64EncodedString()
        return "Basic \(value)"
    }
}

extension PlanetscaleClient {
    public struct QuerySession: Codable {
        public struct User: Codable {
            public let username: String
            public let psid: String
            public let role: String
        }

        public struct Session: Codable {
            public struct VitessSession: Codable {
                public struct Options: Codable {
                    public let includedFields: String
                    public let clientFoundRows: Bool
                }

                public let autocommit: Bool
                public let options: Options
                public let DDLStrategy: String
                public let SessionUUID: String
                public let enableSystemSettings: Bool
            }

            public let signature: String
            public let vitessSession: VitessSession
        }

        public let branch: String
        public let user: User
        public let session: Session
    }

    public struct QuerySessionResponse: Codable {
        public let session: QuerySession
    }
}
