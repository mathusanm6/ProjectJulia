# Project Julia

# Installation

```bash
julia --project=. -e 'using Pkg; Pkg.add(["JuMP", "HiGHS", "Random", "Test", "JuliaFormatter"])'
```

## Running the Project

```bash
julia --project=. main.jl <arg_1> <arg_2> <arg_3> <arg_4>

Usage:
  julia --project=. main.jl examples
  julia --project=. main.jl generate all <size>
  julia --project=. main.jl generate random <size> [seed]
```

## Running Tests

To run the tests for this project, execute the following command in your terminal:

```bash
julia --project=. -e "using Pkg; Pkg.test()"
```

This will ensure that all tests are executed within the current project environment.

## Formatting Code

```bash
julia --project=. -e 'using JuliaFormatter; format(".", verbose=true)'
```