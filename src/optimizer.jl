module optimizer

using JuMP, HiGHS
import MathOptInterface as MOI

using ..types: Grid, Circuit, Cell, Port

"""
    apply_solution!(grid, entry_top, entry_right, entry_bottom, entry_left, exit_top, exit_right, exit_bottom, exit_left)

Applies the solution from the optimization model to the grid.
Float values are rounded to the nearest integer (0 or 1) to determine the entry and exit directions for each cell.
"""
function apply_solution!(
    grid,
    entry_top,
    entry_right,
    entry_bottom,
    entry_left,
    exit_top,
    exit_right,
    exit_bottom,
    exit_left,
)
    for i = 1:grid.size, j = 1:grid.size
        cell = grid.circuit.grid[i, j]
        cell.entry.top = round(Int, value(entry_top[i, j])) == 1
        cell.entry.right = round(Int, value(entry_right[i, j])) == 1
        cell.entry.bottom = round(Int, value(entry_bottom[i, j])) == 1
        cell.entry.left = round(Int, value(entry_left[i, j])) == 1

        cell.exit.top = round(Int, value(exit_top[i, j])) == 1
        cell.exit.right = round(Int, value(exit_right[i, j])) == 1
        cell.exit.bottom = round(Int, value(exit_bottom[i, j])) == 1
        cell.exit.left = round(Int, value(exit_left[i, j])) == 1
    end
end


"""
    detect_all_sub_loops(circuit::Circuit)

Detects all sub-loops in a given circuit.

Returns a list of loops, where each loop is represented as a vector of tuples `(i, j)` 
indicating the coordinates of the cells in the loop.
"""
function detect_all_sub_loops(circuit::Circuit)
    loops = []
    seen_signatures = Set{Vector{Tuple{Int,Int}}}()
    n = size(circuit.grid, 1)

    directions =
        Dict(:top => (-1, 0), :bottom => (1, 0), :left => (0, -1), :right => (0, 1))

    opposites = Dict(:top => :bottom, :bottom => :top, :left => :right, :right => :left)

    function rotate_to_min_start(path)
        min_idx = argmin(path)
        return vcat(path[min_idx:end], path[1:min_idx-1])
    end

    function dfs(i, j, path, visited, from_dir = nothing)
        cell = circuit.grid[i, j]
        push!(path, (i, j))
        push!(visited, (i, j))

        for dir in keys(directions)
            if dir == from_dir
                continue
            end

            if getproperty(cell.exit, dir)
                di, dj = directions[dir]
                ni, nj = i + di, j + dj

                if 1 <= ni <= n && 1 <= nj <= n
                    neighbor = circuit.grid[ni, nj]
                    if getproperty(neighbor.entry, opposites[dir])
                        if (ni, nj) in path
                            loop_start = findfirst(x -> x == (ni, nj), path)
                            loop = path[loop_start:end]
                            norm_loop = rotate_to_min_start(loop)
                            if !(norm_loop in seen_signatures)
                                push!(loops, norm_loop)
                                push!(seen_signatures, norm_loop)
                            end
                            continue
                        end
                        dfs(ni, nj, path, visited, opposites[dir])
                    end
                end
            end
        end

        pop!(path)
        delete!(visited, (i, j))
    end

    for i = 1:n, j = 1:n
        cell = circuit.grid[i, j]
        if cell.exit.top || cell.exit.right || cell.exit.bottom || cell.exit.left
            dfs(i, j, [], Set{Tuple{Int,Int}}())
        end
    end

    return loops
end

