#!/usr/bin/env julia

using ProjectJulia
using ProjectJulia.examples:
    example_one, example_two, example_three, example_four, example_five, example_six
using ProjectJulia.optimizer: optimize_grid
using ProjectJulia.validator: check_valid_grid
using ProjectJulia.generator: generate_all_solvable_grids

function run_examples()
    # Example 1:
    println("Running Example 1...")
    grid = example_one()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    println("==========================")

    # Example 2:
    println("Running Example 2...")
    grid = example_two()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    println("==========================")

    # Example 3:
    println("Running Example 3...")
    grid = example_three()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    println("==========================")

    # Example 4:
    println("Running Example 4...")
    grid = example_four()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    println("==========================")

    # Example 5:
    println("Running Example 5...")
    grid = example_five()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    println("==========================")

    # Example 6:
    println("Running Example 6...")
    grid = example_six()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
end

function run_generation(size::Int)
   grids = generate_all_solvable_grids(size)
    
   println("Generated ", length(grids), " solvable grids of size 3.")
   for (original_grid, solved_grid) in grids
       println("Original Grid:")
       display(original_grid)
       
       println("Solved Grid:")
       display(solved_grid)

       println("Is the solved grid valid? ", check_valid_grid(solved_grid))
       println()
   end
   println("=========================") 
end


function main()

    # println("Running Examples...")
    # run_examples()        # <--- Uncomment to run examples

    # Extension : Generate all solvable grids of given size
    println("Generating Solvable Grids...")
    run_generation(3)       # <--- Change the size as needed (3: 7s, 4: 9 min)
end

main()
