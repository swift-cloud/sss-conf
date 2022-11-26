import Compute
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
    let data = try await client.execute(sql)
    try await res.status(.ok).send(data.json())
}

router.get("/session") { req, res in
    let client = try buildPlanetscaleClient()
    let session = try await client.refresh()
    try await res.status(.ok).send(session)
}

func buildPlanetscaleClient() throws -> PlanetscaleClient {
    let dict = try Dictionary(name: "env")
    let username = dict["DB_USERNAME"]!
    let password = dict["DB_PASSWORD"]!
    return PlanetscaleClient(username: username, password: password)
}

try await router.listen()
