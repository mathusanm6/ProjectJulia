using Test
using ProjectJulia
using ProjectJulia.types: generate_next_constraints

@testset "Valid Order: generate_next_constraints" begin
    size_three_in_order = Dict(
        1 => [0, 0, 0], 2 => [1, 0, 0], 3 => [2, 0, 0], 4 => [3, 0, 0],
        5 => [0, 1, 0], 6 => [1, 1, 0], 7 => [2, 1, 0], 8 => [3, 1, 0],
        9 => [0, 2, 0], 10 => [1, 2, 0], 11 => [2, 2, 0], 12 => [3, 2, 0],
        13 => [0, 3, 0], 14 => [1, 3, 0], 15 => [2, 3, 0], 16 => [3, 3, 0], 17 => [0, 0, 1], 18 => [1, 0, 1], 19 => [2, 0, 1], 20 => [3, 0, 1],
        21 => [0, 1, 1], 22 => [1, 1, 1], 23 => [2, 1, 1], 24 => [3, 1, 1],
        25 => [0, 2, 1], 26 => [1, 2, 1], 27 => [2, 2, 1], 28 => [3, 2, 1],
        29 => [0, 3, 1], 30 => [1, 3, 1], 31 => [2, 3, 1], 32 => [3, 3, 1], 33 => [0, 0, 2], 34 => [1, 0, 2], 35 => [2, 0, 2], 36 => [3, 0, 2],
        37 => [0, 1, 2], 38 => [1, 1, 2], 39 => [2, 1, 2], 40 => [3, 1, 2],
        41 => [0, 2, 2], 42 => [1, 2, 2], 43 => [2, 2, 2], 44 => [3, 2, 2],
        45 => [0, 3, 2], 46 => [1, 3, 2], 47 => [2, 3, 2], 48 => [3, 3, 2], 49 => [0, 0, 3], 50 => [1, 0, 3], 51 => [2, 0, 3], 52 => [3, 0, 3],
        53 => [0, 1, 3], 54 => [1, 1, 3], 55 => [2, 1, 3], 56 => [3, 1, 3],
        57 => [0, 2, 3], 58 => [1, 2, 3], 59 => [2, 2, 3], 60 => [3, 2, 3],
        61 => [0, 3, 3], 62 => [1, 3, 3], 63 => [2, 3, 3], 64 => [3, 3, 3],
    )

    sorted_keys = sort(collect(keys(size_three_in_order)))

    for key in sorted_keys
        prev_constraints = size_three_in_order[key]
        next_constraints = generate_next_constraints(3, copy(prev_constraints))

        if key == last(sorted_keys)
            @test isnothing(next_constraints)
        else
            expected_constraints = size_three_in_order[key+1]
            @test next_constraints == expected_constraints
        end
    end
end