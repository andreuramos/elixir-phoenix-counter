defmodule CounterWeb.Counter do
    use CounterWeb, :live_view
    alias Counter.Count
    alias Phoenix.PubSub

    @topic Count.topic()

    def mount(_params, _session, socket) do
        PubSub.subscribe(Counter.PubSub, @topic)

        {:ok, assign(socket, val: Count.current()) }
    end

    def handle_event("increase", _, socket) do
        {:noreply, assign(socket, :val, Count.increase())}
    end

    def handle_event("decrease", _, socket) do
        {:noreply, assign(socket, :val, Count.decrease())}
    end

    def handle_info({:count, count}, socket) do
        {:noreply, assign(socket, val: count)}
    end

    def render(assigns) do
        ~H"""
        <.live_component module={CounterComponent} id="counter" val={@val} />
        """
    end
end