defmodule EctoSqlPlusTest do
  use ExUnit.Case

  @query "posts"

  describe "where/2" do
    test "returns expected Ecto.Query with where clause for a field" do
      assert %Ecto.Query{
        from: %{
          source: {"posts", nil}
        },
        wheres: [%{
          op: :and,
          params: [{1, {0, :a}}]
        }]
      } = EctoSqlPlus.where(@query, a: 1)
    end

    test "returns expected Ecto.Query with where clause for two field" do
      assert %Ecto.Query{
        from: %{
          source: {"posts", nil}
        },
        wheres: [
          %{
            op: :and,
            params: [{1, {0, :a}}]
          },
          %{
            op: :and,
            params: [{2, {0, :b}}]
          }
        ]
      } = EctoSqlPlus.where(@query, a: 1, b: 2)
    end

    test "returns expected Ecto.Query with where clause for array values" do
      assert %Ecto.Query{
        from: %{
          source: {"posts", nil}
        },
        wheres: [
          %{
            op: :and,
            params: [{[2, 3], {:in, {0, :a}}}]
          }
        ]
      } = EctoSqlPlus.where(@query, a: [2, 3])
    end
  end
end
