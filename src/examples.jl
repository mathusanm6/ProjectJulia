module examples

using ..types: Grid, Circuit, Cell, Port

"""
    example_one()

    Grid(5, Circuit(5), [5, 3, 3, 5, 2], [5, 5, 2, 2, 4])
"""
function example_one()
    grid = Grid(5, Circuit(5), [5, 3, 3, 5, 2], [5, 5, 2, 2, 4])
    return grid
end

"""
    example_two()

    Grid(5, Circuit(5), [4, 5, 3, 3, 3], [3, 4, 3, 3, 5])
"""
function example_two()
    grid = Grid(5, Circuit(5), [4, 5, 3, 3, 3], [3, 4, 3, 3, 5])
    return grid
end

"""
    example_three()

    Grid(5, Circuit(5), [3, 5, 2, 5, 3], [3, 2, 4, 5, 4])
"""
function example_three()
    grid = Grid(5, Circuit(5), [3, 5, 2, 5, 3], [3, 2, 4, 5, 4])
    return grid
end

"""
    example_four()

    Grid(5, Circuit(5), [3, 4, 5, 4, 2], [4, 4, 3, 3, 4])
"""
function example_four()
    grid = Grid(5, Circuit(5), [3, 4, 5, 4, 2], [4, 4, 3, 3, 4])
    return grid
end

"""
    example_five()

    Grid(6, Circuit(6), [3, 4, 3, 2, 6, 2], [4, 4, 2, 3, 2, 5])
"""
function example_five()
    grid = Grid(6, Circuit(6), [3, 4, 3, 2, 6, 2], [4, 4, 2, 3, 2, 5])
    return grid
end

"""
    example_six()

    Grid(6, Circuit(6), [4, 5, 5, 2, 5, 5], [4, 5, 4, 5, 5, 3])
"""
function example_six()
    grid = Grid(6, Circuit(6), [4, 5, 5, 2, 5, 5], [4, 5, 4, 5, 5, 3])
    return grid
end

export example_one, example_two, example_three, example_four, example_five, example_six

function example_grid_valid()
    grid = example_one()

    grid.circuit.grid[1, 1] =
        Cell(Port(false, false, true, false), Port(false, true, false, false))
    grid.circuit.grid[1, 2] =
        Cell(Port(false, false, false, true), Port(false, true, false, false))
    grid.circuit.grid[1, 3] =
        Cell(Port(false, false, false, true), Port(false, true, false, false))
    grid.circuit.grid[1, 4] =
        Cell(Port(false, false, false, true), Port(false, true, false, false))
    grid.circuit.grid[1, 5] =
        Cell(Port(false, false, false, true), Port(false, false, true, false))

    grid.circuit.grid[2, 1] =
        Cell(Port(false, true, false, false), Port(true, false, false, false))
    grid.circuit.grid[2, 2] =
        Cell(Port(false, false, true, false), Port(false, false, false, true))
    grid.circuit.grid[2, 5] =
        Cell(Port(true, false, false, false), Port(false, false, true, false))

    grid.circuit.grid[3, 1] =
        Cell(Port(false, false, true, false), Port(false, true, false, false))
    grid.circuit.grid[3, 2] =
        Cell(Port(false, false, false, true), Port(true, false, false, false))
    grid.circuit.grid[3, 5] =
        Cell(Port(true, false, false, false), Port(false, false, true, false))

    grid.circuit.grid[4, 1] =
        Cell(Port(false, false, true, false), Port(true, false, false, false))
    grid.circuit.grid[4, 2] =
        Cell(Port(false, true, false, false), Port(false, false, true, false))
    grid.circuit.grid[4, 3] =
        Cell(Port(false, true, false, false), Port(false, false, false, true))
    grid.circuit.grid[4, 4] =
        Cell(Port(false, true, false, false), Port(false, false, false, true))
    grid.circuit.grid[4, 5] =
        Cell(Port(true, false, false, false), Port(false, false, false, true))

    grid.circuit.grid[5, 1] =
        Cell(Port(false, true, false, false), Port(true, false, false, false))
    grid.circuit.grid[5, 2] =
        Cell(Port(true, false, false, false), Port(false, false, false, true))
    return grid
end

function example_grid_invalid()
    grid = Grid(5, Circuit(5), [5, 5, 3, 5, 2], [5, 5, 2, 2, 4]) # Invalid grid (row 2)

    grid.circuit.grid[1, 1] =
        Cell(Port(false, false, true, false), Port(false, true, false, false))
    grid.circuit.grid[1, 2] =
        Cell(Port(false, false, false, true), Port(false, true, false, false))
    grid.circuit.grid[1, 3] =
        Cell(Port(false, false, false, true), Port(false, true, false, false))
    grid.circuit.grid[1, 4] =
        Cell(Port(false, false, false, true), Port(false, true, false, false))
    grid.circuit.grid[1, 5] =
        Cell(Port(false, false, false, true), Port(false, false, true, false))

    grid.circuit.grid[2, 1] =
        Cell(Port(false, true, false, false), Port(true, false, false, false))
    grid.circuit.grid[2, 2] =
        Cell(Port(false, false, true, false), Port(false, false, false, true))
    grid.circuit.grid[2, 5] =
        Cell(Port(true, false, false, false), Port(false, false, true, false))

    grid.circuit.grid[3, 1] =
        Cell(Port(false, false, true, false), Port(false, true, false, false))
    grid.circuit.grid[3, 2] =
        Cell(Port(false, false, false, true), Port(true, false, false, false))
    grid.circuit.grid[3, 5] =
        Cell(Port(true, false, false, false), Port(false, false, true, false))

    grid.circuit.grid[4, 1] =
        Cell(Port(false, false, true, false), Port(true, false, false, false))
    grid.circuit.grid[4, 2] =
        Cell(Port(false, true, false, false), Port(false, false, true, false))
    grid.circuit.grid[4, 3] =
        Cell(Port(false, true, false, false), Port(false, false, false, true))
    grid.circuit.grid[4, 4] =
        Cell(Port(false, true, false, false), Port(false, false, false, true))
    grid.circuit.grid[4, 5] =
        Cell(Port(true, false, false, false), Port(false, false, false, true))

    grid.circuit.grid[5, 1] =
        Cell(Port(false, true, false, false), Port(true, false, false, false))
    grid.circuit.grid[5, 2] =
        Cell(Port(true, false, false, false), Port(false, false, false, true))
    return grid
end

export example_grid_valid, example_grid_invalid

end # module examples