"""
    optimize_grid(grid::Grid)
    
Optimizes the given grid using a mixed-integer programming model.

Returns the optimized grid with entry and exit directions for each cell.
"""
function optimize_grid(grid::Grid, remove_sub_loops = true)
    model = Model(HiGHS.Optimizer)
    N = grid.size

    # Define binary decision variables for entry and exit directions at each cell
    @variable(model, entry_top[1:N, 1:N], Bin)
    @variable(model, entry_right[1:N, 1:N], Bin)
    @variable(model, entry_bottom[1:N, 1:N], Bin)
    @variable(model, entry_left[1:N, 1:N], Bin)
    @variable(model, exit_top[1:N, 1:N], Bin)
    @variable(model, exit_right[1:N, 1:N], Bin)
    @variable(model, exit_bottom[1:N, 1:N], Bin)
    @variable(model, exit_left[1:N, 1:N], Bin)

    ## == Constraints == ##

    # Ensure each row has the specified number of non-empty cells
    for i = 1:N
        @constraint(
            model,
            sum(
                entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j]
                for j = 1:N
            ) == grid.row_constraints[i]
        )
    end

    # Ensure each column has the specified number of non-empty cells
    for j = 1:N
        @constraint(
            model,
            sum(
                entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j]
                for i = 1:N
            ) == grid.column_constraints[j]
        )
    end


    for i = 1:N, j = 1:N
        # A cell can have at most one entry direction
        @constraint(
            model,
            entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j] <=
            1
        )

        # A cell can have at most one exit direction
        @constraint(
            model,
            exit_top[i, j] + exit_right[i, j] + exit_bottom[i, j] + exit_left[i, j] <= 1
        )

        # Entry and exit cannot be in the same direction at a cell
        @constraint(model, entry_top[i, j] + exit_top[i, j] <= 1)
        @constraint(model, entry_right[i, j] + exit_right[i, j] <= 1)
        @constraint(model, entry_bottom[i, j] + exit_bottom[i, j] <= 1)
        @constraint(model, entry_left[i, j] + exit_left[i, j] <= 1)

        # A cell must have an equal number of entry and exit directions (0 or 1)
        @constraint(
            model,
            entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j] ==
            exit_top[i, j] + exit_right[i, j] + exit_bottom[i, j] + exit_left[i, j]
        )
    end

    for i = 1:N, j = 1:N
        # Enforce connectivity between adjacent cells:
        # A top exit in cell (i, j) must match the bottom entry in (i-1, j)
        if i > 1
            @constraint(model, exit_top[i, j] == entry_bottom[i-1, j])
        else
            # No top neighbor — no top exit
            @constraint(model, exit_top[i, j] == 0)
        end

        # A right exit in cell (i, j) must match the left entry in (i, j+1)
        if j < N
            @constraint(model, exit_right[i, j] == entry_left[i, j+1])
        else
            # No right neighbor — no right exit
            @constraint(model, exit_right[i, j] == 0)
        end

        # A bottom exit in cell (i, j) must match the top entry in (i+1, j)
        if i < N
            @constraint(model, exit_bottom[i, j] == entry_top[i+1, j])
        else
            # No bottom neighbor — no bottom exit
            @constraint(model, exit_bottom[i, j] == 0)
        end

        # A left exit in cell (i, j) must match the right entry in (i, j-1)
        if j > 1
            @constraint(model, exit_left[i, j] == entry_right[i, j-1])
        else
            # No left neighbor — no left exit
            @constraint(model, exit_left[i, j] == 0)
        end
    end

    # Dummy objective since we are solving a feasibility problem
    @objective(model, Min, 0)

    set_silent(model)

    optimize!(model)
    apply_solution!(
        grid,
        entry_top,
        entry_right,
        entry_bottom,
        entry_left,
        exit_top,
        exit_right,
        exit_bottom,
        exit_left,
    )

    if termination_status(model) == MOI.OPTIMAL
        while remove_sub_loops
            sub_loops = detect_all_sub_loops(grid.circuit)
            if isempty(sub_loops)
                println("No sub-loops detected.")
                break
            end

            # # Add a constraint to break the first detected sub-loop
            loop = sub_loops[1]
            @constraint(
                model,
                sum(
                    entry_top[i, j] +
                    entry_right[i, j] +
                    entry_bottom[i, j] +
                    entry_left[i, j] +
                    exit_top[i, j] +
                    exit_right[i, j] +
                    exit_bottom[i, j] +
                    exit_left[i, j] for (i, j) in loop
                ) <= 2 * length(loop) - 1
            )

            optimize!(model)

            if termination_status(model) != MOI.OPTIMAL
                break
            end

            apply_solution!(
                grid,
                entry_top,
                entry_right,
                entry_bottom,
                entry_left,
                exit_top,
                exit_right,
                exit_bottom,
                exit_left,
            )
        end
    end

    return grid
end

export optimize_grid

end # module optimizer
