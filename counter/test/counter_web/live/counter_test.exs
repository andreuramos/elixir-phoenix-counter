defmodule CounterWeb.CounterTest do
  use CounterWeb.ConnCase
  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "Counter: 0"
  end

  test "Increment", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")
    current = Counter.Count.current()
    assert html =~ "Counter: #{current}"
    assert render_click(view, :increase) =~ "Counter: #{current + 1}"
  end

  test "Decrement", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")
    current = Counter.Count.current()
    assert html =~ "Counter: #{current}"
    assert render_click(view, :decrease) =~ "Counter: #{current - 1}"
  end

  test "handle_info/2 broadcast message", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, "/")
    current = Counter.Count.current()

    assert disconnected_html =~ "Counter: #{current}"
    assert render(view) =~ "Counter: #{current}"

    send(view.pid, {:count, 2})
    assert render(view) =~ "Counter: 2"
  end
end
