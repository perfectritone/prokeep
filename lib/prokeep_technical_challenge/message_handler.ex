defmodule ProkeepTechnicalChallenge.MessageHandler do
  alias ProkeepTechnicalChallenge.{MessageQueue, MessageTimer, MessageTimersAgent}

  def start_timer_and_queue(queue_name) do
    get_existing_timer = fn timers ->
      Enum.find(timers, &(Kernel.elem(&1, 0) == queue_name))
    end

    existing_timer = Agent.get(MessageTimersAgent, get_existing_timer)

    if existing_timer do
      existing_timer
    else
      get_and_update_with_new_timer = fn timers ->
        {:ok, new_timer} = GenServer.start_link(MessageTimer, nil)
        {:ok, new_queue} = GenServer.start_link(MessageQueue, nil)
        new_timer_info = {queue_name, new_timer, new_queue}

        {new_timer_info, [new_timer_info | timers]}
      end

      Agent.get_and_update(MessageTimersAgent, get_and_update_with_new_timer)
    end
  end

  def add_message(message, queue_name) do
    {_queue_name, timer, queue} = start_timer_and_queue(queue_name)

    :ok = GenServer.cast(queue, {:push, message})

    timer_state = :sys.get_state(timer)

    if timer_state.all_clear do
      _message = send(queue, :pop)
      GenServer.cast(timer, {:restart, NaiveDateTime.utc_now})
    else
      current_time = NaiveDateTime.utc_now
      next_clear = :sys.get_state(timer).next_clear
      clear_in = NaiveDateTime.diff(current_time, next_clear, :millisecond)

      if clear_in >= 0 do
        _message = send(queue, :pop)
        GenServer.cast(timer, {:restart, NaiveDateTime.utc_now})
      else
        [_first | other_messages] = :sys.get_state(queue)

        if Enum.empty?(other_messages) do
          Process.send_after(queue, :pop, -clear_in)
        end
      end
    end
  end
end
