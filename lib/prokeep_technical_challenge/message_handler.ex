defmodule ProkeepTechnicalChallenge.MessageHandler do
  alias ProkeepTechnicalChallenge.{HTTPMessageQueue, MessageTimer}

  def start_timer do
    {:ok, timer} = GenServer.start_link(MessageTimer, nil, name: OneMessageTimer)
  end

  def add_message(message, _queue_name) do
    :ok = GenServer.cast(HTTPMessageQueue, {:push, message})

    timer = OneMessageTimer
    timer_state = :sys.get_state(timer)

    if timer_state.all_clear do
      message = send(HTTPMessageQueue, :pop)
      GenServer.cast(timer, {:restart, NaiveDateTime.utc_now})
    else
      current_time = NaiveDateTime.utc_now
      next_clear = :sys.get_state(timer).next_clear
      clear_in = NaiveDateTime.diff(current_time, next_clear, :millisecond)

      if clear_in >= 0 do
        message = send(HTTPMessageQueue, :pop)
        GenServer.cast(timer, {:restart, NaiveDateTime.utc_now})
      else
        [first | other_messages] = :sys.get_state(HTTPMessageQueue) |> elem(0)
        IO.puts "first: #{first}"
        IO.puts "other_messages: #{other_messages}"
        if Enum.empty?(other_messages) do
          Process.send_after(HTTPMessageQueue, :pop, -clear_in)
        end
      end
    end
  end
end
