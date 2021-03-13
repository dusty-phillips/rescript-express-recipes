let recipeRxDbFeed = ({id, minUpdatedAt, limit}: Schema.recipesRxDbFeedInput) => {
  []
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
