open Belt

let recipeRxDbFeed = ({id, minUpdatedAt, limit}: Schema.recipesRxDbFeedInput) => {
  Store.Reducer.getState().recipes
  ->Map.String.valuesToArray
  ->Array.keep(r => {
    if r.updatedAt == minUpdatedAt {
      r.id > id
    } else {
      r.updatedAt > minUpdatedAt
    }
  })
  ->SortArray.stableSortBy((r1, r2) => {
    if r1.updatedAt > r2.updatedAt {
      1
    } else if r1.updatedAt < r2.updatedAt {
      -1
    } else if r1.id > r2.id {
      1
    } else if r1.id < r2.id {
      -1
    } else {
      0
    }
  })
  ->Array.slice(~offset=0, ~len=limit)
}

let taggedRecipesRxDbFeed = ({tag, minUpdatedAt, limit}: Schema.taggedRecipesRxDbFeedInput) => {
  Store.Reducer.getState().tags
  ->Map.String.valuesToArray
  ->Array.keep(r => {
    if r.updatedAt == minUpdatedAt {
      r.tag > tag
    } else {
      r.updatedAt > minUpdatedAt
    }
  })
  ->SortArray.stableSortBy((r1, r2) => {
    if r1.updatedAt > r2.updatedAt {
      1
    } else if r1.updatedAt < r2.updatedAt {
      -1
    } else if r1.tag > r2.tag {
      1
    } else if r1.tag < r2.tag {
      -1
    } else {
      0
    }
  })
  ->Array.slice(~offset=0, ~len=limit)
}

let setRecipe = ({recipe}: Schema.recipeInput): Store.recipe => {
  let result: Store.recipe = {
    id: recipe.id,
    title: recipe.title,
    ingredients: recipe.ingredients,
    instructions: recipe.instructions,
    tags: recipe.tags,
    deleted: recipe.deleted,
    updatedAt: Js.Date.now(),
  }
  Store.Reducer.dispatch(SetRecipe(result))
  result
}

let setTaggedRecipes = ({taggedRecipes}: Schema.taggedRecipesInput): Store.taggedRecipes => {
  let result: Store.taggedRecipes = {
    tag: taggedRecipes.tag,
    recipes: taggedRecipes.recipes,
    deleted: taggedRecipes.deleted,
    updatedAt: Js.Date.now(),
  }
  Store.Reducer.dispatch(SetTaggedRecipes(result))
  result
}

let rootValue: Schema.rootValue = {
  recipeRxDbFeed: recipeRxDbFeed,
  taggedRecipesRxDbFeed: taggedRecipesRxDbFeed,
  setRecipe: setRecipe,
  setTaggedRecipes: setTaggedRecipes,
}
