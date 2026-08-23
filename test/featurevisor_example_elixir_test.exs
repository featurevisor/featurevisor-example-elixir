defmodule FeaturevisorExampleElixirTest do
  use ExUnit.Case, async: true

  test "evaluates a flag, variation, and variable" do
    assert FeaturevisorExampleElixir.evaluate(datafile()) == %{
             revision: "test",
             enabled: true,
             variation: "treatment",
             welcome_message: "Welcome to Featurevisor"
           }
  end

  defp datafile do
    %{
      "schemaVersion" => "2",
      "featurevisorVersion" => "3.5.0",
      "revision" => "test",
      "segments" => %{},
      "features" => %{
        "mobile_experience" => %{
          "key" => "mobile_experience",
          "bucketBy" => "userId",
          "variations" => [
            %{"value" => "control"},
            %{"value" => "treatment"}
          ],
          "variablesSchema" => %{
            "welcome_message" => %{
              "type" => "string",
              "defaultValue" => "Welcome"
            }
          },
          "force" => [
            %{
              "segments" => "*",
              "enabled" => true,
              "variation" => "treatment",
              "variables" => %{"welcome_message" => "Welcome to Featurevisor"}
            }
          ],
          "traffic" => []
        }
      }
    }
  end
end
