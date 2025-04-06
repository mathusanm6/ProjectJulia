#!/usr/bin/env julia

using ProjectJulia
using ProjectJulia.examples:
    example_one, example_two, example_three, example_four, example_five, example_six
using ProjectJulia.optimizer: optimize_grid
using ProjectJulia.validator: check_valid_grid
using ProjectJulia.generator: generate_random_solvable_grid, generate_all_solvable_grids

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

function run_generation_all(size::Int)
    println("Generating Solvable Grids...")
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

function run_random_generation(size::Int, seed::Union{Nothing,Int}=nothing)
    println("Generating Random Solvable Grid...")
    original_grid, solved_grid = generate_random_solvable_grid(size, seed)
    println("Original Grid:")
    display(original_grid)
    println("Solved Grid:")
    display(solved_grid)
    println("Is the solved grid valid? ", check_valid_grid(solved_grid))
    println("=========================")
end


function parse_int(arg::String, label::String)
    try
        return parse(Int, arg)
    catch
        error("Invalid $label: '$arg'. Please provide a valid integer.")
    end
end

function main()
    if isempty(ARGS)
        println("Usage:")
        println("  julia --project=. main.jl examples")
        println("  julia --project=. main.jl generate all <size>")
        println("  julia --project=. main.jl generate random <size> [seed]")
        return
    end

    command = ARGS[1]

    if command == "examples"
        if length(ARGS) > 1
            error("Usage: examples")
        end

        println("Running Examples...")
        run_examples()

    elseif command == "generate"
        if length(ARGS) < 3
            error("Usage: generate all <size> OR generate random <size> [seed]")
        end

        subcommand = ARGS[2]

        if subcommand == "all"
            size = parse_int(ARGS[3], "size")
            run_generation_all(size)

        elseif subcommand == "random"
            size = parse_int(ARGS[3], "size")
            seed = length(ARGS) >= 4 ? parse_int(ARGS[4], "seed") : nothing
            run_random_generation(size, seed)

        else
            error("Unknown generate option: '$subcommand'. Expected 'all' or 'random'.")
        end

    else
        error("Unknown command: '$command'.")
    end
end

main()
