#!/usr/bin/env julia

using ProjectJulia

function main()
    name = get(ARGS, 1, "world") # Default to "world" if no argument is provided
    println(ProjectJulia.greet(name))
end

main()