defmodule EctoQueryPlusTest do
  use ExUnit.Case, async: true

  @query "posts"

  describe "where/2" do
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
             } = EctoQueryPlus.where(@query, a: 1)
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
             } = EctoQueryPlus.where(@query, a: 1, b: 2)
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
             } = EctoQueryPlus.where(@query, a: [2, 3])
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
             } = EctoQueryPlus.where(@query, [{:a, :gte, 2}])
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
             } = EctoQueryPlus.where(@query, [{:a, :gt, 2}])
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
             } = EctoQueryPlus.where(@query, [{:a, :lt, 2}])
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
             } = EctoQueryPlus.where(@query, [{:a, :lte, 2}])
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
             } = EctoQueryPlus.where(@query, [{:a, :ilike, 2}])
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
             } = EctoQueryPlus.where(@query, [{:a, nil}])

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
             } = EctoQueryPlus.where(@query, [{:a, :not_nil}])

      assert "not(is_nil(&0.a()))" == Macro.to_string(expr)
    end
  end

  describe "offset/2" do
    test "returns valid Ecto.Query with given offset" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               offset: %Ecto.Query.QueryExpr{
                 expr: {:^, [], [0]},
                 params: [{1, :integer}]
               }
             } = EctoQueryPlus.offset(@query, 1)
    end

    test "returns query as such when given offset is nil" do
      assert @query = EctoQueryPlus.offset(@query, nil)
    end
  end

  describe "limit/2" do
    test "returns valid Ecto.Query with given limit" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               limit: %Ecto.Query.QueryExpr{
                 expr: {:^, [], [0]},
                 params: [{1, :integer}]
               }
             } = EctoQueryPlus.limit(@query, 1)
    end

    test "returns query as such when given limit is nil" do
      assert @query = EctoQueryPlus.limit(@query, nil)
    end
  end

  describe "select/2" do
    test "returns Ecto.Query with valid select expr for one field" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               select: %Ecto.Query.SelectExpr{
                 expr: {:&, [], [0]},
                 take: %{0 => {:any, [:a]}}
               }
             } = EctoQueryPlus.select(@query, [:a])
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
             } = EctoQueryPlus.select(@query, [:a, :b])
    end

    test "returns query as such when given select is nil" do
      assert @query = EctoQueryPlus.select(@query, nil)
    end
  end

  describe "order_by/2" do
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
             } = EctoQueryPlus.order_by(@query, {:a, :asc})

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
             } = EctoQueryPlus.order_by(@query, {:a, :desc})

      assert "[desc: &0.a()]" = Macro.to_string(expr)
    end

    test "returns query as such when given order_by is nil" do
      assert @query = EctoQueryPlus.order_by(@query, nil)
    end
  end

  describe "preload/2" do
    test "returns Ecto.Query with valid preloads for one entry" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               preloads: [[:a]]
             } = EctoQueryPlus.preload(@query, [:a])
    end

    test "returns Ecto.Query with valid preloads for more than one entry" do
      assert %Ecto.Query{
               from: %{
                 source: {"posts", nil}
               },
               preloads: [[:a, :b]]
             } = EctoQueryPlus.preload(@query, [:a, :b])
    end

    test "returns query as such when given preload is nil" do
      assert @query = EctoQueryPlus.preload(@query, nil)
    end
  end
end
