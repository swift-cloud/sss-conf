import Compute
import PlanetScale

let client = try buildPlanetScaleClient()

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
    let session = try await client.refresh()
    try await res.status(.ok).send(session)
}

router.get("/token") { req, res in
    let jwt = try JWT(claims: ["user_id": UUID().uuidString], secret: UUID().uuidString)
    try await res.status(200).send(["token": jwt.token])
}

func buildPlanetScaleClient() throws -> PlanetScaleClient {
    let dict = try ConfigStore(name: "env")
    let username = dict["DB_USERNAME"]!
    let password = dict["DB_PASSWORD"]!
    return PlanetScaleClient(username: username, password: password)
}

try await router.listen()
