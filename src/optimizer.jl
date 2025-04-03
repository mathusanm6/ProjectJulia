module optimizer

using JuMP, HiGHS
import MathOptInterface as MOI

using ..types: Grid

function optimize_grid(grid::Grid)
    model = Model(HiGHS.Optimizer)
    N = grid.size

    # Declare variables
    @variable(model, entry_top[1:N, 1:N], Bin)
    @variable(model, entry_right[1:N, 1:N], Bin)
    @variable(model, entry_bottom[1:N, 1:N], Bin)
    @variable(model, entry_left[1:N, 1:N], Bin)

    @variable(model, exit_top[1:N, 1:N], Bin)
    @variable(model, exit_right[1:N, 1:N], Bin)
    @variable(model, exit_bottom[1:N, 1:N], Bin)
    @variable(model, exit_left[1:N, 1:N], Bin)

    # === Constraints === #

    # Row constraints
    for i in 1:N
        @constraint(model,
            sum(entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j] for j in 1:N)
            ==
            grid.row_constraints[i]
        )
    end

    # Column constraints
    for j in 1:N
        @constraint(model,
            sum(entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j] for i in 1:N)
            ==
            grid.column_constraints[j]
        )
    end

    # Only one entry/exit per cell
    for i in 1:N, j in 1:N
        @constraint(model, entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j] <= 1)
        @constraint(model, exit_top[i, j] + exit_right[i, j] + exit_bottom[i, j] + exit_left[i, j] <= 1)
    end

    # Entry and exit can't be on the same side
    for i in 1:N, j in 1:N
        @constraint(model, entry_top[i, j] + exit_top[i, j] <= 1)
        @constraint(model, entry_right[i, j] + exit_right[i, j] <= 1)
        @constraint(model, entry_bottom[i, j] + exit_bottom[i, j] <= 1)
        @constraint(model, entry_left[i, j] + exit_left[i, j] <= 1)
    end

    # If there is an entry, there must be an exit and vice versa
    for i in 1:N, j in 1:N
        @constraint(model, (entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j]) <=
            (exit_top[i, j] + exit_right[i, j] + exit_bottom[i, j] + exit_left[i, j])
        )
        @constraint(model, (exit_top[i, j] + exit_right[i, j] + exit_bottom[i, j] + exit_left[i, j]) <=
            (entry_top[i, j] + entry_right[i, j] + entry_bottom[i, j] + entry_left[i, j])
        )
    end

    # Objective: feasibility
    @objective(model, Min, 0)

    optimize!(model)

    # Print solution values
    println("Solution values:")
    for i in 1:N, j in 1:N
        println("Cell ($i, $j):")
        println("  Entry: top=$(value(entry_top[i, j])), right=$(value(entry_right[i, j])), bottom=$(value(entry_bottom[i, j])), left=$(value(entry_left[i, j]))")
        println("  Exit: top=$(value(exit_top[i, j])), right=$(value(exit_right[i, j])), bottom=$(value(exit_bottom[i, j])), left=$(value(exit_left[i, j]))")
    end

    # === Apply solution to grid === #
    for i in 1:N, j in 1:N
        cell = grid.circuit.grid[i, j]

        cell.entry.top = value(entry_top[i, j]) > 0.5
        cell.entry.right = value(entry_right[i, j]) > 0.5
        cell.entry.bottom = value(entry_bottom[i, j]) > 0.5
        cell.entry.left = value(entry_left[i, j]) > 0.5

        cell.exit.top = value(exit_top[i, j]) > 0.5
        cell.exit.right = value(exit_right[i, j]) > 0.5
        cell.exit.bottom = value(exit_bottom[i, j]) > 0.5
        cell.exit.left = value(exit_left[i, j]) > 0.5
    end

    return grid
end

end # module optimizer