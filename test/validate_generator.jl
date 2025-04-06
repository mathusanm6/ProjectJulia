using Test

using ProjectJulia

using ProjectJulia.validator: check_valid_grid
using ProjectJulia.generator: generate_all_solvable_grids

@testset "Generate Solvable Grid Test" begin
    # Test the generation of solvable grids of size 3
    grids = generate_all_solvable_grids(3)

    println("Generated ", length(grids), " solvable grids of size 3.")
    for (original_grid, solved_grid) in grids
        println("Original Grid:")
        display(original_grid)

        println("Solved Grid:")
        display(solved_grid)

        println("Is the solved grid valid? ", check_valid_grid(solved_grid))
        println()
        @test check_valid_grid(solved_grid) == true
    end
end
