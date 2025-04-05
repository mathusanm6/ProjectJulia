module types

import Base: show

mutable struct Port
    top::Bool
    right::Bool
    bottom::Bool
    left::Bool
end

mutable struct Cell
    entry::Port
    exit::Port
end

mutable struct Circuit
    grid::Array{Cell,2}

    function Circuit(matrix_size::Int)
        grid = Array{Cell,2}(undef, matrix_size, matrix_size)
        for i = 1:matrix_size, j = 1:matrix_size
            grid[i, j] = Cell(Port(0, 0, 0, 0), Port(0, 0, 0, 0))
        end
        new(grid)
    end
end

mutable struct Grid
    size::Int
    circuit::Circuit
    row_constraints::Vector{Int}
    column_constraints::Vector{Int}

    function Grid(
        size::Int64,
        circuit::Circuit,
        row_constraints::Vector{Int},
        column_constraints::Vector{Int},
    )
        new(size, circuit, row_constraints, column_constraints)
    end
end

function generate_next_constraints(size::Int, prev_constraints::Vector{Int})
    for i in 1:size
        if prev_constraints[i] < size
            prev_constraints[i] += 1
            for j in 1:i-1
                prev_constraints[j] = 0
            end
            return prev_constraints
        end
    end
    return nothing
end

function show(io::IO, ::MIME"text/plain", grid::Grid)
    n = grid.size
    rows = grid.row_constraints
    cols = grid.column_constraints
    circuit = grid.circuit

    # Print top: column constraints
    print(io, "Solution :\n     ")
    for col in cols
        print(io, "  $col  ")
    end
    print(io, "\n")

    # For each row
    for i = 1:n
        # Top border of cells
        print(io, "     ")
        for _ = 1:n
            print(io, "+---+")
        end
        print(io, "\n")

        # Print row constraint
        print(io, "     ")

        # Print cells (top)
        for j = 1:n
            cell = circuit.grid[i, j]
            if cell.entry.top || cell.exit.top
                print(io, "| * |")
            else
                print(io, "|   |")
            end
        end
        print(io, "\n")

        # Print row constraint
        print(io, "  $(rows[i])  ")

        # Print cells (middle)
        for j = 1:n
            cell = circuit.grid[i, j]
            if (cell.entry.right && cell.exit.left) || (cell.entry.left && cell.exit.right)
                print(io, "|***|")
            elseif (cell.entry.top && cell.exit.bottom) ||
                   (cell.entry.bottom && cell.exit.top)
                print(io, "| * |")
            elseif cell.entry.right || cell.exit.right
                print(io, "| **|")
            elseif cell.exit.left || cell.entry.left
                print(io, "|** |")
            else
                print(io, "|   |")
            end
        end
        print(io, "\n")

        # Print row constraint
        print(io, "     ")

        # Print cells (bottom)
        for j = 1:n
            cell = circuit.grid[i, j]
            if cell.entry.bottom || cell.exit.bottom
                print(io, "| * |")
            else
                print(io, "|   |")
            end
        end
        print(io, "\n")
    end

    # Bottom border
    print(io, "     ")
    for _ = 1:n
        print(io, "+---+")
    end
    print(io, "\n")
end

export Port, Cell, Circuit, Grid
export generate_next_constraints

end # module types
