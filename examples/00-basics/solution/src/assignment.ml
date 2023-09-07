type vector3 = float * float * float

(* the exact values don't matter, but when testing your solutions make sure to test edge cases! *)

let p1 = (-2.5, 5.0, 0.2)

let p2 = (0.0, 0.0, 13.1)

let p3 = (5.4, -8.2, 1.0)

let string_of_vector3 (x, y, z) =
  "(" ^ string_of_float x ^ "," ^ string_of_float y ^ "," ^ string_of_float z ^ ")"

let vector3_add (x1, y1, z1) (x2, y2, z2) = (x1 +. x2, y1 +. y2, z1 +. z2)

let vector3_max (x1, y1, z1) (x2, y2, z2) =
  if
    (x1 *. x1) +. (y1 *. y1) +. (z1 *. z1)
    > (x2 *. x2) +. (y2 *. y2) +. (z2 *. z2)
  then (x1, y1, z1)
  else (x2, y2, z2)

let combine a b c = string_of_vector3 (vector3_add a (vector3_max b c))
