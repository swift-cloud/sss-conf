import Compute
import Foundation

let router = Router()

router.get("/") { req, res in
    let dict = try Dictionary(name: "env")

    try await res
        .cors()
        .upgradeToHTTP3()
        .status(.ok)
        .send("Hello, Swift")
}

try await router.listen()
