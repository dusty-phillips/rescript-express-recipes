open Zora

zoraBlock("Test endpoints", t => {
  t->block("The Happy Path", t => {
    let body = Some(
      Js.Json.parseExn(`
      {
        "title": "Bread",
        "ingredients": "Flour and Water",
        "instructions": "Mix and Bake"
      }
    `),
    )

    let result = body->Controller.addRecipe
    let id =
      result
      ->Js.Json.decodeObject
      ->Belt.Option.getUnsafe
      ->Js.Dict.get("id")
      ->Belt.Option.getUnsafe
      ->Js.Json.decodeString
      ->Belt.Option.getUnsafe

    t->equal(id->Js.String2.length, 36, "The id should be the length of a uuid")

    let params = Js.Dict.empty()
    params->Js.Dict.set("id", id->Js.Json.string)

    let result = params->Controller.getRecipe
    let json = result->Js.Json.stringifyAny->Belt.Option.getUnsafe

    let expected = `{"id":"${id}","title":"Bread","ingredients":"Flour and Water","instructions":"Mix and Bake","tags":[]}`
    t->equal(json, expected, "get recipe should match input")
  })

  Store.Reducer.dangerousResetState()
})
