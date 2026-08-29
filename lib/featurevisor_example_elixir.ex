defmodule FeaturevisorExampleElixir do
  @moduledoc "A small application demonstrating the Featurevisor Elixir SDK."

  @datafile_url "https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-sdk-v3.json"
  @context %{
    "userId" => "customer-123",
    "country" => "nl",
    "locale" => "nl-NL",
    "accountPlan" => "pro"
  }

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
    f =
      Featurevisor.create_featurevisor(%{
        datafile: datafile,
        context: context,
        log_level: :error
      })

    try do
      %{
        commerce_enabled: Featurevisor.enabled?(f, "commerce_platform"),
        checkout_variation: Featurevisor.get_variation(f, "checkout_experience"),
        max_items: Featurevisor.get_variable_integer(f, "checkout_experience", "max_items"),
        payment_methods:
          Featurevisor.get_variable_array(f, "checkout_experience", "payment_methods"),
        service_endpoints: Featurevisor.get_global_variable_object(f, "serviceEndpoints"),
        support_contact: Featurevisor.get_global_variable_string(f, "supportContact")
      }
    after
      Featurevisor.close(f)
    end
  end

  defp print_results(results) do
    endpoints = results.service_endpoints

    IO.puts("Commerce platform enabled: #{results.commerce_enabled}")
    IO.puts("Checkout variation: #{results.checkout_variation || "unavailable"}")
    IO.puts("Maximum checkout items: #{results.max_items || "unavailable"}")
    IO.puts("Payment methods: #{inspect(results.payment_methods || [])}")

    IO.puts(
      "Service endpoint: #{endpoints["baseUrl"]} " <>
        "(timeout: #{endpoints["timeoutMs"]} ms, retries: #{endpoints["retries"]})"
    )

    IO.puts("Support contact: #{results.support_contact || "unavailable"}")
    :ok
  end
end
