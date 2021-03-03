type t
type rootValue = {hello: unit => string}

@module("graphql") external buildSchema: string => t = "buildSchema"

@module("graphql")
external graphql: (t, string, rootValue) => Js.Promise.t<'result> = "graphql"

let schema = buildSchema(`
  type Query {
    hello: String
  }
`)
