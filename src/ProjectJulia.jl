module ProjectJulia

include("types.jl")
include("examples.jl")
include("validator.jl")
include("optimizer.jl")
include("generator.jl")

using .types
export Port, Cell, Circuit, Grid
export generate_next_constraints

using .examples
export example_one, example_two, example_three, example_four, example_five, example_six
export example_grid_valid, example_grid_invalid

using .validator
export check_valid_port, check_valid_cell, check_valid_circuit, check_valid_grid

using .optimizer
export optimize_grid

using .generator
export generate_all_solvable_grids

end # module ProjectJulia
