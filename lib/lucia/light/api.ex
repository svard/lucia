defmodule Lucia.Light.Api do
  @callback switch_on(id :: integer) :: none
  @callback switch_off(id :: integer) :: none
end
