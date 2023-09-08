# Example 00: Basics

This exercise showcases a basic setup, suitable for standard programming exercises on purely functional programming.

## Problem Statement

The problem statement for this exercise is as follows.

### What's the point?

Using what you've learned about tuple types, implement functionality for computing with three-dimensional vectors.

1. #### Define three points

    The points `p1`, `p2` and `p3` should all be different, but their exact values don't matter. Use them, along with other points, to test your functions.

2. #### `string_of_vector3`

    Implement a function `string_of_vector3 : vector3 -> string` to convert a vector into a human-readable representation. For example, the string for the zero vector should be: `"(0.,0.,0.)"`. (Hint: use `string_of_float` to convert components.)

3. #### `vector3_add`

    Write a function `vector3_add : vector3 -> vector3 -> vector3` that adds two vectors component-wise.

4. #### `vector3_max`

    Write a function `vector3_max : vector3 -> vector3 -> vector3` that returns the larger argument vector (the vector with the greater magnitude).

5. #### `combine`

    Write a function `combine : vector3 -> vector3 -> vector3 -> string` that adds its first argument to the larger of the other two arguments and returns the result as a string.
