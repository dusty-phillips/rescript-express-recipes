let hello = () => {
  "hello world"
}

let greetByName = ({name}: Schema.greetByNameArgs) => {
  return`Hello ${name}`
}

let rootValue: Schema.rootValue = {
  hello: hello,
  greetByName: greetByName,
}
