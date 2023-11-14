defmodule ProkeepTechnicalChallenge.MessageQueue do
  use GenServer

  alias ProkeepTechnicalChallenge.MessageTimer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: ProkeepTechnicalChallenge.HTTPMessageQueue)
  end

  @impl true
  def init(_elements) do
    {:ok, {_messages = [], _timers = []}}
  end

  @impl true
  def handle_cast({:push, message}, {messages, timers}) do
    updated_messages = List.insert_at(messages, -1, message)

    {:noreply, {updated_messages, timers}}
  end

  @impl true
  def handle_info(:pop, {messages, timers}) do
    [first_message | updated_messages] = messages

    IO.puts("PRINTING FROM INFO: #{first_message}")
    IO.puts(Time.utc_now)

    unless Enum.empty?(updated_messages) do
      IO.puts("about to send_after")
      Process.send_after(ProkeepTechnicalChallenge.HTTPMessageQueue, :pop, 1000)
    end

    {:noreply, {updated_messages, timers}}
  end
end
