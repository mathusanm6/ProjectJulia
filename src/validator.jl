module validator

using ..types: Port, Cell, Circuit, Grid

"""
    The check_valid_port function checks if a given port is valid.
    A port is considered valid if it has at most one side connected (true).
"""
function check_valid_port(port::Port)
    # Check if the port has at most one side connected (true)
    num_connected_sides = sum([port.top, port.right, port.bottom, port.left])
    return num_connected_sides <= 1
end

"""
    The check_valid_cell function checks if a given cell is valid.
    A cell is considered valid if its entry and exit ports are valid,
    and if the entry port is not connected to the same side as the exit port.
"""
function check_valid_cell(cell::Cell)
    # Check if the entry and exit ports are valid
    entry_valid = check_valid_port(cell.entry)
    exit_valid = check_valid_port(cell.exit)
    # Check if the entry and exit ports are not connected to the same side
    entry_exit_connected = (cell.entry.top && cell.exit.top) ||
                           (cell.entry.right && cell.exit.right) ||
                           (cell.entry.bottom && cell.exit.bottom) ||
                           (cell.entry.left && cell.exit.left)
    return entry_valid && exit_valid && !entry_exit_connected
end


"""
    The check_valid_circuit function checks if a given circuit is valid.
    A circuit is considered valid if all its cells are valid,
    and if it forms a connected graph, and if it has no loops,
"""
function check_valid_circuit(circuit::Circuit)
    # Check if all cells in the circuit are valid
    for i in 1:size(circuit.grid, 1), j in 1:size(circuit.grid, 2)
        cell = circuit.grid[i, j]
        if !check_valid_cell(cell)
            return false
        end
    end

    # Check if the circuit forms a connected graph
    visited = falses(size(circuit.grid, 1), size(circuit.grid, 2))
    function dfs(i, j)
        if i < 1 || i > size(circuit.grid, 1) || j < 1 || j > size(circuit.grid, 2)
            return
        end
        if visited[i, j]
            return
        end
        visited[i, j] = true
        cell = circuit.grid[i, j]
        if cell.entry.top
            dfs(i - 1, j)
        end
        if cell.entry.right
            dfs(i, j + 1)
        end
        if cell.entry.bottom
            dfs(i + 1, j)
        end
        if cell.entry.left
            dfs(i, j - 1)
        end
    end

    # Start DFS from a non-empty cell
    for i in 1:size(circuit.grid, 1), j in 1:size(circuit.grid, 2)
        if circuit.grid[i, j].entry.top || circuit.grid[i, j].entry.right ||
           circuit.grid[i, j].entry.bottom || circuit.grid[i, j].entry.left
            dfs(i, j)
            break
        end
    end

    # Check if all cells non-empty cells are visited
    for i in 1:size(circuit.grid, 1), j in 1:size(circuit.grid, 2)
        if circuit.grid[i, j].entry.top || circuit.grid[i, j].entry.right ||
           circuit.grid[i, j].entry.bottom || circuit.grid[i, j].entry.left
            if !visited[i, j]
                return false
            end
        end
    end

    # If sub-loops exist, it will return false as some cells would not be visited
    return true
end

"""
    The check_valid_grid function checks if a given grid is valid.
    A grid is considered valid if its circuit is valid,
    and if the number of non-empty cells in each row and column matches the constraints.
"""
function check_valid_grid(grid::Grid)
    # Check if the circuit is valid
    if !check_valid_circuit(grid.circuit)
        return false
    end

    # Check if the number of non-empty cells in each row matches the constraints
    for i in 1:grid.size
        num_non_empty_cells = sum([grid.circuit.grid[i, j].entry.top || grid.circuit.grid[i, j].entry.right ||
                                   grid.circuit.grid[i, j].entry.bottom || grid.circuit.grid[i, j].entry.left
                                   for j in 1:grid.size])
        if num_non_empty_cells != grid.row_constraints[i]
            return false
        end
    end

    # Check if the number of non-empty cells in each column matches the constraints
    for j in 1:grid.size
        num_non_empty_cells = sum([grid.circuit.grid[i, j].entry.top || grid.circuit.grid[i, j].entry.right ||
                                   grid.circuit.grid[i, j].entry.bottom || grid.circuit.grid[i, j].entry.left
                                   for i in 1:grid.size])
        if num_non_empty_cells != grid.column_constraints[j]
            return false
        end
    end

    return true
end

export check_valid_port, check_valid_cell, check_valid_circuit, check_valid_grid

end # module validator