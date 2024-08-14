defmodule CounterWeb.CounterTest do
  use CounterWeb.ConnCase
  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "Counter: 0"
  end

  test "Increment", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :increase) =~ "Counter: 1"
  end

  test "Decrement", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :decrease) =~ "Counter: -1"
  end

  test "handle_info/2 broadcast message", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    {:ok, view2, _html} = live(conn, "/")

    assert render_click(view, :increase) =~ "Counter: 1"
    assert render_click(view2, :increase) =~ "Counter: 2"
  end
end
