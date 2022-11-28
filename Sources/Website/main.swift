import ComputeUI

let router = Router()

router.get("/", IndexPage())

router.get("/about", AboutPage())

try await router.listen()
