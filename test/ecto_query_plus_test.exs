defmodule QueryTest do
  use ExUnit.Case, async: true

  @query "posts"

  defmodule Query do
    use EctoQueryPlus
  end

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
             } = Query.wherep(@query, a: 1)
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
             } = Query.wherep(@query, a: 1, b: 2)
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
             } = Query.wherep(@query, a: [2, 3])
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
             } = Query.wherep(@query, [{:a, :gte, 2}])
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
             } = Query.wherep(@query, [{:a, :gt, 2}])
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
             } = Query.wherep(@query, [{:a, :lt, 2}])
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
             } = Query.wherep(@query, [{:a, :lte, 2}])
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
             } = Query.wherep(@query, [{:a, :ne, 2}])
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
             } = Query.wherep(@query, [{:a, :ilike, 2}])
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
             } = Query.wherep(@query, [{:a, nil}])

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
             } = Query.wherep(@query, [{:a, :not_nil}])

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
             } = Query.offsetp(@query, 1)
    end

    test "returns query as such when given offset is nil" do
      assert @query = Query.offsetp(@query, nil)
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
             } = Query.limitp(@query, 1)
    end

    test "returns query as such when given limit is nil" do
      assert @query = Query.limitp(@query, nil)
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
             } = Query.selectp(@query, [:a])
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
             } = Query.selectp(@query, [:a, :b])
    end

    test "returns query as such when given select is nil" do
      assert @query = Query.selectp(@query, nil)
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
             } = Query.order_byp(@query, {:a, :asc})

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
             } = Query.order_byp(@query, {:a, :desc})

      assert "[desc: &0.a()]" = Macro.to_string(expr)
    end

    test "returns query as such when given order_by is nil" do
      assert @query = Query.order_byp(@query, nil)
    end
  end

  describe "preloadp/2" do
    test "returns Ecto.Query with valid preloads for one entry" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               preloads: [[:a]]
             } = Query.preloadp(@query, [:a])
    end

    test "returns Ecto.Query with valid preloads for more than one entry" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               preloads: [[:a, :b]]
             } = Query.preloadp(@query, [:a, :b])
    end

    test "returns query as such when given preload is nil" do
      assert @query = Query.preloadp(@query, nil)
    end
  end

  describe "list/3" do
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
             } = Query.list(@query, a: 1)
    end
  end
end
