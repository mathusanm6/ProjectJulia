module types

"""
    The Port struct represents a connection point in the circuit grid.
    Each port has four sides (top, right, bottom, left) that can connect to neighboring cells.
    Each side is represented as an instance of the Bin struct, which contains a reference to the neighboring cell.
    Only one side can be connected at a time (at true), and the others are false.
"""
mutable struct Port
    top::Bool
    right::Bool
    bottom::Bool
    left::Bool
end

"""
    The Cell struct represents a cell in the circuit grid.
    Each cell has an entry and exit port, which are used to connect to other cells.
    The entry port is the point where a signal enters the cell, and the exit port is where it leaves.
    The ports are represented as instances of the Port struct, which contains references to the neighboring cells.
"""
mutable struct Cell
    entry::Port
    exit::Port
end

"""
    The Circuit struct represents a grid of cells, each with entry and exit ports.
    It is used to model the layout of a circuit in a 2D space.
"""
mutable struct Circuit
    grid::Array{Cell, 2}
    
    function Circuit(matrix_size::Int)
        grid = Array{Cell, 2}(undef, matrix_size, matrix_size)
        for i in 1:matrix_size, j in 1:matrix_size
            grid[i, j] = Cell(Port(0, 0, 0, 0), Port(0, 0, 0, 0))
        end
        new(grid)
    end
end

"""
    The Grid struct includes a Circuit object and constraints on the number 
    of non-empty cells for columns and rows.
"""
mutable struct Grid
    size::Int
    circuit::Circuit
    row_constraints::Vector{Int}
    column_constraints::Vector{Int}
    
    function Grid(size::Int64, circuit::Circuit, row_constraints::Vector{Int}, column_constraints::Vector{Int})
        new(size, circuit, row_constraints, column_constraints)
    end
end

export Port, Cell, Circuit, Grid

end # module types