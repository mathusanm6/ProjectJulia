#!/usr/bin/env julia

using ProjectJulia
using ProjectJulia.examples: example_one
using ProjectJulia.optimizer: optimize_grid


function main()
    grid = example_one()
    optimized_grid = optimize_grid(grid)
    display(optimized_grid)
end

main()