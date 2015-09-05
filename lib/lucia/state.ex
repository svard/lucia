defmodule Lucia.State do
  alias Lucia.Light
  require Logger
  
  def start_link() do
    Light.start
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
    light_ids = Application.get_env(:lucia, Lights)[:ids]
    Agent.update(__MODULE__, fn state -> %{state | :triggered => true} end)
    Enum.each(light_ids, fn id ->
      case Light.put! id, %{state: "ON"}, %{"content-type" => "application/json"} do
        {:ok, _} -> Logger.debug "Light #{id} switched ON"
        _ -> Logger.error "Failed switching light #{id} ON"
      end
    end)
  end

  def get() do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
