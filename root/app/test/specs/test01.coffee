describe "test", ->
  beforeEach ->
    jstestdriver.console.log('setup: jasmine beforeach')

  afterEach ->
    jstestdriver.console.log('teardown: jasmine aftereach')

  it "test sample1", ->
    expect("hogehoge").toEqual("hogehoge")

  it "test sample2", ->
    expect("hogehoge").toEqual("hogehoge")

  it "test sample3", ->
    expect("hogehoge").toEqual("hogehoge")

