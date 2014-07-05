defmodule Mole.Webapp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mole_webapp,
      version: "0.0.1",
      elixir: "~> 0.14.2",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      deps: deps(Mix.env)
    ]
  end

  def application do
    [
      mod: { MoleWebapp, [] },
      applications: [:phoenix]
    ]
  end

  defp deps(_) do
    [
      {:phoenix, "0.3.1"},
      {:cowboy, "~> 0.10.0", github: "extend/cowboy", optional: true}
    ]
  end
end
