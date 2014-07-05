defmodule MoleWebapp.Router do
  use Phoenix.Router

  plug Plug.Static, at: "/static", from: :mole_webapp
  get "/", MoleWebapp.Controllers.Pages, :index, as: :page
end
