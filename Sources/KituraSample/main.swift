import Kitura
import KituraNet
import KituraSys
import CFEnvironment

let router = Router()

public let config = Configuration()

///
/// Setup routes
///
setupRoutes( router: router)

// router.get("/") {
    // request, response, next in
//     response.status(.OK).send("Hello, World!すぎた")
//     next()
// }

let server = HTTPServer.listen(port: 8090, delegate: router)
Server.run()
