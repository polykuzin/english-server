//
//  english-server.swift
//  
//
//  Created by polykuzin on 07/07/2022.
//

import Vapor

@main
public struct english_server {
    
    public static func main() async throws {
        let webapp = Application()
        let foodTruckServer = FoodTruckServer()
        try await foodTruckServer.bootstrap()
        webapp.get("greet", use: Self.greet(_:))
        webapp.post("reflect", use: Self.reflect(_:))
        webapp.get("donuts", use: foodTruckServer.listOfDonuts(_:))
        try webapp.run()
    }
    
    static func greet(_ req: Request) async throws -> String {
        return "Hello from Swift Server"
    }
    
    static func reflect(_ req: Request) async throws -> String {
        if let body = req.body.string {
            return body
        }
        throw Abort(.badRequest)
    }
}

struct FoodTruckServer {
    
    private let storage = Storage()
    
    func bootstrap() async throws {
        try await self.storage.load()
    }
    
    func listOfDonuts(_ req: Request) async -> [Donut] {
        return await self.storage.listDonuts()
    }
}

actor Storage {
    let jsonDecoder : JSONDecoder
    var donuts = [Donut]()
    
    init() {
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    func load() throws {
        guard
            let path = Bundle.module.path(forResource: "menu", ofType: "json")
        else {
            throw Abort(.internalServerError)
        }
        guard
            let data = FileManager.default.contents(atPath: path)
        else {
            throw Abort(.noContent)
        }
        self.donuts = try self.jsonDecoder.decode([Donut].self, from: data)
    }
    
    func listDonuts() -> [Donut] {
        return self.donuts
    }
}

struct Donut : Encodable, Decodable, Content {
    public var id : UUID
    public var name : String
    public var date : String
    public var dough : Dough
    public var glaze : Glaze?
}

struct Dough : Encodable, Decodable {
    let name : String
    let flavors : Flavors
    let description : String
}

struct Glaze : Encodable, Decodable {
    let name : String
    let description : String
}

struct Flavors : Encodable, Decodable {
    let sweet : Int
    let savory : Int
}
