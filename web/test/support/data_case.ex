defmodule Heatwave.DataCase do
  @moduledoc """
  Set up test database.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Heatwave.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Heatwave.DataCase
    end
  end

  setup tags do
    Heatwave.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Set up sandbox based on test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Heatwave.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  Transform changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
