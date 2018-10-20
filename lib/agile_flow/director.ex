defmodule AgileFlow.Director do

  use GenServer

  @songs [
    %{"song" => "http://carlogilmar.me/uno.m4a", "category" => "A"},
    %{"song" => "http://carlogilmar.me/dos.m4a", "category" => "B"},
    %{"song" => "http://carlogilmar.me/tres.m4a", "category" => "C"},
    %{"song" => "http://carlogilmar.me/cuatro.m4a", "category" => "D"},
    %{"song" => "http://carlogilmar.me/cinco.m4a", "category" => "E"},
    %{"song" => "http://carlogilmar.me/seis.m4a", "category" => "F"},
    %{"song" => "http://carlogilmar.me/siete.m4a", "category" => "G"},
    %{"song" => "http://carlogilmar.me/ocho.m4a", "category" => "H"}
  ]

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def get_current() do
    GenServer.call( __MODULE__, :get_song )
  end

  def suscribe() do
    GenServer.call( __MODULE__, :suscribe)
  end

  def init(_) do
    {:ok, {:counter, 0} }
  end

  def handle_call( :get_song, _, state) do
    {:reply, state, state}
  end

  def handle_call( :suscribe, _, {:counter, counter} ) do
    { counter, song, next_counter } = suscribe_song( counter )
    {:reply, {counter, song}, {:counter, next_counter}}
  end

  def suscribe_song( 8 ) do
    [ first_song | _ ] = @songs
    { 0, first_song, 1 }
  end

  def suscribe_song( current_counter ) do
    song = Enum.at( @songs, current_counter)
    { current_counter, song, current_counter + 1 }
  end

end
