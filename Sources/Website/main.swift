import ComputeUI
import Planetscale

let client = try buildPlanetscaleClient()

try await Router()
    .get("/") { req, _ in
        let sql = "select * from customers limit 10"
        let rows: [Customer] = try await client.execute(sql).decode()
        return IndexPage(customers: rows)
    }
    .get("/customer/:number") { req, _ in
        let number = req.pathParams["number"]!
        let sql = "select * from customers where customerNumber = \(number)"
        let rows: [Customer] = try await client.execute(sql).decode()
        return CustomerPage(customer: rows[0])
    }
    .listen()

func buildPlanetscaleClient() throws -> PlanetscaleClient {
    let dict = try Dictionary(name: "env")
    let username = dict["DB_USERNAME"]!
    let password = dict["DB_PASSWORD"]!
    return PlanetscaleClient(username: username, password: password)
}
