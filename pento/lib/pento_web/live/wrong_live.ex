defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  alias PentoWeb.Router.Helpers, as: Routes

  def mount(_params, session, socket) do
    {:ok, socket |> start_game() |> assign(session_id: session["live_socket_id"])}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h3>
    <%= if @win == true do %>
      <%= live_patch "Restart the game!", to: Routes.live_path(@socket, __MODULE__) %>
    <% end %>
    </h3>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </a>
      <% end %>
    </h2>
    """
  end

  def handle_event(
        "guess",
        %{"number" => guess},
        %{assigns: %{random_number: number_to_guess}} = socket
      ) do
    case number_to_guess == String.to_integer(guess) do
      true ->
        message = "Right guess! Congratulations!"
        score = socket.assigns.score + 1
        {:noreply, assign(socket, message: message, score: score, win: true)}

      false ->
        message = "Your guess: #{guess}. Wrong. Guess again."
        score = socket.assigns.score - 1
        {:noreply, assign(socket, score: score, message: message)}
    end
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, start_game(socket)}
  end

  defp start_game(socket) do
    assign(socket,
      score: 0,
      message: "Make a guess:",
      random_number: :rand.uniform(10),
      win: false
    )
  end
end
