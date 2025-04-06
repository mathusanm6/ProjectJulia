module generator

using Random

using ..types: Grid, Circuit
using ..types: generate_next_constraints
using ..optimizer: optimize_grid
using ..validator: check_valid_grid


"""
    generate_random_solvable_grid(size::Int)

Generates a random solvable grid of a given size.

Returns a tuple containing the original grid and the solved grid.
"""
function generate_random_solvable_grid(size::Int, seed::Union{Nothing,Int}=nothing)
    if !isnothing(seed)
        Random.seed!(seed)
    end

    while true
        row_constraints = rand(0:size, size)
        column_constraints = rand(0:size, size)
        circuit = Circuit(size)
        grid = Grid(size, circuit, copy(row_constraints), copy(column_constraints))
        optimized_grid = optimize_grid(deepcopy(grid))
        if !isnothing(optimized_grid) && check_valid_grid(optimized_grid)
            return (grid, optimized_grid)
        end
        # If the grid is not solvable, generate a new one
        # Until we find a solvable grid
    end
end

"""
    generate_all_solvable_grids(size::Int)

Generates all possible solvable grids of a given size.

Returns a list of tuples, where each tuple contains the original grid and the solved grid.
"""
function generate_all_solvable_grids(size::Int)
    grids = Vector{Tuple{Grid,Grid}}()

    row_constraints = fill(0, size)
    while true
        column_constraints = fill(0, size)
        while true
            circuit = Circuit(size)
            grid = Grid(size, circuit, copy(row_constraints), copy(column_constraints))

            optimized_grid = optimize_grid(deepcopy(grid))

            if !isnothing(optimized_grid) && check_valid_grid(optimized_grid)
                push!(grids, (grid, optimized_grid))
            end

            column_constraints = generate_next_constraints(size, column_constraints)
            if isnothing(column_constraints)
                break
            end
        end

        row_constraints = generate_next_constraints(size, row_constraints)
        if isnothing(row_constraints)
            break
        end
    end

    return grids
end

export generate_random_solvable_grid, generate_all_solvable_grids

end # module generator