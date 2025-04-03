using Test
using ProjectJulia

using ProjectJulia.examples:
    example_one, example_two, example_three, example_four, example_five, example_six
using ProjectJulia.optimizer: optimize_grid
using ProjectJulia.validator: check_valid_grid

@testset "Optimizer Test Example One" begin
    grid = example_one()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
    @test check_valid_grid(optimized_grid) == true
end

@testset "Optimizer Test Example Two" begin
    grid = example_two()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
    @test check_valid_grid(optimized_grid) == true
end

@testset "Optimizer Test Example Three" begin
    grid = example_three()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
    @test check_valid_grid(optimized_grid) == true
end

@testset "Optimizer Test Example Four" begin
    grid = example_four()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
    @test check_valid_grid(optimized_grid) == true
end

@testset "Optimizer Test Example Five" begin
    grid = example_five()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
    @test check_valid_grid(optimized_grid) == true
end

@testset "Optimizer Test Example Six" begin
    grid = example_six()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
    @test check_valid_grid(optimized_grid) == true
end
