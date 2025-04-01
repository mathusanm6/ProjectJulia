# Project Julia

## Running the Project

```bash
julia --project=. main.jl
```

## Running Tests

To run the tests for this project, execute the following command in your terminal:

```bash
julia --project=. -e "using Pkg; Pkg.test()"
```

This will ensure that all tests are executed within the current project environment.
