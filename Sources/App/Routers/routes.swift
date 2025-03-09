import Vapor

/// Test commit from company laptop
func routes(_ app: Application) throws {
    app.get("photos") { req -> EventLoopFuture<[PhotoModel]> in
        let response = req.client.get(URI(string: "https://jsonplaceholder.typicode.com/photos"))
        return response.flatMapThrowing { try $0.content.decode([PhotoModel].self) }
    }
    
    app.get("number", ":x") { req -> String in
        guard let int = req.parameters.get("x", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "\(int) is a great number"
    }
    
    app.post("createUser") { req -> EventLoopFuture<UserModel> in
        let user = try req.content.decode(UserModel.self)
        return user.create(on: req.db).map {user}
    }
    
    app.get("allUsers") { req async throws -> [UserModel] in
        do {
           return try await UserModel.query(on: req.db).all()
        } catch {
            req.logger.info("\(String(reflecting: error))")
            throw error
        }
    }
}
