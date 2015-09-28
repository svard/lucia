defmodule Lucia.Fsm do
  @behaviour :gen_fsm

  def start_link() do
    Lucia.light_api.start
    :gen_fsm.start_link({:global, :fsm}, __MODULE__, [], [])
  end

  def init([]) do
    {:ok, :check_one, %{triggered: false}}
  end

  def next() do
    :gen_fsm.send_event({:global, :fsm}, :next)
  end

  def reset() do
    :gen_fsm.send_all_state_event({:global, :fsm}, :reset)
  end

  def get() do
    :gen_fsm.sync_send_all_state_event({:global, :fsm}, :get)
  end

  def check_one(:next, state) do
    {:next_state, :check_two, state}
  end

  def check_two(:next, state) do
    {:next_state, :switch, state}
  end

  def switch(:next, %{triggered: false}) do
    Application.get_env(:lucia, :lights)[:ids]
    |> Enum.each(fn id ->
      Lucia.light_api.switch_on id
    end)
    
    {:next_state, :switch, %{triggered: true}}
  end

  def switch(:next, state) do
    {:next_state, :switch, state}
  end
  
  def handle_info(_info, state_name, state) do
    {:next_state, state_name, state}
  end

  def handle_event(:reset, _state_name, _state) do
    {:next_state, :check_one, %{triggered: false}}
  end

  def handle_sync_event(:get, _from, state_name, state) do
    {:reply, state.triggered, state_name, state}
  end

  def terminate(:normal, _, _) do
    :ok
  end

  def code_change(_old_version, state_name, state_data, _extra) do
    {:ok, state_name, state_data}
  end
end
