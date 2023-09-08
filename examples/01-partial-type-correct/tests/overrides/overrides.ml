open Stdlib_variants

module Stdlib = struct
  include SafeStdlib
  module Stdlib = SafeStdlib
end
