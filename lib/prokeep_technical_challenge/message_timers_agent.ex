defmodule ProkeepTechnicalChallenge.MessageTimersAgent do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end
end
