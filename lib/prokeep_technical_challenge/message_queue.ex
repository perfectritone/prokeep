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

    IO.puts(first_message)

    unless Enum.empty?(updated_messages) do
      Process.send_after(self(), :pop, message_handler_interval())
    end

    {:noreply, updated_messages}
  end

  defp message_handler_interval do
    Application.get_env(:prokeep_technical_challenge, :message_handler_interval)
  end
end
