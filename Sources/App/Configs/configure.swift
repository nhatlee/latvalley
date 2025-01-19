import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app)
    try app.register(collection: UserController())
    try app.register(collection: HTMLContentController())
    
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                username: "latvalley",
                password: "latvalley@2025",
                database: "latvalley",
                tls: .disable
            )
        ),
        as: .psql
    )
}
