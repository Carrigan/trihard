defmodule Trihard.Router do
  use Trihard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Trihard.Auth, repo: Trihard.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Trihard do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/workouts", WorkoutController
    resources "/registrations", RegistrationController, only: [:new, :create]
    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    get    "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Trihard do
  #   pipe_through :api
  # end
end
