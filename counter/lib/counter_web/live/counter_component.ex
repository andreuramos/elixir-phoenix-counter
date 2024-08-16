defmodule CounterComponent do
    use Phoenix.LiveComponent

    defp btn(color) do
        "text-6xl pb-2 w-20 rounded-lg bg-#{color}-500 hover:bg-#{color}-600"
    end

    def render(assigns) do
        ~H"""
        <div class="text-center">
            <h1 class="text-4xl fond-bold text-center">Counter: <%= @val %></h1>
            <button phx-click="decrease" class={btn("red")}>-</button>
            <button phx-click="increase" class={btn("green")}>+</button>
        </div>
        """
    end
end