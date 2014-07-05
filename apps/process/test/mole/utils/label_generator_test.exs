
defmodule Mole.LabelGeneratorTest do
  use ExUnit.Case

  alias Mole.LabelGenerator

  # generate_label_for/2
  test "gives the service name & the host name" do
    label = LabelGenerator.generate_label_for %{"name" => "service 1"}, %{host: "host1"}

    assert label == "service 1 - host1"
  end

  test "removes the domain from the hostname" do
    label = LabelGenerator.generate_label_for %{"name" => "service 1"}, %{host: "host1.domain.com"}

    assert label == "service 1 - host1"
  end
end
