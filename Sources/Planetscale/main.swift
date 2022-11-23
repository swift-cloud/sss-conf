import Compute
import Foundation

let router = Router()

router.get("/execute") { req, res in
    let sql = req.searchParams["sql"] ?? ""
    let client = try buildPlanetscaleClient()
    let data = try await client.execute(sql: sql)
    try await res
        .cors()
        .upgradeToHTTP3()
        .status(.ok)
        .send(data)
}

router.get("/session") { req, res in
    let client = try buildPlanetscaleClient()
    let session = try await client.refresh()
    try await res
        .cors()
        .upgradeToHTTP3()
        .status(.ok)
        .send(session)
}

func buildPlanetscaleClient() throws -> PlanetscaleClient {
    let dict = try Dictionary(name: "env")
    return PlanetscaleClient(
        username: dict["DB_USERNAME"]!,
        password: dict["DB_PASSWORD"]!
    )
}

try await router.listen()