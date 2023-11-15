defmodule ProkeepTechnicalChallenge.MessageQueue do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_elements) do
    {:ok, _messages = []}
  end

  @impl true
  def handle_cast({:push, message}, messages) do
    updated_messages = List.insert_at(messages, -1, message)

    {:noreply, updated_messages}
  end

  @impl true
  def handle_info(:pop, messages) do
    [first_message | updated_messages] = messages

    IO.puts("PRINTING FROM INFO: #{first_message}")
    IO.puts(Time.utc_now)

    unless Enum.empty?(updated_messages) do
      Process.send_after(self(), :pop, 1000)
    end

    {:noreply, updated_messages}
  end
end
