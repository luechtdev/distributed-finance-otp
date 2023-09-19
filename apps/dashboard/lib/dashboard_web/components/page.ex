defmodule DashboardWeb.PageComponents do
  use Phoenix.Component

  attr :title, :string
  attr :pretitle, :string
  slot :actions

  def header(assigns) do
    ~H"""
    <div class="page-header d-print-none">
      <div class="container-xl">
        <div class="row g-2 align-items-center">
          <div class="col">
            <div class="page-pretitle"><%= @pretitle %></div>
            <div class="page-title"><%= @title %></div>
          </div>
          <div class="col-auto ms-auto d-print-none">
            <div class="btn-list">
              <%= render_slot(@actions) %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  slot :inner_block, required: true

  def body(assigns) do
    ~H"""
    <div class="page-body">
      <div class="container-xl">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
