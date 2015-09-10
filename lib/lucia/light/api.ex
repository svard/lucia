defmodule Lucia.Light.Api do
  use Behaviour

  defcallback switch_on(id :: integer) :: none
  defcallback switch_off(id :: integer) :: none
end
