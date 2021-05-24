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

    let actual = Controller.recipeCodec->Jzon.decode(result)->Belt.Result.getExn
    t->equal(actual.id, id, "should have same ids")
    t->equal(actual.title, "Bread", "should same title")
    t->equal(actual.ingredients, "Flour and Water", "have same ingredients")
    t->equal(actual.instructions, "Mix and Bake", "have same instructions")
    t->equal(actual.deleted, false, "should not be deleted")
    t->equal(actual.tags->Belt.Array.length, 0, "Should not have any tags")

    let body = Some(
      Js.Json.parseExn(
        `
        {
          "recipeId": "${id}",
          "tag": "Carbs"
        }
        `,
      ),
    )

    let result = body->Controller.addTagToRecipe

    let json = result->Js.Json.stringifyAny->Belt.Option.getUnsafe
    let expected = `{"success":true}`
    t->equal(json, expected, "addTagToRecipe should return success")

    let result = params->Controller.getRecipe

    let actual = Controller.recipeCodec->Jzon.decode(result)->Belt.Result.getExn
    t->equal(actual.id, id, "should have same ids")
    t->equal(actual.title, "Bread", "should same title")
    t->equal(actual.ingredients, "Flour and Water", "have same ingredients")
    t->equal(actual.instructions, "Mix and Bake", "have same instructions")
    t->equal(actual.deleted, false, "should not be deleted")
    t->equal(actual.tags->Belt.Array.length, 1, "Should have one tag")
    t->equal(actual.tags->Belt.Array.getUnsafe(0), "Carbs", "First tag should be carbs")

    let params = Js.Dict.empty()
    params->Js.Dict.set("tag", "Carbs"->Js.Json.string)

    let result = params->Controller.getTag

    let json = result->Js.Json.stringifyAny->Belt.Option.getUnsafe
    let expected = `{"recipes":[{"id":"${id}","title":"Bread"}]}`
    t->equal(json, expected, "tag should now have recipes")
  })

  Store.Reducer.dangerousResetState()

  t->block("addRecipe missing attribute", t => {
    let body = Some(Js.Json.parseExn(`{}`))
    let result = body->Controller.addRecipe
    let json = result->Js.Json.stringifyAny->Belt.Option.getUnsafe
    let expected = `{"error":"Missing field \\\"title\\\" at ."}`
    t->equal(json, expected, "There should be missing attributes")
    Js.log(json)
  })

  t->block("can't add tag to nonexistent recipe", t => {
    let body = Some(
      Js.Json.parseExn(`
        {
          "recipeId": "Not a Recipe",
          "tag": "Carbs"
        }
        `),
    )
    let result = body->Controller.addTagToRecipe
    let json = result->Js.Json.stringifyAny->Belt.Option.getUnsafe
    let expected = `{"error":"recipe does not exist"}`
    t->equal(json, expected, "addTagToRecipe should return success")
  })

  t->block("Can't get recipe that doesn't exist", t => {
    let params = Js.Dict.empty()
    params->Js.Dict.set("id", "Not a Recipe"->Js.Json.string)
    let result = params->Controller.getRecipe
    let json = result->Js.Json.stringifyAny->Belt.Option.getUnsafe
    let expected = `{"error":"unable to find that recipe"}`
    t->equal(json, expected, "get recipe should match input")
  })
})
