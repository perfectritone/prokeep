defmodule ProkeepTechnicalChallenge.MessageHandlerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ProkeepTechnicalChallenge.MessageHandler

  test "messages are printed only once per second in a single queue" do
    messages = [
      {"message 1", "queue 1"},
      {"message 2", "queue 1"},
      {"message 3", "queue 1"},
      {"message 4", "queue 1"},
      {"message 5", "queue 1"},
      {"message 6", "queue 1"},
      {"message 7", "queue 1"},
      {"message 8", "queue 1"}
    ]

    add_messages = fn messages ->
      messages |>
      Enum.each(&MessageHandler.add_message(elem(&1, 0), elem(&1, 1)))
    end

    assert capture_io(fn ->
      add_messages.(messages)
    end) == "message 1"
    # And assert others not visible until :timer.sleep/1
  end

  test "messages are printed only once per second per queue" do
    _messages = [
      {"message 1", "queue 1"},
      {"message 2", "queue 2"},
      {"message 3", "queue 3"},
      {"message 4", "queue 4"},
      {"message 5", "queue 5"},
      {"message 6", "queue 6"},
      {"message 7", "queue 7"},
      {"message 8", "queue 8"}
    ]

    assert true
  end
end
