import Compute
import Foundation
import Planetscale

let client = try buildPlanetscaleClient()

let router = Router()

router.use { _, res in
    res.cors().upgradeToHTTP3()
}

router.get("/") { req, res in
    try await res.status(.ok).send("Hello, Swift")
}

router.get("/execute") { req, res in
    let sql = req.searchParams["sql"] ?? ""
    let ttl = req.searchParams["ttl"].flatMap(Int.init) ?? 0
    let data = try await client.execute(sql, cachePolicy: ttl > 0 ? .ttl(ttl) : .origin)
    try await res.status(.ok).send(data.json())
}

router.get("/session") { req, res in
    let client = try buildPlanetscaleClient()
    let session = try await client.refresh()
    try await res.status(.ok).send(session)
}

router.get("/token") { req, res in
    let jwt = try JWT(claims: ["user_id": UUID().uuidString], secret: UUID().uuidString)
    try await res.status(200).send(["token": jwt.token])
}

func buildPlanetscaleClient() throws -> PlanetscaleClient {
    let dict = try Dictionary(name: "env")
    let username = dict["DB_USERNAME"]!
    let password = dict["DB_PASSWORD"]!
    return PlanetscaleClient(username: username, password: password)
}

try await router.listen()
