defmodule Lucia.State do
  def start_link() do
    Agent.start_link(fn -> %{triggered: false, threshold: 0} end, name: __MODULE__)
  end

  def reset() do
    Agent.update(__MODULE__, fn _ -> %{triggered: false, threshold: 0} end)
  end

  def reset_threshold() do
    Agent.update(__MODULE__, fn state -> %{state | :threshold => 0} end)
  end

  def increment() do
    Agent.update(__MODULE__, fn state -> %{state | :threshold => state.threshold + 1} end)
  end

  def trigger() do
    Agent.update(__MODULE__, fn state -> %{state | :triggered => true} end)
  end

  def get() do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
