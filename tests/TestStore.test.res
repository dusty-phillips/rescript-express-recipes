open Zora

let default: zoraTestBlock = t => {
  t->block("testing works", t => {
    t->ok(true, "I told you it works")
  })
}
