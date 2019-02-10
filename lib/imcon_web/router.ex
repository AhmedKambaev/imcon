defmodule ImconWeb.Router do
  use ImconWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "xml"]
    plug :fetch_session
    plug ImconWeb.Guardian.Pipeline

  end

  scope "/api", ImconWeb do
    pipe_through :api

    resources "/channels", ChannelController, only: [:create, :index] do
      resources "/messages", MessageController, only: [:index]
      resources "/messages", MessageController, only: [], singleton: true do
        post "/read", ChannelController, :read, singleton: true
      end
    end

    resources "/direct_channels", DirectChannelController, only: [:index]
    post "/direct_channels/join", DirectChannelController, :join

    resources "/channel_user", ChannelUserController, only: [:create]
    resources "/user", UserController, only: [:index] do
    end
    
    scope "/v1" do
      post "/registration", UserController, :create
      post "/session", SessionController, :create
      delete "/session", SessionController, :delete

      get "/current_user", CurrentUserController, :show

      resources "/tree", TreeController, only: [:index, :create] do
        resources "/leaflet", LeafletController, only: [:show]
      end
    end
  end

  scope "/", ImconWeb do\
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end
end
