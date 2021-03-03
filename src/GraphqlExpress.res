type graphQlHttpOptions = {
  schema: Schema.t,
  graphiql: bool,
  rootValue: Schema.rootValue,
}

@module("express-graphql")
external graphqlHttp: graphQlHttpOptions => Express.Middleware.t = "graphqlHTTP"
