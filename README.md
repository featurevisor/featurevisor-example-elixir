# featurevisor-example-elixir

A small Elixir application showing how to consume the published [Featurevisor Elixir SDK](https://github.com/featurevisor/featurevisor-elixir) from Hex.pm.

Learn more about Featurevisor [here](https://featurevisor.com).

It fetches a production datafile, creates a Featurevisor instance with customer context, then evaluates:

- the `commerce_platform` feature as a flag;
- the `checkout_experience` variation;
- integer and array variables from `checkout_experience`;
- the `serviceEndpoints` global object variable;
- the `supportContact` global string variable.

## Requirements

Elixir 1.15 or newer.

## Run the example

```sh
mix deps.get
mix run -e 'FeaturevisorExampleElixir.run()'
```

The datafile comes from the [Featurevisor Cloudflare example](https://github.com/featurevisor/featurevisor-example-cloudflare):

```text
https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-sdk-v3.json
```

Expected output:

```text
Commerce platform enabled: true
Checkout variation: express
Maximum checkout items: 25
Payment methods: ["card", "wallet"]
Service endpoint: https://api.eu.example.com (timeout: 1200 ms, retries: 4)
Support contact: support-nl@example.com
```

The important SDK usage is in `lib/featurevisor_example_elixir.ex`. Change its context values to see how Featurevisor selects different rules, variations, and global variable overrides.

The `featurevisor` dependency comes from Hex.pm. It is not a local path dependency, so this project demonstrates the same setup used by a new consumer.

## Checks

```sh
make check
```

Learn more in the [Featurevisor Elixir SDK documentation](https://featurevisor.com/docs/sdks/elixir/).
