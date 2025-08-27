defmodule HeatwaveWeb.SeriesManager do
  defstruct data: %{}, history: nil

  def new(history) do
    %__MODULE__{history: history}
  end

  def create(manager, name) do
    series = List.duplicate(nil, manager.history)
    %{manager | data: Map.put(manager.data, name, series)}
  end

  def tick(manager) do
    updated =
      Map.new(manager.data, fn {name, series} ->
        {name, (series ++ [List.last(series)]) |> Enum.take(-manager.history)}
      end)

    %{manager | data: updated}
  end

  def update(manager, name, value) do
    updated = List.replace_at(manager.data[name], -1, value)
    %{manager | data: Map.put(manager.data, name, updated)}
  end

  # https://www.chartjs.org/docs/latest/general/data-structures.html
  def to_chart(manager) do
    labels = for _ <- 1..manager.history, do: ""

    datasets =
      Enum.map(manager.data, fn {name, data} ->
        %{label: name, data: data}
      end)

    %{labels: labels, datasets: datasets}
  end
end
