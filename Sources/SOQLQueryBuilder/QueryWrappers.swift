
public struct EmptyQuery: PartialQuery {
  public func build() -> String { "" }
}

public struct QueryGroup: PartialQuery {
  var queries: [PartialQuery] {
    allQueries
      .filter({ !($0 is EmptyQuery) })
      .flatMap(flattenQuery)
  }
  private let allQueries: [PartialQuery]

  public init(_ allQueries: [PartialQuery]) {
    self.allQueries = allQueries
  }

  public func build() -> String {
    queries.map({ $0.build() }).joined()
  }
}

public struct FieldGroup: PartialQuery, FieldConvertible {
  let fields: [FieldConvertible]

  public var asString: String {
    build()
  }

  public init(_ fields: [FieldConvertible]) {
    self.fields = fields
  }

  public func build() -> String {
    fields.map(\.asString).joined(separator: ",")
  }
}

public struct InnerQuery: PartialQuery {
  var queries: [PartialQuery] {
    allQueries
      .filter({ !($0 is EmptyQuery) })
      .flatMap(flattenQuery)
  }
  private let allQueries: [PartialQuery]

  public init(_ allQueries: [PartialQuery]) {
    self.allQueries = allQueries
  }

  public func build() -> String {
    wrap(queries.map({ $0.build() }).joined())
  }
}
