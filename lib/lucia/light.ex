defmodule Lucia.Light do
  use HTTPoison.Base

  def process_url(id) do
    "http://tomcat.kristofersvard.se/services/api/light/#{id}"
  end

  def process_request_body(body) do
    body |> Poison.encode!
  end
end
