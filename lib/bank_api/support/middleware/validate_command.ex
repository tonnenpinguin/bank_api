defmodule BankAPI.Middleware.ValidateCommand do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  alias Ecto.Changeset

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    case command.__struct__.validate(command) do
      %Changeset{valid?: true} ->
        pipeline

      %Changeset{} = changeset ->
        pipeline
        |> Pipeline.respond({:error, :command_validation_failure, command, get_errors(changeset)})
        |> Pipeline.halt()
    end
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline

  defp get_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
