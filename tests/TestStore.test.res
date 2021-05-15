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
})
