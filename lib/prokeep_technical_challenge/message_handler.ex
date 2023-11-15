defmodule ProkeepTechnicalChallenge.MessageHandler do
  alias ProkeepTechnicalChallenge.{MessageQueue, MessageTimer, MessageTimersAgent}

  def add_message(message, queue_name) do
    {_queue_name, timer, queue} = start_timer_and_queue(queue_name)

    :ok = GenServer.cast(queue, {:push, message})

    pop_or_queue(queue, timer, :sys.get_state(timer))
  end

  defp start_timer_and_queue(queue_name) do
    get_existing_timer = fn timers ->
      Enum.find(timers, &(Kernel.elem(&1, 0) == queue_name))
    end

    existing_timer = Agent.get(MessageTimersAgent, get_existing_timer)

    get_or_initialize_timer(existing_timer, queue_name)
  end

  defp get_or_initialize_timer(nil, queue_name) do
    get_and_update_with_new_timer = fn timers ->
      {:ok, new_timer} = GenServer.start_link(MessageTimer, nil)
      {:ok, new_queue} = GenServer.start_link(MessageQueue, nil)
      new_timer_info = {queue_name, new_timer, new_queue}

      {new_timer_info, [new_timer_info | timers]}
    end

    Agent.get_and_update(MessageTimersAgent, get_and_update_with_new_timer)
  end
  defp get_or_initialize_timer(timer, _queue_name), do: timer

  defp pop_or_queue(queue, timer, nil) do
    pop_now(queue, timer)
  end

  defp pop_or_queue(queue, timer, next_clear) do
    clear_in = NaiveDateTime.diff(
      next_clear,
      NaiveDateTime.utc_now,
      :millisecond)

    if clear_in <= 0 do
      pop_now(queue, timer)
    else
      [_this_message | other_messages] = :sys.get_state(queue)

      if Enum.empty?(other_messages) do
        Process.send_after(queue, :pop, clear_in)
      end
    end
  end

  defp pop_now(queue, timer) do
    _message = send(queue, :pop)
    GenServer.cast(timer, {:restart, NaiveDateTime.utc_now})
  end
end
