defmodule Suum.Release.Tasks do
  @app :suum

  def migrate do
    start_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def createdb do
    start_app()

    for repo <- repos() do
      :ok = ensure_repo_created(repo)
    end
  end

  def setup do
    createdb()
    migrate()
  end

  def rollback(repo, version) do
    start_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp ensure_repo_created(repo) do
    case repo.__adapter__.storage_up(repo.config) do
      :ok -> :ok
      {:error, :already_up} -> :ok
      {:error, term} -> {:error, term}
    end
  end

  defp load_app do
    Application.load(@app)
  end

  defp start_app do
    load_app()
    Application.put_env(@app, :minimal, true)
    Application.ensure_started(:ssl)
    Application.ensure_all_started(@app)
  end
end
