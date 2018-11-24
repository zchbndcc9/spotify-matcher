defmodule ArtistManager.Server do
  use GenServer
  alias ArtistManager.Server.Impl

  def init(_) do
    {:ok, ArtistManager.Stash.get()}
  end

  def handle_cast({:add, new_artist}, artists) do
    {:noreply, Impl.add(new_artist, artists)}
  end

  def handle_cast({:update_similar_artists, artist, similar_artists}, artists) do
    {:noreply, Impl.update_similar_artists(artist, similar_artists, artists)}
  end

  def handle_call({:add_and_get, new_artist}, _from, artists) do
    {:reply, new_artist, Impl.add(new_artist, artists)}
  end

  def handle_call({:similar_artists?, artist}, _from, artists) do
    {:reply, Impl.similar_artists?(artist, artists), artists}
  end

  def handle_call({:get_similar_artists, artist}, _from, artists) do
    {:reply, Impl.get_similar_artists(artist, artists), artists}
  end

  def handle_call({:contains?, artist}, _from, artists) do
    {:reply, Impl.contains?(artist, artists), artists}
  end

  def handle_call(:get_all, _from, artists) do
    {:reply, artists, artists}
  end

  def terminate(_reason, artists) do
    IO.puts("Whoops, the artist manager crashed")
    ArtistManager.Stash.update(artists)
  end
end