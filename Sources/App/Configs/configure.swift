import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    try register(
        app,
        collections:
            UserController(),
            HTMLContentController()
    )
    configPostgresDB(app)
    
    // register routes
    try routes(app)
    
}

func register(_ app: Application, collections: RouteCollection...) throws {
    for collection in collections {
        try app.register(collection: collection)
    }
}

func configPostgresDB(_ app: Application) {
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                username: "postgres",
                password: "",
                database: "latvalleydb",
                tls: .disable// Should enable on Prod
            )
        ),
        as: .psql
    )
    app.migrations.add(CreateUser())
}
