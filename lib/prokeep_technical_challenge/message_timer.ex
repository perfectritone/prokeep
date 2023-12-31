defmodule ProkeepTechnicalChallenge.MessageTimer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: MessageTimer)
  end

  #

  @impl true
  def init(_elements) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:restart, at_time}, _state) do
    {:noreply, NaiveDateTime.add(at_time, message_handler_interval(), :millisecond)}
  end

  defp message_handler_interval do
    Application.get_env(:prokeep_technical_challenge, :message_handler_interval)
  end
end
