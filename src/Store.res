@module("uuid") external uuid: unit => string = "v4"

open Belt

type id = string
type title = string
type ingredients = string
type instructions = string
type tag = string

type recipe = {
  id: id,
  title: title,
  ingredients: ingredients,
  instructions: instructions,
  tags: array<tag>,
}

type state = {
  recipes: Map.String.t<recipe>,
  tags: Map.String.t<array<id>>,
}

let initialState: state = {
  recipes: Map.String.empty,
  tags: Map.String.empty,
}

type action =
  | AddRecipe({title: string, ingredients: string, instructions: string})
  | AddTag({recipeId: id, tag: string})

let addRecipe = (state: state, title: string, ingredients: string, instructions: string) => {
  let id = uuid()
  {
    recipes: state.recipes->Map.String.set(
      id,
      {
        id: id,
        title: title,
        ingredients: ingredients,
        instructions: instructions,
        tags: [],
      },
    ),
    tags: state.tags,
  }
}

let updateTagsArray = (taggedRecipesOption: option<array<id>>, recipeId: id) => {
  switch taggedRecipesOption {
  | None => Some([recipeId])
  | Some(taggedRecipes) => Some(taggedRecipes->Array.concat([recipeId]))
  }
}

let addTag = (state: state, recipeId: id, tag: string) => {
  let recipeOption = state.recipes->Map.String.get(recipeId)

  switch recipeOption {
  | None => state
  | Some(recipe) => {
      let recipeTags = recipe.tags->Array.concat([tag])
      let recipes = state.recipes->Map.String.set(recipe.id, {...recipe, tags: recipeTags})

      let tags =
        state.tags->Map.String.update(tag, taggedRecipesOption =>
          updateTagsArray(taggedRecipesOption, recipe.id)
        )

      {
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

module type UseReducer = {
  let getState: unit => state
  let dispatch: action => unit
}

module Reducer: UseReducer = {
  let currentState = ref(initialState)
  let getState = () => currentState.contents
  let dispatch = (action: action) => {
    currentState.contents = reducer(currentState.contents, action)
  }
}
