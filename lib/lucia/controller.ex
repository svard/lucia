defmodule Lucia.Controller do
  require Logger
  use Timex
  alias Lucia.Fsm

  def check(%{date: date, level: level}) when level < 0.1 do
    {:ok, dt} = Timex.Parse.DateTime.Parser.parse(date, "{ISOz}")
    Logger.debug "Level #{level}"

    if dt.hour < 23 do
      Fsm.next
    end
  end

  def check(%{date: date, level: level}) do
    {:ok, dt} = Timex.Parse.DateTime.Parser.parse(date, "{ISOz}")
    
    Logger.debug "Level #{level}"

    case Fsm.get do
      false ->
        Fsm.reset

      true ->
        if dt.hour == 11 do
          Fsm.reset
        end
    end
  end  
end
