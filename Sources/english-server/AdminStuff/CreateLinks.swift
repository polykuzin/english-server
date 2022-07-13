//
//  CreateLinks.swift
//  
//
//  Created by polykuzin on 13/07/2022.
//

import Vapor
import Fluent

struct CreateLinks: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("links")
      .id()
      .field("short_url", .string)
      .field("long_url", .string)
      .field("created_date", .datetime)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("links").delete()
  }
}
