defmodule EctoSqlPlus do
  import __MODULE__.BaseQuery

  def where(query, nil), do: query
  def where(query, []), do: query

  def where(query, [{field, :gte, value} | other_filters]) do
    query
    |> ecto_where([t], field(t, ^field) >= ^value)
    |> where(other_filters)
  end

  def where(query, [{field, :gt, value} | other_filters]) do
    query
    |> ecto_where([t], field(t, ^field) > ^value)
    |> where(other_filters)
  end

  def where(query, [{field, :lt, value} | other_filters]) do
    query
    |> ecto_where([t], field(t, ^field) < ^value)
    |> where(other_filters)
  end

  def where(query, [{field, :lte, value} | other_filters]) do
    query
    |> ecto_where([t], field(t, ^field) <= ^value)
    |> where(other_filters)
  end

  def where(query, [{field, :ilike, value} | other_conds]) do
    query
    |> ecto_where([t], ilike(field(t, ^field), ^"%#{value}%"))
    |> where(other_conds)
  end

  def where(query, [{field, nil} | other_filters]) do
    query
    |> ecto_where([t], is_nil(field(t, ^field)))
    |> where(other_filters)
  end

  def where(query, [{field, :not_nil} | other_filters]) do
    query
    |> ecto_where([t], not is_nil(field(t, ^field)))
    |> where(other_filters)
  end

  def where(query, [{field, value} | other_filters]) when is_list(value) do
    query
    |> ecto_where([t], field(t, ^field) in ^value)
    |> where(other_filters)
  end

  def where(query, [{field, value} | other_filters]) do
    query
    |> ecto_where([t], field(t, ^field) == ^value)
    |> where(other_filters)
  end

  def offset(query, nil), do: query
  def offset(query, offset), do: query |> ecto_offset(^offset)

  def limit(query, nil), do: query
  def limit(query, limit), do: query |> ecto_limit(^limit)

  def select(query, nil), do: query
  def select(query, [] = _only), do: query |> ecto_select([c], c)
  def select(query, only), do: query |> ecto_select(^only)

  def order_by(query, nil), do: query
  def order_by(query, {field, :asc}), do: query |> ecto_order_by(asc: ^field)
  def order_by(query, {field, :desc}), do: query |> ecto_order_by(desc: ^field)

  def preload(query, nil), do: query
  def preload(query, [] = _associations), do: query
  def preload(query, associations), do: query |> ecto_preload(^associations)
end
