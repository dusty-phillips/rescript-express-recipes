let helloWorld = () => {
  let result = Js.Dict.empty()
  result->Js.Dict.set("Hello", "World"->Js.Json.string)
  result->Js.Json.object_
}

let jsonResult = o => o->Belt.Option.mapWithDefault(Error(#SyntaxError("Invalid JSON")), s => Ok(s))

type errorResult = {error: string}

let errorResultCodec = Jzon.object1(
  ({error}) => error,
  error => {error: error}->Ok,
  Jzon.field("error", Jzon.string),
)

type genericSuccess = {success: bool}

let genericSuccessCodec = Jzon.object1(
  ({success}) => success,
  success => {success: success}->Ok,
  Jzon.field("success", Jzon.bool),
)

type genericId = {id: string}

let genericIdCodec = Jzon.object1(({id}) => id, id => {id: id}->Ok, Jzon.field("id", Jzon.string))

type addRecipeInput = {
  title: string,
  ingredients: string,
  instructions: string,
}

let addRecipeInputCodec = Jzon.object3(
  ({title, ingredients, instructions}) => (title, ingredients, instructions),
  ((title, ingredients, instructions)) =>
    {
      title: title,
      ingredients: ingredients,
      instructions: instructions,
    }->Ok,
  Jzon.field("title", Jzon.string),
  Jzon.field("ingredients", Jzon.string),
  Jzon.field("instructions", Jzon.string),
)

type addTagToRecipe = {
  recipeId: string,
  tag: string,
}

let addTagToRecipeInputCodec = Jzon.object2(
  ({recipeId, tag}) => (recipeId, tag),
  ((recipeId, tag)) =>
    {
      recipeId: recipeId,
      tag: tag,
    }->Ok,
  Jzon.field("recipeId", Jzon.string),
  Jzon.field("tag", Jzon.string),
)

let addRecipe = bodyOption => {
  let jsonBodyOption =
    bodyOption->jsonResult->Belt.Result.flatMap(j => addRecipeInputCodec->Jzon.decode(j))

  switch jsonBodyOption {
  | Ok({title, instructions, ingredients}) => {
      let id = Store.uuid()
      Store.Reducer.dispatch(
        AddRecipe({id: id, title: title, ingredients: ingredients, instructions: instructions}),
      )
      genericIdCodec->Jzon.encode({id: id})
    }
  | Error(error) => errorResultCodec->Jzon.encode({error: error->Jzon.DecodingError.toString})
  }
}

let addTagToRecipe = bodyOption => {
  let jsonBodyOption =
    bodyOption->jsonResult->Belt.Result.flatMap(j => addTagToRecipeInputCodec->Jzon.decode(j))

  switch jsonBodyOption {
  | Ok({recipeId, tag}) =>
    switch Store.Reducer.getState().recipes->Belt.Map.String.get(recipeId) {
    | Some(recipe) => {
        Store.Reducer.dispatch(AddTag({recipeId: recipe.id, tag: tag}))
        genericSuccessCodec->Jzon.encode({success: true})
      }
    | None => errorResultCodec->Jzon.encode({error: "recipe does not exist"})
    }
  | Error(error) => errorResultCodec->Jzon.encode({error: error->Jzon.DecodingError.toString})
  }
}

let getRecipe = params => {
  open Belt
  let jsonResponse = Js.Dict.empty()
  let state = Store.Reducer.getState()
  let recipeOption =
    params
    ->Js.Dict.get("id")
    ->Option.flatMap(Js.Json.decodeString)
    ->Option.flatMap(id => state.recipes->Map.String.get(id))
  switch recipeOption {
  | None => jsonResponse->Js.Dict.set("error", "unable to find that recipe"->Js.Json.string)
  | Some(recipe) => {
      jsonResponse->Js.Dict.set("id", recipe.id->Js.Json.string)
      jsonResponse->Js.Dict.set("title", recipe.title->Js.Json.string)
      jsonResponse->Js.Dict.set("ingredients", recipe.ingredients->Js.Json.string)
      jsonResponse->Js.Dict.set("instructions", recipe.instructions->Js.Json.string)
      jsonResponse->Js.Dict.set("tags", recipe.tags->Js.Json.stringArray)
    }
  }

  jsonResponse->Js.Json.object_
}

let getTag = params => {
  open Belt
  let jsonResponse = Js.Dict.empty()
  let state = Store.Reducer.getState()
  let taggedRecipesOption =
    params
    ->Js.Dict.get("tag")
    ->Option.flatMap(Js.Json.decodeString)
    ->Option.flatMap(tag => state.tags->Map.String.get(tag))

  switch taggedRecipesOption {
  | None => jsonResponse->Js.Dict.set("error", "tag not found"->Js.Json.string)
  | Some(taggedRecipes) => {
      let recipes =
        taggedRecipes.recipes
        ->Array.map(id => {
          state.recipes
          ->Map.String.get(id)
          ->Option.map(recipe => {
            let dict = Js.Dict.empty()
            dict->Js.Dict.set("id", id->Js.Json.string)
            dict->Js.Dict.set("title", recipe.title->Js.Json.string)
            dict
          })
        })
        ->Array.keep(value => value->Option.isSome)
        ->Array.map(opt => opt->Option.getUnsafe->Js.Json.object_)
        ->Js.Json.array
      jsonResponse->Js.Dict.set("recipes", recipes)
    }
  }

  jsonResponse->Js.Json.object_
}
