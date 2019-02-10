defmodule Imcon.Auth do

  import Ecto.Changeset
  import Ecto.Query, warn: false
  # import Plug.Conn
  
  alias Comeonin.Bcrypt

  alias Imcon.Repo
  alias Imcon.Auth.{User}

    # ... User

  @sign_in_fields ~w(email password)a

  @email ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  def get_user!(id), do: Repo.get!(User, id)

  def list_users do
    Repo.all(User)
  end

  def email_pass(conn, email, pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, email: email)

    cond do
      user && Bcrypt.checkpw(pass, user.encrypted_password) ->
        {:ok, user}
      user ->
        {:error, :unauthorized, conn}
      true ->
        Bcrypt.dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def sign_in(attrs \\ %{}) do
    %User{}
    |> cast(attrs, @sign_in_fields)
    |> validate_required(@sign_in_fields)
    |> validate_format(:email, @email)
    |> update_change(:email, &String.downcase/1)
    |> authenticate()
  end

  def authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end

  @required_fields ~w(first_name last_name email password)
  @optional_fields ~w(encrypted_password)

  def create_user(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_format(:email, @email)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, message: "Password does not match")
    |> unique_constraint(:email, message: "Email already taken")
    |> generate_encrypted_password
  end

  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> cast(attrs, [:role])
    |> validate_inclusion(:role, ~w(user admin))
  end

  def update_user(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email], [:password])
    |> validate_required([:first_name, :email])
    |> generate_encrypted_password
    |> unique_constraint(:email)
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end

  def username(%{email: email} = _user) do
    String.split(email, "@") |> List.first
  end

end

