/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Kitura
import KituraNet

import LoggerAPI
import SwiftyJSON
// import Mustache
import KituraMustache
import Foundation // NSFileManager

/**
 Custom middleware that allows Cross Origin HTTP requests
 This will allow wwww.todobackend.com to communicate with your server
*/
class AllRemoteOriginMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: () -> Void) {

        // response.setHeader("Access-Control-Allow-Origin", value: "*")
        response.headers["Access-Control-Allow-Origin"] = "*"

        next()
    }
}

/**
 Sets up all the routes for the Todo List application
*/
// func setupRoutes(router: Router, todos: TodoCollection) {
func setupRoutes(router: Router) {

    router.all("/*", middleware: BodyParser())

    router.all("/*", middleware: AllRemoteOriginMiddleware())

    // Webアプリのカレントディレクトリを取得します
    // サンプルコードの場合、basePathは $HOME/MyApp
    // let basePath = NSFileManager.defaultManager().currentDirectoryPath
    // let basePath = TemplateRepository(bundle: NSBundle.mainBundle())

    // テンプレートファイルが配置されているディレクトリのパスを指定する
    // let repository = TemplateRepository(directoryPath: basePath + "/Statics")

    /**
        Get all the todos
    */
    router.setDefaultTemplateEngine(templateEngine: MustacheTemplateEngine())
    router.get("/") {
        request, response, next in

        defer {
            next()
        }
        do {
            // the example from https://github.com/groue/GRMustache.swift/blob/master/README.md
            var context: [String: Any] = [
                "title" : "KItura",
                "content": [
                    "header": "Web application framework Kitura",
                    "text": "Build end-to-end apps using Swift with Kitura",
                ]
            ]

            // Let template format dates with `{{format(...)}}`
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .mediumStyle
            context["format"] = dateFormatter
            // Views folder "layout.mustache"
            try response.status(.OK).render("layout", context: context).end()
            // directory
            // response.status(.OK).send("shinriyo, World!")
        } catch {
            Log.error("Failed to render template \(error)")
        }
    }

    /**
     Get information about a todo item by ID
     */
    router.get(config.firstPathSegment + "/:id") {
        request, response, next in

        // guard let id = request.params["id"] else {
        //     response.status(.badRequest)
        //     Log.error("Request does not contain ID")
        //     return
        // }
        //
        // todos.get(id) {
        //
        //     item in
        //
        //     if let item = item {
        //
        //         let result = JSON(item.serialize())
        //
        //         do {
        //             try response.status(.OK).send(json: result).end()
        //         } catch {
        //             Log.error("Error sending response")
        //         }
        //     } else {
        //         Log.warning("Could not find the item")
        //         response.status(.badRequest)
        //         return
        //     }
        //
        // }
    }

    /**
     Handle options
     */
    router.options("/*") {
        request, response, next in

        // response.setHeader("Access-Control-Allow-Headers", value: "accept, content-type")
        response.headers["Access-Control-Allow-Headers"] = "accept, content-type"
        // response.setHeader("Access-Control-Allow-Methods", value: "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH")
        response.headers["Access-Control-Allow-Headers"] = "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH"

        response.status(.OK)

        next()
    }

    /**
     Add a todo list item
     */
    router.post("/") {
        request, response, next in

        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No body found in request")
            return
        }

        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Body is invalid JSON")
            return
        }

        let title = json["title"].stringValue
        let order = json["order"].intValue
        let completed = json["completed"].boolValue

        Log.info("Received \(title)")

        // todos.add(title: title, order: order, completed: completed) {
        //
        //     newItem in
        //
        //     let result = JSON(newItem.serialize())
        //
        //     do {
        //         try response.status(.OK).send(json: result).end()
        //     } catch {
        //         Log.error("Error sending response")
        //     }
        // }
    }

    router.post(config.firstPathSegment + "/:id") {
        request, response, next in

        guard let id = request.params["id"] else {
            response.status(.badRequest)
            Log.error("id parameter not found in request")
            return
        }

        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No body found in request")
            return
        }

        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Body is invalid JSON")
            return
        }

        let title = json["title"].stringValue
        let order = json["order"].intValue
        let completed = json["completed"].boolValue

        // todos.update(id: id, title: title, order: order, completed: completed) {
        //
        //     newItem in
        //
        //     let result = JSON(newItem!.serialize())
        //     response.status(.OK).send(json: result)
        // }
    }

    /**
     Patch or update an existing Todo item
     */
    router.patch(config.firstPathSegment + "/:id") {
        request, response, next in

        guard let id = request.params["id"] else {
            response.status(.badRequest)
            Log.error("id parameter not found in request")
            return
        }

        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No body found in request")
            return
        }

        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Body is invalid JSON")
            return
        }

        let title = json["title"].stringValue
        let order = json["order"].intValue
        let completed = json["completed"].boolValue

        // todos.update(id: id, title: title, order: order, completed: completed) {
        //
        //     newItem in
        //
        //     if let newItem = newItem {
        //
        //         let result = JSON(newItem.serialize())
        //
        //         do {
        //             try response.status(.OK).send(json: result).end()
        //         } catch {
        //             Log.error("Error sending response")
        //         }
        //     }
        // }
    }

    ///
    /// Delete an individual todo item
    ///
    router.delete(config.firstPathSegment + "/:id") {
        request, response, next in

        Log.info("Requesting a delete")

        guard let id = request.params["id"] else {
            Log.warning("Could not parse ID")
            response.status(.badRequest)
            return
        }

        // todos.delete(id) {
        //
        //     do {
        //         try response.status(.OK).end()
        //     } catch {
        //         Log.error("Could not produce response")
        //     }
        //
        // }
    }

    /**
     Delete all the todo items
     */
    router.delete("/") {
        request, response, next in

        Log.info("Requested clearing the entire list")

        // todos.clear() {
        //     do {
        //         try response.status(.OK).end()
        //     } catch {
        //         Log.error("Could not produce response")
        //     }
        // }
    }

} // end of SetupRoutes()
