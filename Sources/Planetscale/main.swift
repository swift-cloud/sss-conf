import Compute
import Foundation

let router = Router()

router.use { _, res in
    res.cors().upgradeToHTTP3()
}

router.get("/") { req, res in
    try await res.status(.ok).send("Hello, Swift")
}

router.get("/execute") { req, res in
    let sql = req.searchParams["sql"] ?? ""
    let ttl = req.searchParams["ttl"]
    let client = try buildPlanetscaleClient()
    let data = try await client.query(sql, cachePolicy: ttl == nil ? nil : .ttl(Int(ttl!)!))
    try await res.status(.ok).send(data.json())
}

router.get("/session") { req, res in
    let client = try buildPlanetscaleClient()
    let session = try await client.refresh()
    try await res.status(.ok).send(session)
}

func buildPlanetscaleClient() throws -> PlanetscaleClient {
    let dict = try Dictionary(name: "env")
    return PlanetscaleClient(
        username: dict["DB_USERNAME"]!,
        password: dict["DB_PASSWORD"]!
    )
}

try await router.listen()
