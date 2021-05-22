open Express

let app = express()
let port = 3001

App.use(app, Middleware.json())

App.useOnPath(
  app,
  ~path="/graphql",
  GraphqlExpress.graphqlHttp({
    schema: Schema.schema,
    graphiql: true,
    rootValue: Resolvers.rootValue,
  }),
)

App.get(
  app,
  ~path="/",
  Middleware.from((_, _, res) => {
    let json = Controller.helloWorld()
    res->Response.status(Response.StatusCode.Ok)->Response.sendJson(json)
  }),
)

App.post(
  app,
  ~path="/addRecipe",
  Middleware.from((_next, req, res) => {
    let jsonResponse = req->Request.bodyJSON->Controller.addRecipe
    res->Response.sendJson(jsonResponse)
  }),
)

App.post(
  app,
  ~path="/addTagToRecipe",
  Middleware.from((_next, req, res) => {
    let jsonResponse = req->Request.bodyJSON->Controller.addTagToRecipe
    res->Response.sendJson(jsonResponse)
  }),
)

App.get(
  app,
  ~path="/recipes/:id",
  Middleware.from((_next, req, res) => {
    let jsonResponse = req->Request.params->Controller.getRecipe
    res->Response.sendJson(jsonResponse)
  }),
)

App.get(
  app,
  ~path="/allTags",
  Middleware.from((_next, _req, res) => {
    let jsonResponse = Js.Dict.empty()
    jsonResponse->Js.Dict.set(
      "tags",
      Store.Reducer.getState().tags->Belt.Map.String.keysToArray->Js.Json.stringArray,
    )
    res->Response.sendJson(jsonResponse->Js.Json.object_)
  }),
)

App.get(
  app,
  ~path="/tags/:tag",
  Middleware.from((_next, req, res) => {
    let jsonResponse = req->Request.params->Controller.getTag
    res->Response.sendJson(jsonResponse)
  }),
)

let server = App.listen(
  app,
  ~port,
  ~onListen=_ => {
    Js.log(`Example app listening at http://localhost:${Js.Int.toString(port)}`)
  },
  (),
)
