open Belt

type id = int

type recipe = {
  id: id,
  title: string,
  ingredients: string,
  instructions: string,
  tags: array<string>,
}

type state = {
  nextId: id,
  recipes: Map.Int.t<recipe>,
  tags: Map.String.t<array<int>>,
}

let initialState: state = {
  nextId: 0,
  recipes: Map.Int.empty,
  tags: Map.String.empty,
}

type action =
  | AddRecipe({title: string, ingredients: string, instructions: string})
  | AddTag({recipeId: int, tag: string})

let addRecipe = (state: state, title: string, ingredients: string, instructions: string) => {
  let id = state.nextId
  {
    recipes: state.recipes->Map.Int.set(
      id,
      {
        id: id,
        title: title,
        ingredients: ingredients,
        instructions: instructions,
        tags: [],
      },
    ),
    nextId: state.nextId + 1,
    tags: state.tags,
  }
}

let updateTagsArray = (taggedRecipesOption: option<array<int>>, recipeId: int) => {
  switch taggedRecipesOption {
  | None => Some([recipeId])
  | Some(taggedRecipes) => Some(taggedRecipes->Array.concat([recipeId]))
  }
}

let addTag = (state: state, recipeId: int, tag: string) => {
  let recipeOption = state.recipes->Map.Int.get(recipeId)

  switch recipeOption {
  | None => state
  | Some(recipe) => {
      let recipeTags = recipe.tags->Array.concat([tag])
      let recipes = state.recipes->Map.Int.set(recipe.id, {...recipe, tags: recipeTags})

      let tags =
        state.tags->Map.String.update(tag, taggedRecipesOption =>
          updateTagsArray(taggedRecipesOption, recipe.id)
        )

      {
        nextId: state.nextId,
        recipes: recipes,
        tags: tags,
      }
    }
  }
}

let reducer = (state: state, action: action) => {
  switch action {
  | AddRecipe({title, ingredients, instructions}) =>
    addRecipe(state, title, ingredients, instructions)
  | AddTag({recipeId, tag}) => addTag(state, recipeId, tag)
  }
}
