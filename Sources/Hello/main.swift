import Compute
import Foundation

let router = Router()

router.get("/") { req, res in

    let text  = """
    Hello, Swift.

    The current time is \(DateFormatter().string(from: Date()))

    Your IP Address is \(req.clientIpAddress())
    """

    try await res.upgradeToHTTP3().send(text)
}

try await router.listen()
