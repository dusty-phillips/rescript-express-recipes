open Zora

zoraBlock("testing_works", t => {
  t->test("testing works", t => {
    t->ok(true, "I told you it works")
    done()
  })
  t->test("testing still works", t => {
    t->ok(true, "I told you it works")
    done()
  })
})
