open Express

let app = express()
let port = 3000

App.get(
  app,
  ~path="/",
  Middleware.from((_, _, res) => {
    res->Response.status(Response.StatusCode.Ok)->Response.sendString("Hello World")
  }),
)

let server = App.listen(
  app,
  ~port,
  ~onListen=_ => {
    Js.log(`Example app listening at http://localhost:${Js.Int.toString(port)}`)
  },
  (),
)
