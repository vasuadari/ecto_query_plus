defmodule EctoQueryPlus.BaseQuery do
  import Ecto.Query

  defmacro ecto_where(query, binding, expr) do
    quote do
      where(unquote(query), unquote(binding), unquote(expr))
    end
  end

  defmacro ecto_offset(query, binding) do
    quote do
      offset(unquote(query), unquote(binding))
    end
  end

  defmacro ecto_limit(query, binding) do
    quote do
      limit(unquote(query), unquote(binding))
    end
  end

  defmacro ecto_select(query, binding) do
    quote do
      select(unquote(query), unquote(binding))
    end
  end

  defmacro ecto_select(query, binding, expr) do
    quote do
      select(unquote(query), unquote(binding), unquote(expr))
    end
  end

  defmacro ecto_order_by(query, binding) do
    quote do
      order_by(unquote(query), unquote(binding))
    end
  end

  defmacro ecto_preload(query, binding) do
    quote do
      preload(unquote(query), unquote(binding))
    end
  end
end
