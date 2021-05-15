open Belt
open Zora

zoraBlock("Test recipes Store", t => {
  t->test("Adds a recipe to empty state", t => {
    let state = Store.initialState
    let action = Store.AddRecipe({
      id: "abc",
      title: "Bread",
      ingredients: "Flour, Water",
      instructions: "Mix and Bake",
    })
    let newState = Store.reducer(state, action)

    t->equal(newState.recipes->Map.String.size, 1, "Should be one recipe in the map")
    t->ok(newState.recipes->Map.String.has("abc"), "The one recipe should have id 'abc'")

    let recipe = newState.recipes->Map.String.getExn("abc")
    t->equal(recipe.title, "Bread", "The titles should match")

    t->equal(state.tags->Map.String.size, 0, "Should not add any tags")

    done()
  })

  t->test("setRecipe does not add two recipes", t => {
    let state = Store.initialState
    let action = Store.SetRecipe({
      Store.id: "abc",
      title: "Bread",
      ingredients: "Flour, Water",
      instructions: "Mix and Bake",
      tags: [],
      updatedAt: 500.0,
      deleted: false,
    })
    let state = Store.reducer(state, action)
    t->equal(state.recipes->Map.String.size, 1, "Should be one recipe in the map")
    let state = Store.reducer(state, action)
    t->equal(state.recipes->Map.String.size, 1, "Should still be one recipe in the map")

    done()
  })

  t->test("AddTag action", t => {
    t->test("noop when recipe does not exist", t => {
      let state = Store.initialState
      let action = Store.AddTag({
        recipeId: "doesn't exist",
        tag: "add me",
      })

      let state = Store.reducer(state, action)
      t->equal(state.recipes->Map.String.size, 0, "Should not have added a recipe")
      t->equal(state.tags->Map.String.size, 0, "Should not have added a tag")

      done()
    })

    t->test("creates tag when it does not exist", t => {
      let state: Store.state = {
        recipes: Map.String.empty->Map.String.set(
          "abc",
          {
            Store.id: "abc",
            title: "Bread",
            ingredients: "Flour, Water",
            instructions: "Mix and Bake",
            tags: [],
            updatedAt: 500.0,
            deleted: false,
          },
        ),
        tags: Map.String.empty,
      }

      let action = Store.AddTag({recipeId: "abc", tag: "Carbs"})
      let state = Store.reducer(state, action)

      t->equal(state.recipes->Map.String.size, 1, "Should still have one recipe")
      t->equal(state.tags->Map.String.size, 1, "Should have one tag")

      let breadOption = state.recipes->Map.String.get("abc")
      t->optionSome(breadOption, (t, bread) => {
        t->equal(bread.tags->Array.size, 1, "Bread should have one tag")
        t->equal(bread.tags->Array.getUnsafe(0), "Carbs", "Bread tag should be carbs")
      })

      let tagsOption = state.tags->Map.String.get("Carbs")
      t->optionSome(tagsOption, (t, tag) => {
        t->equal(tag.tag, "Carbs", "tag should have correct name")
        t->equal(tag.recipes->Array.size, 1, "Tag should have one recipe")
      })

      done()
    })

    t->test("appends tag when it does exist", t => {
      let state: Store.state = {
        recipes: Map.String.empty->Map.String.set(
          "abc",
          {
            Store.id: "abc",
            title: "Bread",
            ingredients: "Flour, Water",
            instructions: "Mix and Bake",
            tags: ["Baking"],
            updatedAt: 500.0,
            deleted: false,
          },
        ),
        tags: Map.String.empty->Map.String.set(
          "baking",
          {Store.tag: "baking", recipes: ["abc"], updatedAt: 500.0, deleted: false},
        ),
      }

      let action = Store.AddTag({recipeId: "abc", tag: "Carbs"})
      let state = Store.reducer(state, action)

      t->equal(state.recipes->Map.String.size, 1, "Should still have one recipe")
      t->equal(state.tags->Map.String.size, 2, "Should have two tags")

      let breadOption = state.recipes->Map.String.get("abc")
      t->optionSome(breadOption, (t, bread) => {
        t->equal(bread.tags->Array.size, 2, "Bread should have two tag")
        t->equal(bread.tags->Array.getUnsafe(0), "Baking", "First bread tag should be Baking")
        t->equal(bread.tags->Array.getUnsafe(1), "Carbs", "Second bread tag should be carbs")
      })

      let tagsOption = state.tags->Map.String.get("Carbs")
      t->optionSome(tagsOption, (t, tag) => {
        t->equal(tag.tag, "Carbs", "tag should have correct name")
        t->equal(tag.recipes->Array.size, 1, "Tag should have one recipe")
      })

      done()
    })

    done()
  })
})
