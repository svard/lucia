defmodule Lucia.StateTest do
  use ExUnit.Case
  import Lucia.State

  setup do
    start_link

    on_exit fn ->
      reset
    end

    :ok
  end

  @tag :skip
  test "reset()" do
    Agent.update(Lucia.State, fn _-> %{triggered: true, threshold: 5} end)
    reset

    assert get == %{triggered: false, threshold: 0}
  end

  @tag :skip
  test "reset_threshold()" do
    Agent.update(Lucia.State, fn _-> %{triggered: true, threshold: 5} end)
    reset_threshold

    assert get == %{triggered: true, threshold: 0}
  end

  @tag :skip
  test "increment()" do
    increment

    assert get == %{triggered: false, threshold: 1}
  end

  @tag :skip
  test "trigger()" do
    trigger

    assert get == %{triggered: true, threshold: 0}
  end
end
