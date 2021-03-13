open Belt

let recipeRxDbFeed = ({id, minUpdatedAt, limit}: Schema.recipesRxDbFeedInput) => {
  Store.Reducer.getState().recipes
  ->Map.String.valuesToArray
  ->Array.keep(r => {
    Js.log3(r, minUpdatedAt, id)
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
  []
}

let setRecipe = ({recipe}: Schema.recipeInput): Store.recipe => {
  id: recipe.id,
  title: recipe.title,
  ingredients: recipe.ingredients,
  instructions: recipe.instructions,
  tags: recipe.tags,
  deleted: recipe.deleted,
  updatedAt: Js.Date.now(),
}

let setTaggedRecipes = ({taggedRecipes}: Schema.taggedRecipesInput): Store.taggedRecipes => {
  tag: taggedRecipes.tag,
  recipes: taggedRecipes.recipes,
  deleted: taggedRecipes.deleted,
  updatedAt: Js.Date.now(),
}

let rootValue: Schema.rootValue = {
  recipeRxDbFeed: recipeRxDbFeed,
  taggedRecipesRxDbFeed: taggedRecipesRxDbFeed,
  setRecipe: setRecipe,
  setTaggedRecipes: setTaggedRecipes,
}
