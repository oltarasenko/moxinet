defmodule Moxinet do
  @moduledoc """
  Moxinet helps you mock the internet at the HTTP layer
  without sacrificing parallel testing.
  """

  defdelegate start(opts), to: Moxinet.Application

  @doc """
  Returns the header needed to be included in requests to the
  mock servers in order to support parallel runs.
  """
  @spec build_mock_header(pid()) :: {String.t(), String.t()}
  def build_mock_header(pid \\ self()) when is_pid(pid) do
    {"x-moxinet-ref", pid_reference(pid)}
  end

  @doc """
  Turns a pid into a reference which could be used for indexing
  the signatures.
  """
  @spec pid_reference(pid()) :: String.t()
  def pid_reference(pid) when is_pid(pid) do
    pid
    |> :erlang.term_to_binary()
    |> Base.encode64()
  end

  @doc """
  Mocks a call for the passed module when used from a certain pid, defaulting `self()`
  """
  @type http_method :: :get | :post | :patch | :put | :delete | :options
  @spec expect(module(), http_method, function(), pid) :: :ok
  defdelegate expect(module, http_method, callback, from_pid \\ self()),
    to: Moxinet.SignatureStorage,
    as: :store
end
