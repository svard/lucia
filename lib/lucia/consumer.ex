defmodule Lucia.Consumer do
  use GenServer
  use AMQP
  alias Lucia.Controller
  alias Poison.Parser
  require Logger

  def start_link() do
    Logger.info "Starting consumer"
    GenServer.start_link(__MODULE__, [])
  end

  @host Application.get_env(:lucia, RabbitMQ)[:host]
  @exchange Application.get_env(:lucia, RabbitMQ)[:exchange]
  
  def init(_opts) do
    {:ok, hostname} = :inet.gethostname()
    queue_name = "lucia@#{hostname}"
    {:ok, conn} = Connection.open("amqp://#{@host}")
    {:ok, chan} = Channel.open(conn)
    Queue.declare(chan, queue_name, auto_delete: true)
    Exchange.declare(chan, @exchange)
    Queue.bind(chan, queue_name, @exchange, routing_key: "light-level")
    {:ok, _consumer_tag} = Basic.consume(chan, queue_name, nil, no_ack: true)
    {:ok, chan}
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{routing_key: "light-level"}}, chan) do
    spawn fn -> Controller.check Parser.parse!(payload, keys: :atoms!) end
    
    {:noreply, chan}
  end
end
