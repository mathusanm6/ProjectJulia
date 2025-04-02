module ProjectJulia

include("types.jl")
include("examples.jl")
include("validator.jl")

using .types
using .examples
using .validator

export Port, Cell, Circuit, Grid
export example_grid_valid, example_grid_invalid
export check_valid_port, check_valid_cell, check_valid_circuit, check_valid_grid

end # module ProjectJulia
