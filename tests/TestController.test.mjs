// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Zora from "zora";
import * as Store from "../src/Store.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Controller from "../src/Controller.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

Zora.test("Test endpoints", (function (t) {
        t.test("The Happy Path", (function (t) {
                var body = Caml_option.some(JSON.parse("\n      {\n        \"title\": \"Bread\",\n        \"ingredients\": \"Flour and Water\",\n        \"instructions\": \"Mix and Bake\"\n      }\n    "));
                var result = Controller.addRecipe(body);
                var id = Js_json.decodeString(Js_dict.get(Js_json.decodeObject(result), "id"));
                t.equal(id.length, 36, "The id should be the length of a uuid");
                var params = {};
                params["id"] = id;
                var result$1 = Controller.getRecipe(params);
                var json = JSON.stringify(result$1);
                var expected = "{\"id\":\"" + id + "\",\"title\":\"Bread\",\"ingredients\":\"Flour and Water\",\"instructions\":\"Mix and Bake\",\"tags\":[]}";
                t.equal(json, expected, "get recipe should match input");
                var body$1 = Caml_option.some(JSON.parse("\n        {\n          \"recipeId\": \"" + id + "\",\n          \"tag\": \"Carbs\"\n        }\n        "));
                var result$2 = Controller.addTagToRecipe(body$1);
                var json$1 = JSON.stringify(result$2);
                t.equal(json$1, "{\"success\":true}", "addTagToRecipe should return success");
                var result$3 = Controller.getRecipe(params);
                var json$2 = JSON.stringify(result$3);
                var expected$1 = "{\"id\":\"" + id + "\",\"title\":\"Bread\",\"ingredients\":\"Flour and Water\",\"instructions\":\"Mix and Bake\",\"tags\":[\"Carbs\"]}";
                t.equal(json$2, expected$1, "get recipe should match input");
                var params$1 = {};
                params$1["tag"] = "Carbs";
                var result$4 = Controller.getTag(params$1);
                var json$3 = JSON.stringify(result$4);
                var expected$2 = "{\"recipes\":[{\"id\":\"" + id + "\",\"title\":\"Bread\"}]}";
                t.equal(json$3, expected$2, "tag should now have recipes");
                
              }));
        Store.Reducer.dangerousResetState(undefined);
        t.test("addRecipe missing attribute", (function (t) {
                var body = Caml_option.some(JSON.parse("{}"));
                var result = Controller.addRecipe(body);
                var json = JSON.stringify(result);
                t.equal(json, "{\"error\":\"missing attribute\"}", "There should be missing attributes");
                console.log(json);
                
              }));
        t.test("can't add tag to nonexistent recipe", (function (t) {
                var body = Caml_option.some(JSON.parse("\n        {\n          \"recipeId\": \"Not a Recipe\",\n          \"tag\": \"Carbs\"\n        }\n        "));
                var result = Controller.addTagToRecipe(body);
                var json = JSON.stringify(result);
                t.equal(json, "{\"error\":\"invalid request\"}", "addTagToRecipe should return success");
                
              }));
        t.test("Can't get recipe that doesn't exist", (function (t) {
                var params = {};
                params["id"] = "Not a Recipe";
                var result = Controller.getRecipe(params);
                var json = JSON.stringify(result);
                t.equal(json, "{\"error\":\"unable to find that recipe\"}", "get recipe should match input");
                
              }));
        
      }));

export {
  
}
/*  Not a pure module */