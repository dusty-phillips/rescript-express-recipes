open Zora

let default: zoraTestBlock = t => {
  t->block("first test", t => {
    t->ok(true, "It should make a test")
  })
}
