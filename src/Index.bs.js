// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Express = require("bs-express/src/Express.bs.js");

var app = Express.express(undefined);

Express.App.get(app, "/", Express.Middleware.from(function (param, param$1, res) {
          return Express.$$Response.status(res, /* Ok */0).send("Hello World");
        }));

var server = Express.App.listen(app, 3000, undefined, (function (param) {
        console.log("Example app listening at http://localhost:" + (3000).toString());
        
      }), undefined);

var port = 3000;

exports.app = app;
exports.port = port;
exports.server = server;
/* app Not a pure module */
