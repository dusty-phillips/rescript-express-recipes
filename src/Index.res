open Express

let app = express()
let port = 3000

App.use(app, Middleware.json())

App.get(
  app,
  ~path="/",
  Middleware.from((_, _, res) => {
    let result = Js.Dict.empty()
    result->Js.Dict.set("Hello", "World"->Js.Json.string)
    let json = result->Js.Json.object_
    res->Response.status(Response.StatusCode.Ok)->Response.sendJson(json)
  }),
)

App.post(
  app,
  ~path="/addRecipe",
  Middleware.from((_next, req, res) => {
    let jsonResponse = Js.Dict.empty()
    switch req->Request.bodyJSON {
    | None => jsonResponse->Js.Dict.set("error", "not a json request"->Js.Json.string)
    | Some(json) =>
      switch json->Js.Json.decodeObject {
      | None => jsonResponse->Js.Dict.set("error", "not a json object"->Js.Json.string)
      | Some(jsonBody) =>
        switch (
          jsonBody->Js.Dict.get("title")->Belt.Option.map(r => Js.Json.decodeString(r)),
          jsonBody->Js.Dict.get("ingredients")->Belt.Option.map(r => Js.Json.decodeString(r)),
          jsonBody->Js.Dict.get("instructions")->Belt.Option.map(r => Js.Json.decodeString(r)),
        ) {
        | (Some(Some(title)), Some(Some(ingredients)), Some(Some(instructions))) =>
          jsonResponse->Js.Dict.set("good", title->Js.Json.string)
          jsonResponse->Js.Dict.set("with", ingredients->Js.Json.string)
          jsonResponse->Js.Dict.set("attributes", instructions->Js.Json.string)
        | _ => jsonResponse->Js.Dict.set("error", "missing attribute"->Js.Json.string)
        }
      }
    }

    res->Response.sendJson(jsonResponse->Js.Json.object_)
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
