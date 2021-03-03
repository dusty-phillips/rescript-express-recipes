type t

type greetByNameArgs = {name: string}

type rootValue = {
  hello: unit => string,
  greetByName: greetByNameArgs => string,
}

@module("graphql") external buildSchema: string => t = "buildSchema"

@module("graphql")
external graphql: (t, string, rootValue) => Js.Promise.t<'result> = "graphql"

let schema = buildSchema(`
  type Query {
    hello: String
    greetByName(name: String): String
  }
`)
