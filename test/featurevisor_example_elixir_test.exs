defmodule FeaturevisorExampleElixirTest do
  use ExUnit.Case, async: true

  test "evaluates flags, variations, feature variables, and global variables" do
    assert FeaturevisorExampleElixir.evaluate(datafile()) == %{
             commerce_enabled: true,
             checkout_variation: "express",
             max_items: 25,
             payment_methods: ["card", "wallet"],
             service_endpoints: %{
               "baseUrl" => "https://api.eu.example.com",
               "timeoutMs" => 1200,
               "retries" => 4
             },
             support_contact: "support-nl@example.com"
           }
  end

  defp datafile do
    %{
      "schemaVersion" => "2",
      "featurevisorVersion" => "3.7.0",
      "revision" => "test",
      "segments" => %{},
      "features" => %{
        "commerce_platform" => %{
          "bucketBy" => "userId",
          "force" => [%{"segments" => "*", "enabled" => true}],
          "traffic" => []
        },
        "checkout_experience" => %{
          "bucketBy" => "userId",
          "variations" => [%{"value" => "express", "weight" => 100}],
          "variablesSchema" => %{
            "max_items" => %{"type" => "integer", "defaultValue" => 10},
            "payment_methods" => %{"type" => "array", "defaultValue" => ["card"]}
          },
          "force" => [
            %{
              "segments" => "*",
              "enabled" => true,
              "variation" => "express",
              "variables" => %{
                "max_items" => 25,
                "payment_methods" => ["card", "wallet"]
              }
            }
          ],
          "traffic" => []
        }
      },
      "variables" => %{
        "serviceEndpoints" => %{
          "type" => "object",
          "defaultValue" => %{
            "baseUrl" => "https://api.eu.example.com",
            "timeoutMs" => 1200,
            "retries" => 4
          },
          "overrides" => []
        },
        "supportContact" => %{
          "type" => "string",
          "defaultValue" => "support-nl@example.com",
          "overrides" => []
        }
      }
    }
  end
end
