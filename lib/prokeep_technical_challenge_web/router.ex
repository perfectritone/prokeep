defmodule ProkeepTechnicalChallengeWeb.Router do
  use ProkeepTechnicalChallengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ProkeepTechnicalChallengeWeb do
    pipe_through :api
  end
end
