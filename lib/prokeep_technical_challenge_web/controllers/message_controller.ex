defmodule ProkeepTechnicalChallengeWeb.MessageController do
  use ProkeepTechnicalChallengeWeb, :controller

  def receive_message(conn, %{"message" => message, "queue" => queue}) do
    ProkeepTechnicalChallenge.MessageHandler.add_message(message, queue)

    send_resp(conn, 200, "")
  end
end
