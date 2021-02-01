// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Belt_Array = require("bs-platform/lib/js/belt_Array.js");
var Belt_MapString = require("bs-platform/lib/js/belt_MapString.js");

var initialState = {
  recipes: undefined,
  tags: undefined
};

function addRecipe(state, title, ingredients, instructions) {
  return {
          recipes: Belt_MapString.set(state.recipes, title, {
                title: title,
                ingredients: ingredients,
                instructions: instructions,
                tags: []
              }),
          tags: state.tags
        };
}

function updateTagsArray(taggedRecipesOption, recipeTitle) {
  if (taggedRecipesOption !== undefined) {
    return Belt_Array.concat(taggedRecipesOption, [recipeTitle]);
  } else {
    return [recipeTitle];
  }
}

function addTag(state, recipeTitle, tag) {
  var recipeOption = Belt_MapString.get(state.recipes, recipeTitle);
  if (recipeOption === undefined) {
    return state;
  }
  var recipeTags = Belt_Array.concat(recipeOption.tags, [tag]);
  var recipes = Belt_MapString.set(state.recipes, recipeOption.title, {
        title: recipeOption.title,
        ingredients: recipeOption.ingredients,
        instructions: recipeOption.instructions,
        tags: recipeTags
      });
  var tags = Belt_MapString.update(state.tags, tag, (function (taggedRecipesOption) {
          return updateTagsArray(taggedRecipesOption, recipeOption.title);
        }));
  return {
          recipes: recipes,
          tags: tags
        };
}

function reducer(state, action) {
  if (action.TAG === /* AddRecipe */0) {
    return addRecipe(state, action.title, action.ingredients, action.instructions);
  } else {
    return addTag(state, action.recipeTitle, action.tag);
  }
}

exports.initialState = initialState;
exports.addRecipe = addRecipe;
exports.updateTagsArray = updateTagsArray;
exports.addTag = addTag;
exports.reducer = reducer;
/* No side effect */
