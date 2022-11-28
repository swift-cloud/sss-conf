import Compute
import TokamakStaticHTML

extension Router {

    typealias ViewHandler<T: View> = (IncomingRequest, OutgoingResponse) async throws -> T

    @discardableResult
    func get<T: View>(_ path: String, _ handler: @autoclosure @escaping () -> T) -> Self {
        return get(path) { _, _ in
            handler()
        }
    }

    @discardableResult
    func get<T: View>(_ path: String, _ handler: @escaping ViewHandler<T>) -> Self {
        return get(path) { req, res in
            let view = try await handler(req, res)
            let html = StaticHTMLRenderer(view).render()
            try await res.status(.ok).send(html: html)
        }
    }
}
