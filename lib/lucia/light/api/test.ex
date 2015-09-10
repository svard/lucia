defmodule Lucia.Light.Api.Test do
  alias Lucia.Light
  
  @behaviour Lucia.Light.Api

  def start() do
    {:ok, []}
  end

  def switch_on(id) do
    :ok
  end

  def switch_off(id) do
    :ok
  end
end
