defmodule CounterWeb.Counter do
    use CounterWeb, :live_view

    @topic "live"

    def mount(_params, _session, socket) do
        CounterWeb.Endpoint.subscribe(@topic)
        {:ok, assign(socket, :val, 0)}
    end

    def handle_event("increase", _, socket) do
        new_state = update(socket, :val, &(&1 + 1))
        CounterWeb.Endpoint.broadcast_from(self(), @topic, "increase", new_state.assigns)
        {:noreply, new_state}
    end

    def handle_event("decrease", _, socket) do
        new_state = update(socket, :val, &(&1 - 1))
        CounterWeb.Endpoint.broadcast_from(self(), @topic, "decrease", new_state.assigns)
        {:noreply, new_state}
    end

    def handle_info(msg, socket) do
        {:noreply, assign(socket, :val, msg.payload.val)}
    end

    def render(assigns) do
        ~H"""
        <div>
            <h1 class="text-4xl font-bold text-center"> Counter: <%= @val %> </h1>
            <p class="text-center">
                <.button phx-click="decrease">-</.button>
                <.button phx-click="increase">+</.button>
            </p>
        </div>
        """
    end
end