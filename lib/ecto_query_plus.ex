defmodule EctoQueryPlus do
  defmacro __using__(_opts) do
    quote do
      import EctoQueryPlus.BaseQuery

      def list(struct, filters, options \\ %{}) do
        struct
        |> wherep(filters)
        |> offsetp(options[:offset])
        |> limitp(options[:limit])
        |> selectp(options[:select])
        |> order_byp(options[:order_by])
        |> preloadp(options[:preload])
      end

      def wherep(query, nil), do: query
      def wherep(query, []), do: query

      def wherep(query, [{field, :gte, value} | other_filters]) do
        query
        |> ecto_where([t], field(t, ^field) >= ^value)
        |> wherep(other_filters)
      end

      def wherep(query, [{field, :gt, value} | other_filters]) do
        query
        |> ecto_where([t], field(t, ^field) > ^value)
        |> wherep(other_filters)
      end

      def wherep(query, [{field, :lt, value} | other_filters]) do
        query
        |> ecto_where([t], field(t, ^field) < ^value)
        |> wherep(other_filters)
      end

      def wherep(query, [{field, :lte, value} | other_filters]) do
        query
        |> ecto_where([t], field(t, ^field) <= ^value)
        |> wherep(other_filters)
      end

      def wherep(query, [{field, :ne, value} | other_filters]) do
        query
        |> ecto_where([t], field(t, ^field) != ^value)
        |> wherep(other_filters)
      end

      def wherep(query, [{field, :ilike, value} | other_conds]) do
        query
        |> ecto_where([t], ilike(field(t, ^field), ^"%#{value}%"))
        |> wherep(other_conds)
      end

      def wherep(query, [{field, nil} | other_filters]) do
        query
        |> ecto_where([t], is_nil(field(t, ^field)))
        |> wherep(other_filters)
      end

      def wherep(query, [{field, :not_nil} | other_filters]) do
        query
        |> ecto_where([t], not is_nil(field(t, ^field)))
        |> wherep(other_filters)
      end

      def wherep(query, [{field, value} | other_filters]) when is_list(value) do
        query
        |> ecto_where([t], field(t, ^field) in ^value)
        |> wherep(other_filters)
      end

      def wherep(query, [{field, value} | other_filters]) do
        query
        |> ecto_where([t], field(t, ^field) == ^value)
        |> wherep(other_filters)
      end

      def offsetp(query, nil), do: query
      def offsetp(query, offset), do: query |> ecto_offset(^offset)

      def limitp(query, nil), do: query
      def limitp(query, limit), do: query |> ecto_limit(^limit)

      def selectp(query, nil), do: query
      def selectp(query, [] = _only), do: query |> ecto_select([c], c)
      def selectp(query, only), do: query |> ecto_select(^only)

      def order_byp(query, nil), do: query
      def order_byp(query, {field, :asc}), do: query |> ecto_order_by(asc: ^field)
      def order_byp(query, {field, :desc}), do: query |> ecto_order_by(desc: ^field)

      def preloadp(query, nil), do: query
      def preloadp(query, [] = _associations), do: query
      def preloadp(query, associations), do: query |> ecto_preload(^associations)
    end
  end
end
