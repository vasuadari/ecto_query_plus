defmodule EctoQueryPlusTest do
  use ExUnit.Case, async: true

  @query "posts"

  describe "wherep/2" do
    test "returns valid Ecto.Query with where clause for a field" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:==, _, _},
                   op: :and,
                   params: [{1, {0, :a}}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, a: 1)
    end

    test "returns valid Ecto.Query with where clause for two field" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:==, _, _},
                   op: :and,
                   params: [{1, {0, :a}}]
                 },
                 %{
                   expr: {:==, _, _},
                   op: :and,
                   params: [{2, {0, :b}}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, a: 1, b: 2)
    end

    test "returns valid Ecto.Query with where clause for array values" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:in, _, _},
                   op: :and,
                   params: [{[2, 3], {:in, {0, :a}}}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, a: [2, 3])
    end

    test "returns valid Ecto.Query with where clause with gte condition" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:>=, _, _},
                   op: :and,
                   params: [{2, {0, :a}}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, [{:a, :gte, 2}])
    end

    test "returns valid Ecto.Query with where clause with gt condition" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:>, _, _},
                   op: :and,
                   params: [{2, {0, :a}}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, [{:a, :gt, 2}])
    end

    test "returns valid Ecto.Query with where clause with lt condition" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:<, _, _},
                   op: :and,
                   params: [{2, {0, :a}}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, [{:a, :lt, 2}])
    end

    test "returns valid Ecto.Query with where clause with lte condition" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:<=, _, _},
                   op: :and,
                   params: [{2, {0, :a}}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, [{:a, :lte, 2}])
    end

    test "returns valid Ecto.Query with where clause with ne condition" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:!=, _, _},
                   op: :and,
                   params: [{2, {0, :a}}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, [{:a, :ne, 2}])
    end

    test "returns valid Ecto.Query with where clause with ilike condition" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: {:ilike, _, _},
                   op: :and,
                   params: [{"%2%", :string}]
                 }
               ]
             } = EctoQueryPlus.wherep(@query, [{:a, :ilike, 2}])
    end

    test "returns valid Ecto.Query with where clause with nil condition" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: expr,
                   op: :and,
                   params: []
                 }
               ]
             } = EctoQueryPlus.wherep(@query, [{:a, nil}])

      assert "is_nil(&0.a())" == Macro.to_string(expr)
    end

    test "returns valid Ecto.Query with where clause with not_nil condition" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               wheres: [
                 %{
                   expr: expr,
                   op: :and,
                   params: []
                 }
               ]
             } = EctoQueryPlus.wherep(@query, [{:a, :not_nil}])

      assert ("not(is_nil(&0.a()))" == Macro.to_string(expr) or "not is_nil(&0.a())" == Macro.to_string(expr))
    end
  end

  describe "offsetp/2" do
    test "returns valid Ecto.Query with given offset" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               offset: %Ecto.Query.QueryExpr{
                 expr: {:^, [], [0]},
                 params: [{1, :integer}]
               }
             } = EctoQueryPlus.offsetp(@query, 1)
    end

    test "returns query as such when given offset is nil" do
      assert @query = EctoQueryPlus.offsetp(@query, nil)
    end
  end

  describe "limitp/2" do
    test "returns valid Ecto.Query with given limit" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               limit: %Ecto.Query.QueryExpr{
                 expr: {:^, [], [0]},
                 params: [{1, :integer}]
               }
             } = EctoQueryPlus.limitp(@query, 1)
    end

    test "returns query as such when given limit is nil" do
      assert @query = EctoQueryPlus.limitp(@query, nil)
    end
  end

  describe "selectp/2" do
    test "returns Ecto.Query with valid select expr for one field" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               select: %Ecto.Query.SelectExpr{
                 expr: {:&, [], [0]},
                 take: %{0 => {:any, [:a]}}
               }
             } = EctoQueryPlus.selectp(@query, [:a])
    end

    test "returns Ecto.Query with valid select expr for more than one field" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               select: %Ecto.Query.SelectExpr{
                 expr: {:&, [], [0]},
                 take: %{0 => {:any, [:a, :b]}}
               }
             } = EctoQueryPlus.selectp(@query, [:a, :b])
    end

    test "returns query as such when given select is nil" do
      assert @query = EctoQueryPlus.selectp(@query, nil)
    end
  end

  describe "order_byp/2" do
    test "returns Ecto.Query with valid order_bys for asc" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               order_bys: [
                 %Ecto.Query.QueryExpr{
                   expr: expr
                 }
               ]
             } = EctoQueryPlus.order_byp(@query, {:a, :asc})

      assert "[asc: &0.a()]" = Macro.to_string(expr)
    end

    test "returns Ecto.Query with valid order_bys for desc" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               order_bys: [
                 %Ecto.Query.QueryExpr{
                   expr: expr
                 }
               ]
             } = EctoQueryPlus.order_byp(@query, {:a, :desc})

      assert "[desc: &0.a()]" = Macro.to_string(expr)
    end

    test "returns query as such when given order_by is nil" do
      assert @query = EctoQueryPlus.order_byp(@query, nil)
    end
  end

  describe "preloadp/2" do
    test "returns Ecto.Query with valid preloads for one entry" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               preloads: [[:a]]
             } = EctoQueryPlus.preloadp(@query, [:a])
    end

    test "returns Ecto.Query with valid preloads for more than one entry" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               preloads: [[:a, :b]]
             } = EctoQueryPlus.preloadp(@query, [:a, :b])
    end

    test "returns query as such when given preload is nil" do
      assert @query = EctoQueryPlus.preloadp(@query, nil)
    end
  end
end
