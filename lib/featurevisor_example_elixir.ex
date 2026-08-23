defmodule FeaturevisorExampleElixir do
  @moduledoc "A small application demonstrating the Featurevisor Elixir SDK."

  @datafile_url "https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-mobile.json"
  @context %{"userId" => "mobile-user", "country" => "nl"}

  def run(datafile_url \\ @datafile_url) do
    response = Req.get!(datafile_url)

    unless response.status in 200..299 do
      raise "Could not fetch Featurevisor datafile: HTTP #{response.status}"
    end

    response.body
    |> evaluate()
    |> print_results()
  end

  def evaluate(datafile, context \\ @context) do
    f = Featurevisor.create_featurevisor(%{datafile: datafile, context: context})

    try do
      %{
        revision: Featurevisor.get_revision(f),
        enabled: Featurevisor.enabled?(f, "mobile_experience"),
        variation: Featurevisor.get_variation(f, "mobile_experience"),
        welcome_message:
          Featurevisor.get_variable_string(f, "mobile_experience", "welcome_message")
      }
    after
      Featurevisor.close(f)
    end
  end

  defp print_results(results) do
    IO.puts("Datafile revision: #{results.revision}")
    IO.puts("Feature 'mobile_experience' enabled: #{results.enabled}")
    IO.puts("Variation: #{results.variation || "none"}")
    IO.puts("Variable 'welcome_message': #{results.welcome_message || "none"}")

    :ok
  end
end
