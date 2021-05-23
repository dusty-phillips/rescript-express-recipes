let helloWorld = () => {
  let result = Js.Dict.empty()
  result->Js.Dict.set("Hello", "World"->Js.Json.string)
  result->Js.Json.object_
}

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

let addRecipe = body => {
  let jsonFields =
    body
    ->Belt.Option.flatMap(Js.Json.decodeObject)
    ->Belt.Option.map(jsonBody => (
      jsonBody->Js.Dict.get("title")->Belt.Option.flatMap(Js.Json.decodeString),
      jsonBody->Js.Dict.get("ingredients")->Belt.Option.flatMap(Js.Json.decodeString),
      jsonBody->Js.Dict.get("instructions")->Belt.Option.flatMap(Js.Json.decodeString),
    ))

  let jsonResponse = Js.Dict.empty()

  switch jsonFields {
  | Some(Some(title), Some(ingredients), Some(instructions)) => {
      open Store.Reducer
      let id = Store.uuid()
      dispatch(
        AddRecipe({id: id, title: title, ingredients: ingredients, instructions: instructions}),
      )
      jsonResponse->Js.Dict.set("id", id->Js.Json.string)
    }
  | _ => jsonResponse->Js.Dict.set("error", "missing attribute"->Js.Json.string)
  }

  jsonResponse->Js.Json.object_
}

let addTagToRecipe = body => {
  open Belt
  open Store.Reducer
  let jsonResponse = Js.Dict.empty()

  let jsonFields =
    body
    ->Option.flatMap(Js.Json.decodeObject)
    ->Option.map(jsonBody => (
      jsonBody
      ->Js.Dict.get("recipeId")
      ->Option.flatMap(Js.Json.decodeString)
      ->Option.flatMap(id => getState().recipes->Map.String.get(id)),
      jsonBody->Js.Dict.get("tag")->Option.flatMap(Js.Json.decodeString),
    ))

  switch jsonFields {
  | Some(Some(recipe), Some(tag)) => {
      jsonResponse->Js.Dict.set("success", true->Js.Json.boolean)
      dispatch(AddTag({recipeId: recipe.id, tag: tag}))
    }
  | _ => jsonResponse->Js.Dict.set("error", "invalid request"->Js.Json.string)
  }

  jsonResponse->Js.Json.object_
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
