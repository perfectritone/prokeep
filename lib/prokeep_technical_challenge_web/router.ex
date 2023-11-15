defmodule ProkeepTechnicalChallengeWeb.Router do
  use ProkeepTechnicalChallengeWeb, :router

  scope "/", ProkeepTechnicalChallengeWeb do
    get "/receive-message", MessageController, :receive_message
  end
end
