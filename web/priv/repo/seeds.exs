# Seed API keys for simulated sensors.
for i <- 1..9 do
  Heatwave.Repo.insert!(%Heatwave.Sensor{key: "KEY#{i}", sensor: "sensor#{i}"})
end
