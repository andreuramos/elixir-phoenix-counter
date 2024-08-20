defmodule CounterWeb.Counter do
    use CounterWeb, :live_view
    alias Counter.Count
    alias Phoenix.PubSub
    alias Counter.Presence

    @topic Count.topic()
    @presence_topic "presence"

    def mount(_params, _session, socket) do
        PubSub.subscribe(Counter.PubSub, @topic)

        Presence.track(self(), @presence_topic, socket.id, %{})
        CounterWeb.Endpoint.subscribe(@presence_topic)

        initial_present = Presence.list(@presence_topic)
            |> map_size

        {:ok, assign(socket, val: Count.current(), present: initial_present) }
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

    def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{present: present}} = socket
    ) do
        new_present = present + map_size(joins) - map_size(leaves)

        {:noreply, assign(socket, :present, new_present)}
    end

    def render(assigns) do
        ~H"""
        <.live_component module={CounterComponent} id="counter" val={@val} />
        <.live_component module={PresenceComponent} id="presence" present={@present} />
        """
    end
end