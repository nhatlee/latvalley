import Vapor

/// Test commit from company laptop
func routes(_ app: Application) throws {
    
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
