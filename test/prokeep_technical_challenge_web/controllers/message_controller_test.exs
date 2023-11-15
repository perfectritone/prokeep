defmodule ProkeepTechnicalChallengeWeb.MessageControllerTest do
  use ProkeepTechnicalChallengeWeb.ConnCase
  use ExUnit.Case

  test "returns 200 when sent a message with a queue" do
    conn = get(
      build_conn(),
      "/receive-message?message=some_message&queue=first_queue")

    assert conn.status == 200
  end
end
