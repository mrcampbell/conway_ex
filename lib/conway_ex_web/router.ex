defmodule CWeb.Router do
  use CWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/prefabs", PrefabLive.Index, :index
    live "/prefabs/new", PrefabLive.Index, :new
    live "/prefabs/:id/edit", PrefabLive.Index, :edit

    live "/prefabs/:id", PrefabLive.Show, :show
    live "/prefabs/:id/show/edit", PrefabLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", CWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:conway_ex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
