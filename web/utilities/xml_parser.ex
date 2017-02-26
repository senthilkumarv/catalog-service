defmodule Plug.Parsers.SOAP do
  @behaviour Plug.Parsers
  alias Plug.Conn

  def parse(conn, type, "xml", headers, opts) when type in ["application", "text"] do
    case Conn.read_body(conn, opts) do
      {:ok, body, conn} ->
        {:ok, soap_envelop} = :erlsom.compile_xsd_file("priv/sonos/SoapEnvelop.xsd")
        {:ok, sonos} = :erlsom.compile_xsd_file("priv/sonos/Sonos.xsd")
        schema = :erlsom.add_model(soap_envelop, sonos)
        request = :erlsom.scan(body, schema)
        case request do
          {:ok, {:Envelope, [], {:Header, [], soap_header}, {:Body, [], [soap_body]}}, []} ->
            {:ok, %{headers: soap_header, body: soap_body}, conn}
          {:ok, {:Envelope, [], :undefined, {:Body, [], [soap_body]}}, []} ->
            {:ok, %{body: soap_body}, conn}
          # {:error, _} ->
          #  raise Plug.BadRequestError
        end
      {:more, _data, conn} ->
        {:error, :too_large, conn}
      {:error, :timeout} ->
        raise Plug.TimeoutError
      {:error, _} ->
        raise Plug.BadRequestError
    end
  end

  def parse(conn, _type, _subtype, _headers, _opts) do
    {:next, conn}
  end
end
