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
    let jsonFields =
      req
      ->Request.bodyJSON
      ->Belt.Option.flatMap(Js.Json.decodeObject)
      ->Belt.Option.map(jsonBody => (
        jsonBody->Js.Dict.get("title")->Belt.Option.flatMap(Js.Json.decodeString),
        jsonBody->Js.Dict.get("ingredients")->Belt.Option.flatMap(Js.Json.decodeString),
        jsonBody->Js.Dict.get("instructions")->Belt.Option.flatMap(Js.Json.decodeString),
      ))

    switch jsonFields {
    | Some(Some(title), Some(ingredients), Some(instructions)) => {
        open Store.Reducer
        let state = getState()
        let id = state.nextId
        dispatch(AddRecipe({title: title, ingredients: ingredients, instructions: instructions}))
        jsonResponse->Js.Dict.set("id", id->Js.Int.toFloat->Js.Json.number)
      }
    | _ => jsonResponse->Js.Dict.set("error", "missing attribute"->Js.Json.string)
    }

    res->Response.sendJson(jsonResponse->Js.Json.object_)
  }),
)

App.post(
  app,
  ~path="/addTagToRecipe",
  Middleware.from((_next, req, res) => {
    open Belt
    open Store.Reducer
    let jsonResponse = Js.Dict.empty()

    let jsonFields =
      req
      ->Request.bodyJSON
      ->Option.flatMap(Js.Json.decodeObject)
      ->Option.map(jsonBody => (
        jsonBody
        ->Js.Dict.get("recipeId")
        ->Option.flatMap(Js.Json.decodeNumber)
        ->Option.map(Int.fromFloat)
        ->Option.flatMap(id => getState().recipes->Map.Int.get(id)),
        jsonBody->Js.Dict.get("tag")->Option.flatMap(Js.Json.decodeString),
      ))

    switch jsonFields {
    | Some(Some(recipe), Some(tag)) => {
        jsonResponse->Js.Dict.set("success", true->Js.Json.boolean)
        dispatch(AddTag({recipeId: recipe.id, tag: tag}))
      }
    | _ => jsonResponse->Js.Dict.set("error", "invalid request"->Js.Json.string)
    }
    res->Response.sendJson(jsonResponse->Js.Json.object_)
  }),
)

App.get(
  app,
  ~path="/recipes/:id",
  Middleware.from((_next, req, res) => {
    open Belt
    let jsonResponse = Js.Dict.empty()
    let state = Store.Reducer.getState()
    let recipeOption =
      req
      ->Request.params
      ->Js.Dict.get("id")
      ->Option.flatMap(Js.Json.decodeString)
      ->Option.flatMap(Int.fromString)
      ->Option.flatMap(id => state.recipes->Map.Int.get(id))
    switch recipeOption {
    | None => jsonResponse->Js.Dict.set("error", "unable to find that recipe"->Js.Json.string)
    | Some(recipe) => {
        jsonResponse->Js.Dict.set("id", recipe.id->Float.fromInt->Js.Json.number)
        jsonResponse->Js.Dict.set("title", recipe.title->Js.Json.string)
        jsonResponse->Js.Dict.set("ingredients", recipe.ingredients->Js.Json.string)
        jsonResponse->Js.Dict.set("instructions", recipe.instructions->Js.Json.string)
        jsonResponse->Js.Dict.set("tags", recipe.tags->Js.Json.stringArray)
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
