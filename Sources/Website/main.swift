import ComputeUI
import PlanetScale

let client = try buildPlanetScaleClient()

try await Router()
    .get("/") { req, _ in
        let limit = req.searchParams["limit", default: "10"]
        let sql = "select * from customers limit \(limit)"
        let rows: [Customer] = try await client.execute(sql).decode()
        return IndexPage(customers: rows)
    }
    .get("/customer/:number") { req, _ in
        let number = req.pathParams["number"]!
        let sql = "select * from customers where customerNumber = \(number)"
        let rows: [Customer] = try await client.execute(sql).decode()
        return CustomerPage(customer: rows[0])
    }
    .use { _, res in
        res.upgradeToHTTP3()
    }
    .listen()

func buildPlanetScaleClient() throws -> PlanetScaleClient {
    let dict = try ConfigStore(name: "env")
    let username = dict["DB_USERNAME"]!
    let password = dict["DB_PASSWORD"]!
    return PlanetScaleClient(username: username, password: password)
}
