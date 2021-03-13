type t

type greetByNameArgs = {name: string}

type rootValue = {
  hello: unit => string,
  greetByName: greetByNameArgs => string,
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
      minUpdatedAt: Int!
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

  }

  input TaggedRecipesInput {
    tag: String!,
    recipes: [String]!,
    deleted: Boolean!,
  }

  type Mutation {
    setRecipe(recipe: RecipeInput!): Recipe!
    setTaggedRecipes(taggedRecipes: TaggedRecipesInput!): TaggedRecipes!
  }
`)
