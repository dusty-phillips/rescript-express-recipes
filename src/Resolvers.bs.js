// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Store = require("./Store.bs.js");
var Belt_Array = require("bs-platform/lib/js/belt_Array.js");
var Belt_MapString = require("bs-platform/lib/js/belt_MapString.js");
var Belt_SortArray = require("bs-platform/lib/js/belt_SortArray.js");

function recipeRxDbFeed(param) {
  var minUpdatedAt = param.minUpdatedAt;
  var id = param.id;
  return Belt_Array.slice(Belt_SortArray.stableSortBy(Belt_Array.keep(Belt_MapString.valuesToArray(Store.Reducer.getState(undefined).recipes), (function (r) {
                        if (r.updatedAt === minUpdatedAt) {
                          return r.id > id;
                        } else {
                          return r.updatedAt > minUpdatedAt;
                        }
                      })), (function (r1, r2) {
                    if (r1.updatedAt > r2.updatedAt) {
                      return 1;
                    } else if (r1.updatedAt < r2.updatedAt) {
                      return -1;
                    } else if (r1.id > r2.id) {
                      return 1;
                    } else if (r1.id < r2.id) {
                      return -1;
                    } else {
                      return 0;
                    }
                  })), 0, param.limit);
}

function taggedRecipesRxDbFeed(param) {
  var minUpdatedAt = param.minUpdatedAt;
  var tag = param.tag;
  return Belt_Array.slice(Belt_SortArray.stableSortBy(Belt_Array.keep(Belt_MapString.valuesToArray(Store.Reducer.getState(undefined).tags), (function (r) {
                        if (r.updatedAt === minUpdatedAt) {
                          return r.tag > tag;
                        } else {
                          return r.updatedAt > minUpdatedAt;
                        }
                      })), (function (r1, r2) {
                    if (r1.updatedAt > r2.updatedAt) {
                      return 1;
                    } else if (r1.updatedAt < r2.updatedAt) {
                      return -1;
                    } else if (r1.tag > r2.tag) {
                      return 1;
                    } else if (r1.tag < r2.tag) {
                      return -1;
                    } else {
                      return 0;
                    }
                  })), 0, param.limit);
}

function setRecipe(param) {
  var recipe = param.recipe;
  var result_id = recipe.id;
  var result_title = recipe.title;
  var result_ingredients = recipe.ingredients;
  var result_instructions = recipe.instructions;
  var result_tags = recipe.tags;
  var result_updatedAt = Date.now();
  var result_deleted = recipe.deleted;
  var result = {
    id: result_id,
    title: result_title,
    ingredients: result_ingredients,
    instructions: result_instructions,
    tags: result_tags,
    updatedAt: result_updatedAt,
    deleted: result_deleted
  };
  Store.Reducer.dispatch({
        TAG: /* SetRecipe */2,
        _0: result
      });
  return result;
}

function setTaggedRecipes(param) {
  var taggedRecipes = param.taggedRecipes;
  return {
          tag: taggedRecipes.tag,
          recipes: taggedRecipes.recipes,
          updatedAt: Date.now(),
          deleted: taggedRecipes.deleted
        };
}

var rootValue = {
  recipeRxDbFeed: recipeRxDbFeed,
  taggedRecipesRxDbFeed: taggedRecipesRxDbFeed,
  setRecipe: setRecipe,
  setTaggedRecipes: setTaggedRecipes
};

exports.recipeRxDbFeed = recipeRxDbFeed;
exports.taggedRecipesRxDbFeed = taggedRecipesRxDbFeed;
exports.setRecipe = setRecipe;
exports.setTaggedRecipes = setTaggedRecipes;
exports.rootValue = rootValue;
/* No side effect */
