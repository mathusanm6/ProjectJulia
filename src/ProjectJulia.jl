module ProjectJulia

include("types.jl")
include("examples.jl")
include("validator.jl")
include("optimizer.jl")

using .types
export Port, Cell, Circuit, Grid

using .examples
export example_grid_valid, example_grid_invalid

using .validator
export check_valid_port, check_valid_cell, check_valid_circuit, check_valid_grid

using .optimizer
export optimize_grid

end # module ProjectJulia
