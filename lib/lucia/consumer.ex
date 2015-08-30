defmodule Lucia.Consumer do
  use GenServer
  use AMQP
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
    {:ok, conn} = Connection.open("amqp://guest:guest@#{@host}")
    {:ok, chan} = Channel.open(conn)
    Logger.info "Connected to rabbitmq"
    {:ok, conn}
  end
end
