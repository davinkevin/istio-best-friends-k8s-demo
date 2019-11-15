
@Component
class MainHandler(val foo: FooService, val bar: BarService) {

    fun para(request: ServerRequest) = foo
            .fetch()
            .zipWith(bar.fetch())
            .flatMap { ok().syncBody(HelloMessage("BDX.io 2019", "parallel")) }

    fun seq(request: ServerRequest) = foo
            .fetch()
            .flatMap { bar.fetch() }
            .flatMap { ok().syncBody(HelloMessage("BDX.io 2019", "sequential")) }
}
