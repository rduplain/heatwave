# Seed API keys for simulated sensors.
for i <- 1..9 do
  attrs = %{key: "KEY#{i}", sensor: "sensor#{i}"}

  Heatwave.Repo.insert!(
    %Heatwave.Sensor{} |> struct(attrs),
    on_conflict: :nothing,
    conflict_target: [:key]
  )
end
