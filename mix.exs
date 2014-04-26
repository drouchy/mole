defmodule Mole.Mixfile do
  use Mix.Project

  def project do
    [app: :mole,
     version: "0.0.1",
     elixir: "~> 0.13.0",
     escript_main_module: Mole.Cli,
     escript_path: "_build/mole",
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

  defp deps(:test) do
    [
      { :mock,    github: "jjh42/mock"   },
      { :webtest, github: "d0rc/webtest" }
    ] ++ deps(:default)
  end

  defp deps(_) do
    [
      { :jsex,    github: "talentdeficit/jsex" }
    ]
  end
end