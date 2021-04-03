# EctoQueryPlus
Lets you compose ecto queries in a functional way.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_query_plus` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_query_plus, "~> 0.1.0"}
  ]
end
```
## Usage

```elixir
defmodule Accounts.User do
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:last_login_at, :native_datetime)
    field(:locked_at, :native_datetime)
  end
end
```

```elixir
defmodule Accounts.User.Query do
  use EctoQueryPlus

  alias Accounts.User

  def list(filters, options \\ %{}) do
    User.Query
    |> where(filters)
    |> offset(options[:offset])
    |> limit(options[:limit])
    |> select(options[:select]])
    |> order_by(options[:order_by])
    |> preload(options[:preload])
  end
end
```

Now, you could simply query like
```elixir
User.Query
|> list(
  [
    {:name, :not_nil},
    {:email, ["foo@example.com"],
    {:last_login_at, :gt, DateTime.utc_now()},
    {:locked_at, nil}
  ],
  %{
    select: [:id],
    order_by: {:last_login_at, :asc},
    limit: 5,
    offset: 10
  }
)
```

## Available operators to filter by

- {field, :gte, value}
- {field, :gt, value}
- {field, :lt, value}
- {field, :lte, value}
- {field, :ilike, pattern}
- {field, nil}
- {field, :not_nil}
- {field, list}

## Available options

- {:select, list}
- {:offset, integer_value}
- {:limit, integer_value}
- {:order_by, {field, :asc}}
- {:order_by, {field, :desc}}
- {:preload, list}

## License
[MIT](LICENSE.md)
