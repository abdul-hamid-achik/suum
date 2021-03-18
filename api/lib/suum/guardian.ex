defmodule Suum.Guardian do
  use Guardian, otp_app: :suum

  alias Suum.Accounts

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.uuid)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    uuid = claims["sub"]
    resource = Accounts.get_user!(uuid)
    {:ok, resource}
  end
end
