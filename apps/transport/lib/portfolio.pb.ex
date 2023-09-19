defmodule Transport.Portfolio do
  use Protobuf, syntax: :proto3

  @moduledoc """
    This module describes the transport format of the
    requested `Portfolio` of an exchange via Protobuff
    encoded UDP-IP-Multicast.
  """

  field :id,            1, type: :string
  field :value,         2, type: :int32
  field :time_created,  3, type: :int32
  field :time_encoded,  4, type: :int32

end
