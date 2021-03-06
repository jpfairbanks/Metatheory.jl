# ENV["JULIA_DEBUG"] = Metatheory

fibo = @theory begin
    x::Int + y::Int |> x+y
    fib(n::Int) |> (n < 2 ? n : :(fib($(n-1)) + fib($(n-2))))
end

g = EGraph(:(fib(10)))
@time saturate!(g, fibo; timeout=60)

z = EGraph(:(fib(10)))
@time saturate!(z, fibo; timeout=60)

extran = addanalysis!(g, ExtractionAnalysis, astsize)
display(g.M); println()

@testset "Fibonacci" begin
    @test 55 == extract!(g, extran)
end
