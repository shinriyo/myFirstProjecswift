import Kitura
import KituraNet
import KituraSys
import CFEnvironment

let router = Router()

// Configuration.swift file
public let config = Configuration()

///
/// Setup routes
///
setupRoutes(router: router)

let server = HTTPServer.listen(port: 8090, delegate: router)
Server.run()
