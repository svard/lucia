defmodule Lucia.Controller do
  require Logger
  use Timex
  alias Lucia.State

  def check(%{date: date, level: level}) when level < 0.1 do
    {:ok, dt} = Timex.Parse.DateTime.Parser.parse(date, "{ISOz}")

    if !State.get.triggered do
      Logger.debug "Level #{level}, incrementing threshold"
      State.increment()
    end

    if State.get.threshold > 3 && !State.get.triggered && dt.hour < 23 do
      Logger.debug "Threshold #{State.get.threshold}, trigger lights"
      State.trigger()
    end
  end

  def check(%{date: date, level: level}) do
    Logger.debug "Level #{level}"
    {:ok, dt} = Timex.Parse.DateTime.Parser.parse(date, "{ISOz}")

    if dt.hour == 12 && State.get.triggered do
      Logger.debug "Resetting state"
      State.reset()
    end

    State.reset_threshold()
  end  
end
