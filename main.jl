#!/usr/bin/env julia

using ProjectJulia
using ProjectJulia.examples:
    example_one, example_two, example_three, example_four, example_five, example_six
using ProjectJulia.optimizer: optimize_grid


function main()
    # Example 1:
    println("Running Example 1...")
    grid = example_one()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    # Example 2:
    println("Running Example 2...")
    grid = example_two()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    # Example 3:
    println("Running Example 3...")
    grid = example_three()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    # Example 4:
    println("Running Example 4...")
    grid = example_four()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    # Example 5:
    println("Running Example 5...")
    grid = example_five()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)

    # Example 6:
    println("Running Example 6...")
    grid = example_six()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
end

main()
