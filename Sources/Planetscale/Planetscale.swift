import Compute
import Foundation

private let baseURL = "https://aws.connect.psdb.cloud/psdb.v1alpha1.Database"

public actor PlanetscaleClient {

    private let username: String

    private let password: String

    public private(set) var session: QuerySession?

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    public func execute(query: String) async throws -> ExecuteResponse {
        // Request a new session
        let res = try await fetch("\(baseURL)/Execute", .options(
            method: .post,
            body: .json(ExecuteRequest(query: query, session: session)),
            headers: [
                HTTPHeader.authorization.rawValue: basicAuthorizationHeader(),
                HTTPHeader.contentType.rawValue: "application/json"
            ]
        ))

        // Decode the session
        let response = try await res.decode(ExecuteResponse.self)

        // Save the session
        self.session = response.session

        // Check for an error
        if let error = response.error {
            throw error
        }

        return response
    }

    public func refresh() async throws -> QuerySession {
        // Request a new session
        let res = try await fetch("\(baseURL)/CreateSession", .options(
            method: .post,
            body: .text("{}"),
            headers: [
                HTTPHeader.authorization.rawValue: basicAuthorizationHeader(),
                HTTPHeader.contentType.rawValue: "application/json"
            ]
        ))

        // Decode the session
        let session = try await res.decode(QuerySession.self)

        // Save the session
        self.session = session

        return session
    }

    private func basicAuthorizationHeader() -> String {
        let value = Data("\(username):\(password)".utf8).base64EncodedString()
        return "Basic \(value)"
    }
}

extension PlanetscaleClient {
    public struct ExecuteResponse: Codable {
        public let session: QuerySession
        public let error: VitessError?
    }

    public struct ExecuteRequest: Codable {
        public let query: String
        public let session: QuerySession?
    }
}

extension PlanetscaleClient {
    public struct VitessError: Codable, Error {
        public let message: String
        public let code: String
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
}
