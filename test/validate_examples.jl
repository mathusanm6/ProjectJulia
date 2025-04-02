using Test
using ProjectJulia

@testset "Example Grid Valid" begin
    grid = example_grid_valid()
    @test check_valid_grid(grid) == true
end

@testset "Example Grid Invalid" begin
    grid = example_grid_invalid()
    @test check_valid_grid(grid) == false
end