defmodule Mole.Mixfile do
  use Mix.Project

  def project do
    [app: :mole,
     version: "0.0.1",
     elixir: "~> 0.14.0",
     escript: escript,
     elixirc_options: options(Mix.env),
     deps: deps(Mix.env)]
  end

  def options(_) do
    []
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
      { :mock,      github: "jjh42/mock"      }
    ] ++ deps(:default)
  end

  defp deps(_) do
    [
      { :jazz,    github: "meh/jazz" }
    ]
  end
end
