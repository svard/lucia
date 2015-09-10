defmodule Lucia.Light.Api.Prod do
  alias Lucia.Light
  require Logger
  
  @behaviour Lucia.Light.Api

  def start() do
    Light.start
  end

  def switch_on(id) do
    case Light.put! id, %{state: "ON"}, %{"content-type" => "application/json"} do
      %HTTPoison.Response{status_code: 201} -> Logger.debug "Light #{id} switched ON"
      %HTTPoison.Response{status_code: _} -> Logger.error "Failed switching light #{id} ON"
    end
  end

  def switch_off(id) do
    case Light.put! id, %{state: "OFF"}, %{"content-type" => "application/json"} do
      %HTTPoison.Response{status_code: 201} -> Logger.debug "Light #{id} switched OFF"
      %HTTPoison.Response{status_code: _} -> Logger.error "Failed switching light #{id} OFF"
    end
  end
end
