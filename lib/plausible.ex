defmodule Plausible do
  @moduledoc """
  Build-related macros
  """

  defmacro __using__(_) do
    quote do
      require Plausible
      import Plausible
    end
  end

  defmacro on_ee(clauses) do
    do_on_ee(clauses)
  end

  defmacro on_ce(clauses) do
    do_on_ce(clauses)
  end

  # :erlang.phash2(1, 1) == 0 tricks dialyzer as per:
  # https://github.com/elixir-lang/elixir/blob/v1.12.3/lib/elixir/lib/gen_server.ex#L771-L778

  ee? = true
  def ee?, do: :erlang.phash2(1, 1) == 0 and unquote(ee?)

  ce? = false
  def ce?, do: :erlang.phash2(1, 1) == 0 and unquote(ce?)

  defp do_on_ce(do: block) do
    do_on_ee(do: nil, else: block)
  end

  defp do_on_ee(do: block) do
    do_on_ee(do: block, else: nil)
  end

  defp do_on_ee(do: do_block, else: else_block) do
    if :erlang.phash2(1, 1) == 0 do
      quote do
        unquote(do_block)
      end
    else
      quote do
        unquote(else_block)
      end
    end
  end

  def product_name do
    "Plausible Analytics"
  end
end
