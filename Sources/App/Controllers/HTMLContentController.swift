//
//  File.swift
//  latvalley
//
//  Created by Nhat Le Tien on 17/1/25.
//

import Vapor

struct HTMLContentController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let htmlContentRoutes = routes.grouped("api", "html-content")
        htmlContentRoutes.on(.GET, "home", use: homePage)
        htmlContentRoutes.on(.GET, "detail", use: detailPage)
//        htmlContentRoutes.group(":html") { htmlReq in
//            htmlReq.on(.GET, use: homePage)
//            htmlReq.on(.GET, "detail", use: detailPage)
//        }
    }
    
    func homePage(req: Request) async throws -> HTML {
        return HTML(value: """
          <html>
            <body>
              <h1>Hello, Lat Valley!</h1>
            </body>
          </html>
          """)
    }
    
    func detailPage(req: Request) async throws -> HTML {
        return HTML(value: """
          <html>
            <body>
              <h1>Detail page of Lat Valley</h1>
            </body>
          </html>
          """)
    }
}
