import Vapor

func routes(_ app: Application) throws {
    
    app.get("number", ":x") { req -> String in
        guard let int = req.parameters.get("x", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "\(int) is a great number"
    }
}
