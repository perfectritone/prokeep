defmodule ProkeepTechnicalChallenge.MessageTimer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: MessageTimer)
  end

  def restart do
    GenServer.cast(MessageTimer, {:restart, NaiveDateTime.utc_now})
  end

  #

  @impl true
  def init(_elements) do
    {:ok, %{all_clear: true, next_clear: nil}}
  end

  @impl true
  def handle_cast({:restart, at_time}, _state) do
    next_clear = NaiveDateTime.add(at_time, 1)

    {:noreply, %{all_clear: false, next_clear: next_clear}}
  end
end
