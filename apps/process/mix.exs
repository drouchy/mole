defmodule Mole.Process.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mole,
      version: "0.0.3-dev",
      elixir: "~> 0.14.0",
      escript: escript,
      elixirc_options: options(Mix.env),
      elixirc_paths: src_paths(Mix.env),
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      deps: deps(Mix.env),
      lager_level: lager_level(Mix.env)
    ]
  end

  def options(_env) do
    [] #[exlager_level: lager_level(env)]
  end

  defp lager_level(:dev) do
    :debug
  end

  defp lager_level(:test) do
    :emergency
  end

  defp lager_level(:prod) do
    :error
  end

  def src_paths(:test) do
    src_paths(:dev) ++ ["test/support"]
  end

  def src_paths(_) do
    ["lib"]
  end

  def application do
    [
      applications: [],
      mod: { Mole, [] }
    ]
  end

  def escript do
    [
      main_module: Mole.Cli,
      path: "_build/mole",
      embed_elixir: true,
      embed_extra_apps: [:mix]
    ]
  end

  defp deps(:test) do
    [
      { :mock, github: "jjh42/mock" }
    ] ++ deps(:default)
  end

  defp deps(_) do
    [
      {:jazz, "0.1.2"} ,
      { :exlager, github: "khia/exlager"}
    ]
  end
end
