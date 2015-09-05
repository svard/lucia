defmodule Lucia.Light do
  use HTTPoison.Base

  def process_url(id) do
    Application.get_env(:lucia, Service)[:url] <> "/#{id}"
  end

  def process_request_body(body) do
    body |> Poison.encode!
  end
end
