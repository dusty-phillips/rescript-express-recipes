// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Store = require("./Store.bs.js");
var Express = require("bs-express/src/Express.bs.js");
var Js_dict = require("bs-platform/lib/js/js_dict.js");
var Js_json = require("bs-platform/lib/js/js_json.js");
var Belt_Int = require("bs-platform/lib/js/belt_Int.js");
var Belt_MapInt = require("bs-platform/lib/js/belt_MapInt.js");
var Belt_Option = require("bs-platform/lib/js/belt_Option.js");
var Caml_option = require("bs-platform/lib/js/caml_option.js");

var app = Express.express(undefined);

Express.App.use(app, Express.Middleware.json(undefined, undefined, undefined, undefined));

Express.App.get(app, "/", Express.Middleware.from(function (param, param$1, res) {
          var result = {};
          result["Hello"] = "World";
          return Express.$$Response.status(res, /* Ok */0).json(result);
        }));

Express.App.post(app, "/addRecipe", Express.Middleware.from(function (_next, req, res) {
          var jsonResponse = {};
          var jsonFields = Belt_Option.map(Belt_Option.flatMap(Caml_option.nullable_to_opt(req.body), Js_json.decodeObject), (function (jsonBody) {
                  return [
                          Belt_Option.flatMap(Js_dict.get(jsonBody, "title"), Js_json.decodeString),
                          Belt_Option.flatMap(Js_dict.get(jsonBody, "ingredients"), Js_json.decodeString),
                          Belt_Option.flatMap(Js_dict.get(jsonBody, "instructions"), Js_json.decodeString)
                        ];
                }));
          var exit = 0;
          if (jsonFields !== undefined) {
            var title = jsonFields[0];
            if (title !== undefined) {
              var ingredients = jsonFields[1];
              if (ingredients !== undefined) {
                var instructions = jsonFields[2];
                if (instructions !== undefined) {
                  var state = Store.Reducer.getState(undefined);
                  var id = state.nextId;
                  Store.Reducer.dispatch({
                        TAG: /* AddRecipe */0,
                        title: title,
                        ingredients: ingredients,
                        instructions: instructions
                      });
                  jsonResponse["id"] = id;
                } else {
                  exit = 1;
                }
              } else {
                exit = 1;
              }
            } else {
              exit = 1;
            }
          } else {
            exit = 1;
          }
          if (exit === 1) {
            jsonResponse["error"] = "missing attribute";
          }
          return res.json(jsonResponse);
        }));

Express.App.get(app, "/recipes/:id", Express.Middleware.from(function (_next, req, res) {
          var jsonResponse = {};
          var state = Store.Reducer.getState(undefined);
          var recipeOption = Belt_Option.flatMap(Belt_Option.flatMap(Belt_Option.flatMap(Js_dict.get(req.params, "id"), Js_json.decodeString), Belt_Int.fromString), (function (id) {
                  return Belt_MapInt.get(state.recipes, id);
                }));
          if (recipeOption !== undefined) {
            jsonResponse["id"] = recipeOption.id;
            jsonResponse["title"] = recipeOption.title;
            jsonResponse["ingredients"] = recipeOption.ingredients;
            jsonResponse["instructions"] = recipeOption.instructions;
          } else {
            jsonResponse["error"] = "unable to find that recipe";
          }
          return res.json(jsonResponse);
        }));

var server = Express.App.listen(app, 3000, undefined, (function (param) {
        console.log("Example app listening at http://localhost:" + (3000).toString());
        
      }), undefined);

var port = 3000;

exports.app = app;
exports.port = port;
exports.server = server;
/* app Not a pure module */
