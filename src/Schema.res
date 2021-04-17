type t

type recipesRxDbFeedInput = {id: Store.id, minUpdatedAt: float, limit: int}
type taggedRecipesRxDbFeedInput = {tag: Store.tag, minUpdatedAt: float, limit: int}

type recipeInputFields = {
  id: Store.id,
  title: Store.title,
  ingredients: Store.ingredients,
  instructions: Store.instructions,
  tags: array<Store.tag>,
  deleted: bool,
}

type taggedRecipesInputFields = {
  tag: Store.tag,
  recipes: array<Store.id>,
  deleted: bool,
}

type recipeInput = {recipe: recipeInputFields}
type taggedRecipesInput = {taggedRecipes: taggedRecipesInputFields}

type rootValue = {
  recipeRxDbFeed: recipesRxDbFeedInput => array<Store.recipe>,
  taggedRecipesRxDbFeed: taggedRecipesRxDbFeedInput => array<Store.taggedRecipes>,
  setRecipe: recipeInput => Store.recipe,
  setTaggedRecipes: taggedRecipesInput => Store.taggedRecipes,
}

@module("graphql") external buildSchema: string => t = "buildSchema"

@module("graphql")
external graphql: (t, string, rootValue) => Js.Promise.t<'result> = "graphql"

let schema = buildSchema(`
  type Recipe {
    id: String!,
    title: String!,
    ingredients: String!,
    instructions: String!,
    tags: [String]!,
    updatedAt: Float!,
    deleted: Boolean!,

  }

  type TaggedRecipes {
    tag: String!,
    recipes: [String]!,
    updatedAt: Float!,
    deleted: Boolean!,
  }

  type Query {
    recipeRxDbFeed(id: String!, minUpdatedAt: Float!, limit: Int!): [Recipe!]!

    taggedRecipesRxDbFeed(
      tag: String!
      minUpdatedAt: Float!
      limit: Int!
    ): [TaggedRecipes!]!
  }

  input RecipeInput {
    id: String!,
    title: String!,
    ingredients: String!,
    instructions: String!,
    tags: [String]!,
    deleted: Boolean!,
    updatedAt: Float

  }

  input TaggedRecipesInput {
    tag: String!,
    recipes: [String]!,
    deleted: Boolean!,
    updatedAt: Float
  }

  type Mutation {
    setRecipe(recipe: RecipeInput!): Recipe!
    setTaggedRecipes(taggedRecipes: TaggedRecipesInput!): TaggedRecipes!
  }
`)
