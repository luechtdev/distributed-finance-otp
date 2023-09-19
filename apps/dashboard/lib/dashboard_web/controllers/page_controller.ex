defmodule DashboardWeb.PageController do
  use DashboardWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> put_layout(html: :app)
    |> render(:home)
  end
end
